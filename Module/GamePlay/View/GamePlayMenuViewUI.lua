GamePlayMenuViewUI = Class("GamePlayMenuViewUI",ViewUI)

function GamePlayMenuViewUI:OnInit()
    self:SetAssetPath("GameMenuWindow")
end

function GamePlayMenuViewUI:OnFindComponent()
    self.startBtn = self:GetButton("btn_start")
    self.returnBtn = self:GetButton("btn_return")
    self.container = self:GetTransform("container")
end

function GamePlayMenuViewUI:OnInitComponent()
    ButtonExt.SetClick(self.startBtn, self:ToFunc("OnStartBtnClick"))
    ButtonExt.SetClick(self.returnBtn, self:ToFunc("OnReturnBtnClick"))
end

function GamePlayMenuViewUI:OnEnter(data)
    self.data = data
    self:EnterComplete()
end

function GamePlayMenuViewUI:OnEnterComplete()
    local num = math.random(1,4)
    self:BatchCreateComUIByAmount(UIDefine.ComType.LoginCom,self.container,num)
end

function GamePlayMenuViewUI:OnExit()
end

function GamePlayMenuViewUI:OnExitComplete()
end

function GamePlayMenuViewUI:OnRefresh()
    self.gameObject:SetActive(true)
end

function GamePlayMenuViewUI:OnHide()
    self.gameObject:SetActive(false)
end

function GamePlayMenuViewUI:OnStartBtnClick()
    self:Broadcast(EGamePlayModule.LogicEvent.StartGame)
end

function GamePlayMenuViewUI:OnReturnBtnClick()
    self:Exit()
end

return GamePlayMenuViewUI