--初始化前
local function PreInit()
    require("Core.Setup")

    NIL_TABLE = {}
    table.ReadOnly(NIL_TABLE, "空表")

    MathUtil.RandomSeed()

    EventDispatcher.Global = GetGlobalInstance(EventDispatcher)
    CommandManager.Global = GetGlobalInstance(CommandManager)
    Calculator.Global = GetGlobalInstance(Calculator)
end

--初始化中
local function Init()
    --模块安装
    SetupFacadeModules()
end

--初始化后
local function AfterInit()
    if TEST_ENV then
        require("Debug.TestMain")
    end
end

local function Main()
    PreInit()
    Init()
    AfterInit()
end
Main()

if PURE_LUA_TEST_ENV then
    local tickTime = 1
    local socket = require("socket")
    while true do
        socket.sleep(tickTime)
        GameManager.Instance:Tick(tickTime)
    end
else
    local CSTime = CS.UnityEngine.Time
    function Update()
        GameManager.Instance:Tick(CSTime.deltaTime)
    end
end