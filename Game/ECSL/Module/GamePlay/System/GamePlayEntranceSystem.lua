GamePlayEntranceSystem = Class("GamePlayEntranceSystem",ECSLSystem)

function GamePlayEntranceSystem:OnAfterInit()
    self.mainRole = self.world.EntityCreateSystem:CreateMainRole()
end

function GamePlayEntranceSystem:OnDelete()
    self.mainRole:Delete()
end

function GamePlayEntranceSystem:OnUpdate()
end

return GamePlayEntranceSystem