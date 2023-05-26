--初始化前
local function pre_init()
    require("Core.Setup")
    MathUtil.RandomSeed()
    EventDispatcher.Global = EventDispatcher.New()
    CommandManager.Global = CommandManager.New()
end

--初始化中
local function init()
    --模块安装
    local facades = {}
    for key, luaPath in pairs(FacadeFiles) do
        local cls = require(luaPath)
        local ins = cls.Instance
        facades[ins] = true
    end
    for facade, _ in pairs(facades) do
        facade:CallFuncDeeply("InitComplete",true)
    end
end

--初始化后
local function after_init()
    if TEST_ENV then
        require("Debug.TestMain")
    end
end

local function main()
    pre_init()
    init()
    after_init()
end

main()