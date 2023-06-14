EntitySystem = Class("EntitySystem",ECSLSystem)

function EntitySystem:OnInit()
    self.entitys = ListMap.New()
end

function EntitySystem:OnDelete()
    if self.entitys then
        self.entitys:Delete()
        self.entitys = nil
    end
end

function EntitySystem:AddEntity(entity)
    entity:SetWorld(self.world)
    self.entitys:Add(entity:GetUid(),entity)
end

function EntitySystem:RemoveEntity(entity)
    self.entitys:Remove(entity:GetUid())
end

function EntitySystem:OnUpdate()
    self.entitys:Range(self.UpdateEntity,self)
end

function EntitySystem:UpdateEntity(entityIter)
    entityIter.value:Update()
end

return EntitySystem