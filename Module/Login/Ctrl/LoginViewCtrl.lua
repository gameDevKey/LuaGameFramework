--处理界面相关逻辑
LoginViewCtrl = SingletonClass("LoginViewCtrl",ViewCtrlBase)

function LoginViewCtrl:OnInitComplete()
    self:BindEvents()
end

function LoginViewCtrl:BindEvents()
    -- PrintLog("执行LoginViewCtrl:BindEvents")
    self:AddListenerWithSelfFunc(ELoginModule.ViewEvent.ActiveLoginView, "SetActiveLoginView", false)
end

function LoginViewCtrl:SetActiveLoginView(data)
    PrintLog("执行LoginViewCtrl:SetActiveLoginView",data)
    self:EnterView(UIDefine.ViewType.LoginView,data)
end

return LoginViewCtrl