LoginViewUI = Class("LoginViewUI",ViewUI)
LoginViewUI.UseTemplate = false

function LoginViewUI:OnInit()
    self:SetAssetPath("LoginWindow")
end

function LoginViewUI:OnFindComponent()
    self.loginBtn = self:GetButton("btn")
    self.txtName = self:GetText("btn/txt")
    self.container = self:GetTransform("container")
    if self.UseTemplate then
        self.template = self:GetTransform("container/LoginCom").gameObject
        self.template:SetActive(false)
    end
end

function LoginViewUI:OnInitComponent()
    ButtonExt.SetClick(self.loginBtn, self:ToFunc("onLoginBtnClick"))
end

function LoginViewUI:OnEnter(data)
    self.data = data
    self:EnterComplete()
end

function LoginViewUI:OnEnterComplete()
    if self.UseTemplate then
        self:BatchCreateComUIByAmount(UIDefine.ComType.LoginCom,self.container,3,self.template)
    else
        self:BatchCreateComUIByAmount(UIDefine.ComType.LoginCom,self.container,3)
    end
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