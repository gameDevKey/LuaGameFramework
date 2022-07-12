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
    self.tbEventId = {}
end

function Object:OnDestory()
    for eventId, _ in pairs(self.tbEventId or {}) do
        self:RemoveListener(eventId)
    end
    self.tbEventId = nil
end

function Object:AddListener(eventId,callback,callonce)
    self.tbEventId[eventId] = true
    EventManager.AddListener(eventId,self:GetObjectId(),callback,callonce)
end

function Object:RemoveListener(eventId)
    self.tbEventId[eventId] = nil
    EventManager.RemoveListener(eventId,self:GetObjectId())
end

return Object