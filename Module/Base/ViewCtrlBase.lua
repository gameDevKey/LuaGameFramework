ViewCtrlBase = Class("ViewCtrlBase",CtrlBase)

function ViewCtrlBase:OnInitComplete()
end

function ViewCtrlBase:EnterView(uiType, data)
    local view = UIManager.Instance:Enter(uiType, data, self)
    EventDispatcher.Global:Broadcast(EGlobalEvent.ViewEnter,uiType,view)
    return view
end

function ViewCtrlBase:ExitView(view)
    UIManager.Instance:Exit(view)
    EventDispatcher.Global:Broadcast(EGlobalEvent.ViewExit,view.uiType,view)
end

function ViewCtrlBase:GoBackTo(uiType)
    UIManager.Instance:GoBackTo(uiType)
    local view = UIManager.Instance:GetTopView()
    if view then
        EventDispatcher.Global:Broadcast(EGlobalEvent.ViewEnter,view.uiType,view)
    end
end

return ViewCtrlBase