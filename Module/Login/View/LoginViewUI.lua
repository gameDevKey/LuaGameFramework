LoginViewUI = Class("LoginViewUI",ViewUI)

function LoginViewUI:OnInit()
    self:SetViewAsset("LoginWindow")
end

function LoginViewUI:FindTargets()
    self.loginBtn = self.transform:Find("btn").gameObject:GetComponent(typeof(CS.UnityEngine.UI.Button))
    self.txtName = self.transform:Find("btn/txt").gameObject:GetComponent(typeof(CS.UnityEngine.UI.Text))
end

function LoginViewUI:InitTargets()
    ButtonExt.SetClick(self.loginBtn, self:ToFunc("onLoginBtnClick"))
    self.txtName.text = "登录按钮"
end

function LoginViewUI:OnEnter(data)
    PrintLog("OnEnter",self.gameObject,data)
    self.data = data
    self:EnterComplete()
end

function LoginViewUI:OnEnterComplete()
end

function LoginViewUI:OnExit()
    PrintLog("OnExit",self.gameObject)
end

function LoginViewUI:OnExitComplete()

end

function LoginViewUI:OnRefresh()

end

function LoginViewUI:OnHide()

end


function LoginViewUI:onLoginBtnClick()
    PrintLog("登录了 -->",self.data)
end

return LoginViewUI