EventObject = Class("EventObject")

function EventObject:OnInit(eventId, callback, caller, callOnce)
    self.eventId = eventId
    self:SetCallOnce(callOnce)
    self:SetCallback(callback, caller)
end

function EventObject:OnDelete()
    if self.callback then
        self.callback:Delete()
    end
end

function EventObject:GetEventId()
    return self.eventId
end

function EventObject:IsCallOnce()
    return self.callOnce or false
end

function EventObject:Invoke(...)
    if not self.allowInvoke then
        return
    end
    if self.callback then
        self.callback:Invoke(...)
    end
    if self.callOnce then
        self.allowInvoke = false
    end
end

function EventObject:SetCallback(callback,caller)
    self.callback = CallObject.New(callback,caller)
    self.allowInvoke = true
end

function EventObject:SetCallOnce(callOnce)
    self.callOnce = callOnce or false
end

return EventObject
