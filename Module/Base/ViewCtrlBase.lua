ViewCtrlBase = Class("ViewCtrlBase",CtrlBase)

function ViewCtrlBase:OnInitComplete()
end

function ViewCtrlBase:BindView(viewUI)
    viewUI:SetFacade(self.facade)
end

function ViewCtrlBase:EnterView(uiType, data)
    local view = UIManager.Instance:Enter(uiType, data)
    self:BindView(view)
end

function ViewCtrlBase:ExitView(targetView)
    UIManager.Instance:Exit(targetView)
end

return ViewCtrlBase