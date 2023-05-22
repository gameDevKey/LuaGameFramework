require("Core.Setup")

MathUtil.RandomSeed()
EventDispatcher.Global = EventDispatcher.New()

if TEST_ENV then
    require("Debug.TestMain")
end