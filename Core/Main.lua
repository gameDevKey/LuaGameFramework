--初始化前
local function pre_init()
    require("Core.Setup")
    MathUtil.RandomSeed()
    EventDispatcher.Global = EventDispatcher.New()
    CommandManager.Global = CommandManager.New()
end

--初始化中
local function init()

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