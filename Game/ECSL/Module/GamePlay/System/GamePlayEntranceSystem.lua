GamePlayEntranceSystem = Class("GamePlayEntranceSystem",ECSLSystem)

function GamePlayEntranceSystem:OnInitComplete()
    self:CreateMainRole()
    self:CreateMap()
end

function GamePlayEntranceSystem:OnDelete()
    
end

function GamePlayEntranceSystem:OnUpdate()
    
end

function GamePlayEntranceSystem:CreateMainRole()
    local entity = self.world.EntityCreateSystem:CreateEntity(ECSLEntityConfig.Type.GamePlay)
    entity:SetPlayerType(EGamePlayModule.PlayerType.Player)
    entity.TransformComponent:SetPos(50,100,100)
end

function GamePlayEntranceSystem:CreateEnermy()
    local entity = self.world.EntityCreateSystem:CreateEntity(ECSLEntityConfig.Type.GamePlay)
    entity:SetPlayerType(EGamePlayModule.PlayerType.NPC)
end

function GamePlayEntranceSystem:CreateMap()
    
end

return GamePlayEntranceSystem