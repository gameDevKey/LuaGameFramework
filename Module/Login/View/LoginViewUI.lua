LoginViewUI = Class("LoginViewUI",ViewUI)

function LoginViewUI:OnInit()
    self:SetViewAsset("LoginWindow")
end

function LoginViewUI:FindTargets()
    self.loginBtn = self:GetButton("btn")
    self.txtName = self:GetText("btn/txt")
end

function LoginViewUI:InitTargets()
    ButtonExt.SetClick(self.loginBtn, self:ToFunc("onLoginBtnClick"))
end

function LoginViewUI:OnEnter(data)
    self.data = data
    self:EnterComplete()
end

function LoginViewUI:OnEnterComplete()
end

function LoginViewUI:OnExit()
end

function LoginViewUI:OnExitComplete()
end

function LoginViewUI:OnRefresh()
    self.gameObject:SetActive(true)
end

function LoginViewUI:OnHide()
    self.gameObject:SetActive(false)
end

function LoginViewUI:onLoginBtnClick()
    EventDispatcher.Global:Broadcast(EGlobalEvent.Login, ELoginModule.LoginState.OK)
end

return LoginViewUI