--[[
    业务类的基类
]]
--
local ModuleBase = Class("ModuleBase")

function ModuleBase:OnInit()
    self.tbEventKey = {}
    self.tbTimerId = {}
    self.eventDispatcher = nil
end

function ModuleBase:OnDestory()
    -- self:RemoveAllListener()
    self:RemoveAllTimer()
end

function ModuleBase:SetEventDispatcher(eventDispatcher)
    self.eventDispatcher = eventDispatcher
end

function ModuleBase:GetEventDispatcher()
    return self.eventDispatcher or EventDispatcher.Global
end

function ModuleBase:AddListener(eventId, callback, callonce)
    local eventKey = self:GetEventDispatcher():AddListener(eventId, callback, callonce)
    self.tbEventKey[eventKey] = eventId
    return eventKey
end

function ModuleBase:RemoveListener(eventKey)
    if self.tbEventKey[eventKey] then
        self:GetEventDispatcher():RemoveListener(self.tbEventKey[eventKey], eventKey)
        self.tbEventKey[eventKey] = nil
    end
end

function ModuleBase:RemoveAllListener()
    for eventKey, eventId in pairs(self.tbEventKey or {}) do
        self:GetEventDispatcher():RemoveListener(eventId, eventKey)
    end
    self.tbEventKey = {}
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

return ModuleBase
