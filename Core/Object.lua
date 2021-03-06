--[[
    业务类的基类
]]--
local Object = Class("Object")

function Object:Ctor()
    self:OnInit()
end

function Object:GetObjectId()
    return self._objectId
end

function Object:OnInit()
    self.tbEventKey = {}
    self.tbTimerId = {}
end

function Object:OnDestory()
    self:RemoveAllListener()
    self:RemoveAllTimer()
end

function Object:AddListener(eventId,callback,callonce)
    local eventKey = EventManager.AddListener(eventId,callback,callonce)
    self.tbEventKey[eventKey] = eventId
end

function Object:RemoveAllListener()
    for eventKey, eventId in pairs(self.tbEventKey or {}) do
        EventManager.RemoveListener(eventId,eventKey)
    end
    self.tbEventKey = {}
end

function Object:AddTimer(callback,tickTime)
    local timerId = TimerManager.AddTimer(callback,tickTime)
    self.tbTimerId[timerId] = true
end

function Object:RemoveTimer(timerId)
    TimerManager.RemoveTimer(timerId)
    self.tbTimerId[timerId] = nil
end

function Object:RemoveAllTimer()
    for timerId, _ in pairs(self.tbTimerId or {}) do
        self:RemoveTimer(timerId)
    end
    self.tbTimerId = {}
end

return Object