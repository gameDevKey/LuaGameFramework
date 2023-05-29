--MVC基类，只提供最通用的函数
--函数OnInitComplete()会在Facade安装完成后自顶向下被调用
ModuleBase = Class("ModuleBase")

function ModuleBase:OnInit()
    self.facade = nil
    self.tbEventKey = {}
    self.tbEventGlobalKey = {}
    self.tbTimerId = {}
end

function ModuleBase:OnDestory()
    self:RemoveAllListener()
    self:RemoveAllGolbalListener()
    self:RemoveAllTimer()
end

function ModuleBase:SetFacade(facade)
    self.facade = facade
end

function ModuleBase:InitComplete()
    self:CallFuncDeeply("OnInitComplete",true)
end

local function addListener(tbEventKey, eventDispatcher, eventId, callback, caller, callonce)
    local eventKey = eventDispatcher:AddListener(eventId, callback, caller, callonce)
    tbEventKey[eventKey] = eventId
    return eventKey
end

local function removeListener(tbEventKey, eventDispatcher, eventKey)
    if tbEventKey[eventKey] then
        eventDispatcher:RemoveListener(tbEventKey[eventKey], eventKey)
        tbEventKey[eventKey] = nil
    end
end

local function removeAllListener(tbEventKey, eventDispatcher)
    for eventKey, eventId in pairs(tbEventKey or {}) do
        eventDispatcher:RemoveListener(eventId, eventKey)
    end
    tbEventKey = {}
end

function ModuleBase:AddListener(eventId, callback, caller, callonce)
    return addListener(self.tbEventKey, self.facade.eventDispatcher, eventId, callback, caller, callonce)
end

function ModuleBase:AddListenerWithSelfFunc(eventId, fnName, callonce)
    return self:AddListener(eventId, self:ToFunc(fnName), self, callonce)
end

function ModuleBase:RemoveListener(eventKey)
    removeListener(self.tbEventKey, self.facade.eventDispatcher, eventKey)
end

function ModuleBase:RemoveAllListener()
    removeAllListener(self.tbEventKey, self.facade.eventDispatcher)
end

function ModuleBase:AddGolbalListener(eventId, callback, caller, callonce)
    return addListener(self.tbEventGlobalKey, EventDispatcher.Global, eventId, callback, caller, callonce)
end

function ModuleBase:AddGolbalListenerWithSelfFunc(eventId, fnName, callonce)
    return self:AddGolbalListener(eventId, self:ToFunc(fnName), self, callonce)
end

function ModuleBase:RemoveGolbalListener(eventKey)
    removeListener(self.tbEventGlobalKey, EventDispatcher.Global, eventKey)
end

function ModuleBase:RemoveAllGolbalListener()
    removeAllListener(self.tbEventGlobalKey, EventDispatcher.Global)
end

function ModuleBase:AddTimer(callback, tickTime)
    local timerId = TimerManager.Instance:AddTimer(callback, tickTime)
    self.tbTimerId[timerId] = true
    return timerId
end

function ModuleBase:RemoveTimer(timerId)
    TimerManager.Instance:RemoveTimer(timerId)
    self.tbTimerId[timerId] = nil
end

function ModuleBase:RemoveAllTimer()
    for timerId, _ in pairs(self.tbTimerId or {}) do
        self:RemoveTimer(timerId)
    end
    self.tbTimerId = {}
end

--#region 虚函数

function ModuleBase:OnInitComplete() end

--#endregion

return ModuleBase
