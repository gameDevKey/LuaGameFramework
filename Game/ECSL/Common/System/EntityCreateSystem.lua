EntityCreateSystem = Class("EntityCreateSystem",ECSLSystem)

function EntityCreateSystem:OnInit()
end

function EntityCreateSystem:OnDelete()
end

function EntityCreateSystem:CreateTestEntity()
    local entity = TestEntity.New()
    entity:SetWorld(self.world)
    entity:AddComponent(TestComponent.New())
    self.world.EntitySystem:AddEntity(entity)
    return entity
end

return EntityCreateSystem