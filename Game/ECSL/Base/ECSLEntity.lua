ECSLEntity = Class("ECSLEntity",ECSLBase)
ECSLEntity.TYPE = ECSLConfig.Type.Entity

function ECSLEntity:OnInit()
    self.components = ListMap.New()
end

function ECSLEntity:OnDelete()
    if self.components then
        self.components:Range(function (iter)
            iter.value:Delete()
        end)
        self.components = nil
    end
end

function ECSLEntity:AddComponent(component)
    if not self.world then
        PrintError("实体未指定世界",self)
        return
    end
    component:SetWorld(self.world)
    self[component.NAME or component._className] = component
    self.components:Add(component._className,component)
end

function ECSLEntity:Update()
    self:CallFuncDeeply("OnUpdate",true)
end

function ECSLEntity:OnUpdate()
    self.components:Range(self.UpdateComponent,self)
end

function ECSLEntity:UpdateComponent(iter)
    iter.value:Update()
end

return ECSLEntity