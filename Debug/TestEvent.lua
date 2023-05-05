local object1 = Object.New()
local object2 = Object.New()

object1:AddListener(EEvent.Type.EventA, function(...)
    print('object1 listen', ...)
end)
local key = object2:AddListener(EEvent.Type.EventA, function(...)
    print('object2 listen', ...)
end)
object2:AddListener(EEvent.Type1.EventA1, function(...)
    print('object2 listen', ...)
end)

print("广播 EEvent.Type.EventA")
EventManager.Broadcast(EEvent.Type.EventA, EEvent.Type.EventA, "测试事件广播")

print("广播 EEvent.Type1.EventA1")
EventManager.Broadcast(EEvent.Type1.EventA1, EEvent.Type1.EventA1, "测试事件广播")

print("object2 移除监听 EEvent.Type.EventA")
object2:RemoveListener(key)

print("广播 EEvent.Type.EventA")
EventManager.Broadcast(EEvent.Type.EventA, EEvent.Type.EventA, "测试事件广播")
