function IsTable(input)
    return type(input) == "table"
end

function IsString(input)
    return type(input) == "string"
end

function IsNumber(input)
    return type(input) == "number"
end

function IsBoolean(input)
    return type(input) == "boolean"
end

function IsFunction(input)
    return type(input) == "function"
end

local function GetCurrentTimeString()
    return os.date("%H:%M:%S", os.time())
end

function PrintAny(...)
    if not PRINT_SWITCH then
        return
    end
    local time = nil
    if PRINT_LOG_WITH_TIME then
        time = GetCurrentTimeString()
    end
    local tb = {}
    for _, obj in ipairs({ ... }) do
        if IsTable(obj) then
            table.insert(tb, table.ToString(obj))
        else
            table.insert(tb, tostring(obj))
        end
    end
    local str = table.concat(tb, ' ')
    if time then
        print(time, str)
    else
        print(str)
    end
end

function PrintLog(...)
    PrintAny("[LOG]", ...)
end

function PrintWarning(...)
    PrintAny("[WARNING]", ...)
end

function PrintError(...)
    PrintAny("[ERROR]", ...)
end

local function _copy(lookup_table, object, copyMeta)
    if not IsTable(object) then
        return object
    end
    if lookup_table[object] then
        return lookup_table[object]
    end
    local newObject = {}
    lookup_table[object] = newObject
    for k, v in pairs(object) do
        newObject[_copy(lookup_table, k, copyMeta)] = _copy(lookup_table, v, copyMeta)
    end
    if copyMeta then
        return setmetatable(newObject, getmetatable(object))
    end
    return newObject
end

---深复制
---@param object Object 任意对象
---@param copyMeta boolean 是否需要复制metatable
---@return Object
function Copy(object, copyMeta)
    local lookup_table = {}
    return _copy(lookup_table, object, copyMeta)
end

---返回自增整数的闭包函数
---@return function 自增整数的闭包函数
function GetAutoIncreaseFunc()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

---创建接口，本质是一个空表，仅有一个_interfaceName字段便于调试
---配合Class()使用时，会把该表的所有函数注册到类中
---@param interfaceName string 接口名
---@return Interface interface 接口
function Interface(interfaceName)
    local interface = {}
    interface._interfaceName = interfaceName
    return interface
end

local clsKeyGenerator = GetAutoIncreaseFunc()

---创建类，子类支持重载ToString()，暂不支持多重继承，支持实现多个接口类
---包含字段：_className:string 类名 | _class:Class 所属类 | _super:Class 父类 | _objectId:integer 实例ID
---包含方法：Ctor 构造函数 | Delete 析构函数 | ToFunc 获得函数
---虚函数：OnInit OnDelete
---@param className string 类名
---@param superClass table|nil Class 父类
---@param ... Interface 接口类
---@return Class cls 类
function Class(className, superClass, ...)
    local clazz = {}
    clazz._className = className

    if IsTable(superClass) then
        setmetatable(clazz, { __index = superClass })
        clazz._super = superClass
    end

    for _, interface in pairs({ ... }) do
        for fieldName, field in pairs(interface) do
            if IsFunction(field) then
                clazz[fieldName] = field
            end
        end
    end

    function clazz.New(...)
        local instance = {}
        instance._class = clazz
        instance._objectId = clsKeyGenerator()
        instance._alive = false
        instance._funcs = {}
        local defaultStr = string.format("Object[ID:%d]", instance._objectId)
        setmetatable(instance,
            {
                __index = clazz, --TODO 禁止私有字段的访问
                -- __newindex = function(k, v)
                --     --禁止内置函数同名的函数
                -- end,
                __tostring = function(this)
                    if this.ToString then
                        return this:ToString()
                    end
                    return defaultStr
                end,
            })

        function instance:Ctor(...)
            if not self._alive then
                self._alive = true
                if self.OnInit then
                    self:OnInit(...)
                end
            end
        end

        function instance:Delete(...)
            if self._alive then
                self._alive = false
                if self.OnDelete then
                    self:OnDelete(...)
                end
            end
        end

        function instance:ToFunc(name)
            if not self._alive then
                return nil
            end
            local func = self._funcs[name]
            if not func then
                func = self[name]
                if IsFunction(func) then
                    self._funcs[name] = func
                else
                    PrintError("类", instance._className, "未定义函数", name)
                end
            end
            return func
        end

        instance:Ctor(...)
        return instance
    end

    return clazz
end

---同步调用异步函数
---@param asyncFunc function 异步函数
---@param callbackPos integer|nil 回调位置，默认在所有参数之后
---@return function syncFunc 同步函数
function AsyncToSync(asyncFunc, callbackPos)
    return function(...)
        local rets
        local waiting = false
        local co = coroutine.running() or error("this function must be run in coroutine")

        local callback = function(...)
            if waiting then
                assert(coroutine.resume(co, ...))
            else
                rets = { ... }
            end
        end

        local args = { ... }
        table.insert(args, callbackPos or (#args + 1), callback)

        asyncFunc(table.unpack(args))

        -- rets 为空，代表函数调用没有立即返回结果，此时挂起协程
        if rets == nil then
            waiting = true
            rets = { coroutine.yield() }
        end

        return table.unpack(rets)
    end
end
