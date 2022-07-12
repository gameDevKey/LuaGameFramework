--[[
    对事件对象的封装
]]--
local EventObject = Class("EventObject")

function EventObject:Ctor(eventId,listenerId,callback,callOnce)
    self.eventId = eventId
    self.listenerId = listenerId
    self:SetCallOnce(callOnce)
    self:SetCallback(callback)
end

function EventObject:GetEventId()
    return self.eventId
end

function EventObject:GetListenerId()
    return self.listenerId
end

function EventObject:IsCallOnce()
    return self.callOnce or false
end

function EventObject:Invoke(...)
    if not self.allowInvoke then
        return
    end
    if self.callback then
        self.callback(...)
    end
    if self.callOnce then
        self.allowInvoke = false
    end
end

function EventObject:SetCallback(callback)
    self.callback = callback
    self.allowInvoke = true
end

function EventObject:SetCallOnce(callOnce)
    self.callOnce = callOnce
end

return EventObject