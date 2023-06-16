GamePlayEntranceSystem = Class("GamePlayEntranceSystem",ECSLSystem)

function GamePlayEntranceSystem:OnInitComplete()
    self.mainRole = self:CreateMainRole()
    self:CreateMap()
end

function GamePlayEntranceSystem:OnDelete()
    
end

function GamePlayEntranceSystem:OnUpdate()
    
end

function GamePlayEntranceSystem:CreateMainRole()
    local entity = self.world.EntityCreateSystem:CreateEntity(ECSLEntityConfig.Type.GamePlay)
    entity:SetPlayerType(EGamePlayModule.PlayerType.Player)
    entity.TransformComponent:SetPos(0,0,0)
    entity.AttrComponent:SetAttr(ECSLAttrConfig.Type.MoveSpeed,10)
    return entity
end

function GamePlayEntranceSystem:CreateEnermy()
    local entity = self.world.EntityCreateSystem:CreateEntity(ECSLEntityConfig.Type.GamePlay)
    entity:SetPlayerType(EGamePlayModule.PlayerType.NPC)
    return entity
end

function GamePlayEntranceSystem:CreateMap()
    
end

return GamePlayEntranceSystem