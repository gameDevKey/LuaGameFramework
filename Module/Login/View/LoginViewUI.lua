LoginViewUI = Class("LoginViewUI",ViewUI)

function LoginViewUI:OnInit()
    self:SetViewAsset("LoginWindow")
end

function LoginViewUI:OnEnter(data)
    PrintLog("OnEnter",data,self.gameObject)
    self:EnterComplete()
end

function LoginViewUI:OnEnterComplete()
    PrintLog("OnEnterComplete",self.gameObject)
end

function LoginViewUI:OnExit()

end

function LoginViewUI:OnExitComplete()

end

function LoginViewUI:OnRefresh()

end

function LoginViewUI:OnHide()

end

function LoginViewUI:OnAssetLoaded(assets)
end

return LoginViewUI