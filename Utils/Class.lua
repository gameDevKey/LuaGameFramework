
---创建接口，只能包含函数
---配合Class()使用时，会把该表的所有函数注册到类中
---@param interfaceName string 接口名
---@return Interface interface 接口
function Interface(interfaceName)
    local interface = {}
    interface._isInterface = true
    interface._interfaceName = interfaceName
    return interface
end

---创建类: 子类支持重载ToString()，暂不支持多重继承，支持实现多个接口类
---包含字段: _className:string 类名 | _class:Class 所属类 | _super:Class 父类 | _objectId:integer 实例ID
---包含方法: New 静态实例化函数 | Delete 析构函数 | ToFunc 返回某个函数 | SuperFunc 调用父类函数
---虚函数: OnInit | OnDelete
---@param className string 类名
---@param superClass Class|nil Class 父类
---@param interfaces List<Interface>|nil 接口类列表，只能包含函数
---@return Class cls 类
function Class(className, superClass, interfaces)
    local clazz = {}
    clazz._isClass = true
    clazz._className = className
    clazz._interfaces = interfaces or {}

    local nameStr = string.format("类[%s-%s]", className, tostring(clazz))
    setmetatable(clazz, {
        __index = superClass,
        __tostring = function(this)
            if this.ToString then
                return this:ToString()
            end
            return nameStr
        end,
     })
    clazz._super = superClass

    for _, interface in ipairs(clazz._interfaces or {}) do
        if not interface._isInterface then
            PrintError(clazz,"无法实现非接口类",interface._className or interface._interfaceName)
        else
            for fieldName, field in pairs(interface) do
                if IsFunction(field) then
                    clazz[fieldName] = field
                end
            end
        end
    end

    function clazz.New(...)
        local instance = {}
        instance._class = clazz
        instance._objectId = tostring(instance)
        instance._alive = false
        instance._funcs = {}
        local defaultStr = string.format("%s实例[%s]", tostring(clazz), instance._objectId)
        setmetatable(instance,
            {
                __index = clazz,
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
                PrintError(self, "已被删除，无法获取函数", name)
                return nil
            end
            local func = self._funcs[name]
            if not func then
                func = self[name]
                if IsFunction(func) then
                    self._funcs[name] = func
                else
                    PrintError(self, "未定义函数", name)
                end
            end
            return func
        end

        function instance:SuperFunc(fnName, ...)
            if clazz._super then
                local fn = clazz._super[fnName]
                return fn and fn(instance, ...)
            end
        end

        instance:Ctor(...)
        return instance
    end

    return clazz
end

local singletonClasses = {}

---创建单例类: 每个单例类的实例全局唯一, 子类支持重载ToString()，暂不支持多重继承，支持实现多个接口类
---包含字段: _className:string 类名 | _class:Class 所属类 | _super:Class 父类 | _objectId:integer 实例ID
---包含方法: Instance 单例获取函数 | Delete 析构函数 | ToFunc 返回某个函数 | SuperFunc 调用父类函数
---虚函数: OnInit | OnDelete
---@param className string 类名
---@param superClass Class|nil Class 父类
---@param interfaces List<Interface>|nil 接口类列表，只能包含函数
---@return Class cls 单例类
function SingletonClass(className, superClass, interfaces)
    local clazz = {}
    clazz._isClass = true
    clazz._className = className
    clazz._interfaces = interfaces or {}

    local nameStr = string.format("单例类[%s-%s]", className, tostring(clazz))
    setmetatable(clazz, {
        __index = superClass,
        __tostring = function(this)
            if this.ToString then
                return this:ToString()
            end
            return nameStr
        end,
     })
    clazz._super = superClass

    for _, interface in ipairs(clazz._interfaces or {}) do
        if not interface._isInterface then
            PrintError(clazz,"无法实现非接口类",interface._className or interface._interfaceName)
        else
            for fieldName, field in pairs(interface) do
                if IsFunction(field) then
                    clazz[fieldName] = field
                end
            end
        end
    end

    function clazz.Instance(...)
        if not singletonClasses[clazz._className] then
            local ins = clazz.New()
            ins:Ctor(...)
        end
        return singletonClasses[clazz._className]
    end

    ---单例类不应该直接用New()创建实例， 请改用Instance()
    function clazz.New()
        if singletonClasses[clazz._className] then
            PrintError(clazz,"不可重复实例化, 访问请用Instance()")
            return
        end
        local instance = {}
        instance._class = clazz
        instance._objectId = tostring(instance)
        instance._alive = false
        instance._funcs = {}
        local defaultStr = string.format("%s实例[%s]", tostring(clazz), instance._objectId)
        setmetatable(instance,
            {
                __index = clazz,
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
                singletonClasses[clazz._className] = self
                if self.OnInit then
                    self:OnInit(...)
                end
            end
        end

        function instance:Delete(...)
            if self._alive then
                self._alive = false
                singletonClasses[clazz._className] = nil
                if self.OnDelete then
                    self:OnDelete(...)
                end
            end
        end

        function instance:ToFunc(name)
            if not self._alive then
                PrintError(self, "已被删除，无法获取函数", name)
                return nil
            end
            local func = self._funcs[name]
            if not func then
                func = self[name]
                if IsFunction(func) then
                    self._funcs[name] = func
                else
                    PrintError(self, "未定义函数", name)
                end
            end
            return func
        end

        function instance:SuperFunc(fnName, ...)
            if clazz._super then
                local fn = clazz._super[fnName]
                return fn and fn(instance, ...)
            end
        end

        return instance
    end

    return clazz
end

local staticClasses = {}

---创建静态类: 不允许创建实例，全局唯一，不可删除，暂不支持多重继承，支持实现多个接口类
---包含字段: _className:string 类名
---包含方法: SuperFunc 调用父类函数
---@param className string 类名
---@return Class|nil cls 静态类
function StaticClass(className)
    if staticClasses[className] then
        PrintError("静态类",className,"无法重复创建")
        return nil
    end

    local clazz = {}
    clazz._isClass = true
    clazz._className = className
    local defaultStr = string.format("静态类[%s-%s]", className, tostring(clazz))
    staticClasses[clazz._className] = clazz

    setmetatable(clazz, {
        __tostring = function(this)
            if this.ToString then
                return this:ToString()
            end
            return defaultStr
        end,
    })

    return clazz
end