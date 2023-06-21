--处理界面相关逻辑
GenericViewCtrl = SingletonClass("GenericViewCtrl",ViewCtrlBase)

function GenericViewCtrl:OnInitComplete()
    self:BindEvents()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.ViewEnter,"OnViewEnter",false)
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.ViewExit,"OnViewExit",false)
    self.view = nil
end

function GenericViewCtrl:BindEvents()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.Lanuch, "ActiveGenericView",false)
end

function GenericViewCtrl:ActiveGenericView()
    self.view = self:EnterView(UIDefine.ViewType.GenericView)
end

function GenericViewCtrl:OnViewEnter(type,view)
    if not self.view then
        return
    end
    self.view:ChangeText("当前是"..view._className.."界面")
end

function GenericViewCtrl:OnViewExit(type,view)
    if not self.view then
        return
    end
    local topview = UIManager.Instance:GetTopView()
    if topview then
        self.view:ChangeText("当前是"..topview._className.."界面")
    end
end

return GenericViewCtrl