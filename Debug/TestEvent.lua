local object1 = ModuleBase.New()
local object2 = ModuleBase.New()

object1:AddListener("AAA", function(...)
    print('object1 listen', ...)
end)
local key = object2:AddListener("AAA", function(...)
    print('object2 listen', ...)
end)
object2:AddListener("BBBB", function(...)
    print('object2 listen', ...)
end)

EventDispatcher.Global:Broadcast("AAA","testtest")

object2:RemoveListener(key)

EventDispatcher.Global:Broadcast("AAA","testtest")
