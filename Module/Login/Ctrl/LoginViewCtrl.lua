--处理界面相关逻辑
LoginViewCtrl = SingletonClass("LoginViewCtrl",ViewCtrlBase)

function LoginViewCtrl:OnInitComplete()
    self:BindEvents()
end

function LoginViewCtrl:BindEvents()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.Lanuch, "ActiveLoginView",false)
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.ClearAll, "OnClearAll",false)
end

function LoginViewCtrl:ActiveLoginView()
    self:EnterView(UIDefine.ViewType.LoginView)
end

function LoginViewCtrl:OnClearAll()
    self:ExitViewByType(UIDefine.ViewType.LoginView)
end

return LoginViewCtrl