GenericViewUI = Class("GenericViewUI",ViewUI)

function GenericViewUI:OnInit()
    self:SetAssetPath("GenericWindow")
end

function GenericViewUI:OnFindComponent()
    self.topBtn = self:GetButton("topCanvas/btn")
    self.bottomBtn = self:GetButton("bottomCanvas/container/btn_temp")
    self.txt = self:GetText("topCanvas/txt")
end

function GenericViewUI:OnInitComponent()
    ButtonExt.SetClick(self.topBtn,self:ToFunc("onTopButtonClick"))
    ButtonExt.SetClick(self.bottomBtn,self:ToFunc("onBottomButtonClick"))
end

function GenericViewUI:OnEnter(data)
    self.data = data
    self:EnterComplete()
end

function GenericViewUI:OnEnterComplete()
    local view = UIManager.Instance:GetTopView()
    if view then
        self:ChangeText("当前是"..view._className.."界面")
    end
end

function GenericViewUI:OnExit()
end

function GenericViewUI:OnExitComplete()
end

function GenericViewUI:OnRefresh()
    self.gameObject:SetActive(true)
end

function GenericViewUI:OnHide()
    self.gameObject:SetActive(false)
end

function GenericViewUI:ChangeText(str)
    self.txt.text = str
end

function GenericViewUI:onTopButtonClick()
    GamePlayCtrl.Instance:GameOver()
    self.viewCtrl:GoBackTo(UIDefine.ViewType.LoginView)
end

function GenericViewUI:onBottomButtonClick()
    EventDispatcher.Global:Broadcast(EGlobalEvent.ClearAll)
end

return GenericViewUI