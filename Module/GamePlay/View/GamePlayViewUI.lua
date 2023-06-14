GamePlayViewUI = Class("GamePlayViewUI",ViewUI)

function GamePlayViewUI:OnInit()
    self:SetViewAsset("GameWindow")
end

function GamePlayViewUI:FindTargets()

end

function GamePlayViewUI:InitTargets()

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

return GamePlayViewUI