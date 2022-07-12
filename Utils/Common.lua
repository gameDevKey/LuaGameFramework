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
    return os.date("%H:%M:%S",os.time())
end

function PrintLog(...)
    local time = ""
    if PRINT_LOG_WITH_TIME then
        time = GetCurrentTimeString()
    end
    print("[LOG]",time,...)
end

function PrintWarning(...)
    local time = ""
    if PRINT_LOG_WITH_TIME then
        time = GetCurrentTimeString()
    end
    print("[WARNING]",time,...)
end

function PrintError(...)
    local time = ""
    if PRINT_LOG_WITH_TIME then
        time = GetCurrentTimeString()
    end
    print("[ERROR]",time,...)
end

local function _copy(lookup_table,object,copyMeta)
    if not IsTable(object) then
        return object
    end
    if lookup_table[object] then
        return lookup_table[object]
    end
    local newObject = {}
    lookup_table[object] = newObject
    for k, v in pairs(object) do
        newObject[_copy(lookup_table,k,copyMeta)] = _copy(lookup_table,v,copyMeta)
    end
    if copyMeta then
        return setmetatable(newObject,getmetatable(object))
    end
    return newObject
end

---深复制
---@param object Object 任意对象
---@param copyMeta boolean 是否需要复制metatable
---@return Object
function Copy(object,copyMeta)
    local lookup_table = {}
    return _copy(lookup_table,object,copyMeta)
end

---返回自增整数的闭包函数
---@return function 自增整数的闭包函数
function GetAutoIncreaseFunc()
    local count = 0
    return function ()
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
---包含方法：Ctor:function 构造函数
---@param className string 类名
---@param superClass table|nil Class 父类
---@param ... Interface 接口类
---@return Class cls 类
function Class(className, superClass, ...)
    local clazz = {}
    clazz._className = className

    if IsTable(superClass) then
        setmetatable(clazz,{__index = superClass})
        clazz._super = superClass
    else
        clazz.Ctor = function ()  end
    end

    for _, interface in pairs({...}) do
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
        local defaultStr = string.format("Object[ID:%d]",instance._objectId)
        setmetatable(instance,
        {
            __index = clazz,
            __tostring = function (this)
                if this.ToString then
                    return this:ToString()
                end
                return defaultStr
            end,
        })
        instance:Ctor(...)
        return instance
    end

    return clazz
end