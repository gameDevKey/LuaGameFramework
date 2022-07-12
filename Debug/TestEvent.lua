local implA = Interface("ImplA")
implA.A = 10
function implA:Func1()
    print("implA func1 call!")
end
function implA:Func2()
    print("implA func2 call!")
end

local clsObjectA = Class("ObjectA",Object,implA)
function clsObjectA:Ctor()
    self._super:Ctor()
end
function clsObjectA:Func1()
    print("clsObjectA func1 call!")
end

local clsObjectB = Class("ObjectB",Object)
function clsObjectB:Ctor()
    self._super:Ctor()
end

local objectA = clsObjectA.New()
local objectB = clsObjectB.New()

objectA:AddListener(EEventType.EventA,function (...)
    print("objectA call EventA",objectA:GetObjectId(),...)
end)

objectB:AddListener(EEventType.EventA,function (...)
    print("objectB call EventA",objectB:GetObjectId(),...)
end)

EventManager.Broadcast(EEventType.EventA,'arg1','arg2')

-- local copyA = Copy(objectA,true)
-- print("copyA:",copyA._className,copyA._objectId,copyA._class,copyA._super,copyA.Ctor)

objectA:Func1()
-- objectB:Func1()