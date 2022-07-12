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
    -- self._super:Ctor()
    clsObjectA._super.Ctor(self)
end
function clsObjectA:Func1()
    print("clsObjectA func1 call!")
end

local clsObjectB = Class("ObjectB",Object)
function clsObjectB:Ctor()
    -- self._super:Ctor()
    clsObjectB._super.Ctor(self)
end

local objectA = clsObjectA.New()
local objectB = clsObjectB.New()

objectA:AddTimer(function ()
    print("call ObjectA")
end,2)

objectB:AddTimer(function ()
    print("call ObjectB")
end,3)

-- objectA:AddListener(EEventType.EventA,function (...)
--     print("objectA call EventA",objectA:GetObjectId(),...)
-- end)

-- objectB:AddListener(EEventType.EventA,function (...)
--     print("objectB call EventA",objectB:GetObjectId(),...)
-- end)

-- EventManager.Broadcast(EEventType.EventA,'arg1','arg2')

-- print("移除objectA的所有监听器")
-- objectA:RemoveAllListener()
-- EventManager.Broadcast(EEventType.EventA,'arg3','arg4')

-- local copyA = Copy(objectA,true)
-- print("copyA:",copyA._className,copyA._objectId,copyA._class,copyA._super,copyA.Ctor)

-- objectA:Func1()
-- objectB:Func1()