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

---创建类
---@param className string 类名
---@param superClass table|function|nil Class 父类
function Class(className, superClass)
    local clazz = {}
    clazz._className = className

    if IsFunction(superClass) or IsTable(superClass) then
        setmetatable(clazz,{__index = superClass})
        clazz._super = superClass
    else
        clazz.Ctor = function ()  end
    end

    function clazz.New(...)
        local instance = {}
        setmetatable(instance,{__index = clazz})
        instance._class = clazz
        instance:Ctor(...)
        return instance
    end

    return clazz
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