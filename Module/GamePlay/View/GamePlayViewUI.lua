GamePlayViewUI = Class("GamePlayViewUI",ViewUI)

function GamePlayViewUI:OnInit()
    self:SetViewAsset("GameWindow")
end

function GamePlayViewUI:FindTargets()
    self.startBtn = self:GetButton("btn_start")
    self.returnBtn = self:GetButton("btn_return")
end

function GamePlayViewUI:InitTargets()
    ButtonExt.SetClick(self.startBtn, self:ToFunc("OnStartBtnClick"))
    ButtonExt.SetClick(self.returnBtn, self:ToFunc("OnReturnBtnClick"))
end

function GamePlayViewUI:OnEnter(data)
    self.data = data
end

function GamePlayViewUI:OnEnterComplete()
end

function GamePlayViewUI:OnExit()
end

function GamePlayViewUI:OnExitComplete()
end

function GamePlayViewUI:OnRefresh()
    self.gameObject:SetActive(true)
end

function GamePlayViewUI:OnHide()
    self.gameObject:SetActive(false)
end

function GamePlayViewUI:OnStartBtnClick()
    self:Broadcast(EGamePlayModule.LogicEvent.StartGame)
end

function GamePlayViewUI:OnReturnBtnClick()
    self:Exit()
end

return GamePlayViewUI