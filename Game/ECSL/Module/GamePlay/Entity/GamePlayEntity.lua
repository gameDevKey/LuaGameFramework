GamePlayEntity = Class("GamePlayEntity",ECSLEntity)

function GamePlayEntity:OnInit()
end

function GamePlayEntity:OnDelete()
end

function GamePlayEntity:OnUpdate()
end

function GamePlayEntity:SetPlayerType(type)
    self.playerType = type
end

return GamePlayEntity