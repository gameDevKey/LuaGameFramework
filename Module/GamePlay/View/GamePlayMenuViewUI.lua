GamePlayMenuViewUI = Class("GamePlayMenuViewUI",ViewUI)

function GamePlayMenuViewUI:OnInit()
    self:SetViewAsset("GameMenuWindow")
end

function GamePlayMenuViewUI:FindTargets()
    self.startBtn = self:GetButton("btn_start")
    self.returnBtn = self:GetButton("btn_return")
end

function GamePlayMenuViewUI:InitTargets()
    ButtonExt.SetClick(self.startBtn, self:ToFunc("OnStartBtnClick"))
    ButtonExt.SetClick(self.returnBtn, self:ToFunc("OnReturnBtnClick"))
end

function GamePlayMenuViewUI:OnEnter(data)
    self.data = data
end

function GamePlayMenuViewUI:OnEnterComplete()
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