GamePlayWorld = Class("GamePlayWorld",ECSLWorld)

function GamePlayWorld:OnInit()
    self:AddSystem(EntitySystem.New())
    self:AddSystem(EntityCreateSystem.New())
end

function GamePlayWorld:OnDelete()
end

function GamePlayWorld:OnUpdate()
    
end

return GamePlayWorld