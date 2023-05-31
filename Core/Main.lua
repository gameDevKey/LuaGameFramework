--初始化前
local function pre_init()
    require("Core.Setup")

    NIL_TABLE = {}
    table.ReadOnly(NIL_TABLE,"空表")

    MathUtil.RandomSeed()

    EventDispatcher.Global = GetGlobalInstance(EventDispatcher)
    CommandManager.Global = GetGlobalInstance(CommandManager)
end

--初始化中
local function init()
    --模块安装
    SetupFacadeModules()
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
