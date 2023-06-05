--处理一些纯业务逻辑（不涉及界面的逻辑）
LoginLogicCtrl = SingletonClass("LoginLogicCtrl",CtrlBase)

function LoginLogicCtrl:OnInitComplete()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.Login, "HandleLogin")
end

function LoginLogicCtrl:HandleLogin()
    self:Broadcast(ELoginModule.ViewEvent.ActiveLoginView,{account='lua',password='framework'})
end

return LoginLogicCtrl