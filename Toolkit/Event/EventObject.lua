EventObject = Class("EventObject")

function EventObject:OnInit(eventId, callback, caller, callOnce)
    self.eventId = eventId
    self:SetCallOnce(callOnce)
    self:SetCallback(callback, caller)
end

function EventObject:OnDelete()
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
        if self.caller then
            self.callback(self.caller,...)
        else
            self.callback(...)
        end
    end
    if self.callOnce then
        self.allowInvoke = false
    end
end

function EventObject:SetCallback(callback,caller)
    self.callback = callback
    self.caller = caller
    self.allowInvoke = true
end

function EventObject:SetCallOnce(callOnce)
    self.callOnce = callOnce or false
end

return EventObject
