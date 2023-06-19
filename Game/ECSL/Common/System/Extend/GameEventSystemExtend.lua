GameEventSystemExtend = ExtendClass(GameEventSystem)

function GameEventSystemExtend:BindAllHandler()
    self:BindHandlerBySelfFunc(EventConfig.Type.Input, "HandleInputEvent")
end

function GameEventSystemExtend:HandleInputEvent(judgeData, ...)
    -- PrintLog("HandleInputEvent judgeData=",judgeData,'args=',...)
    return true
end

return GameEventSystemExtend