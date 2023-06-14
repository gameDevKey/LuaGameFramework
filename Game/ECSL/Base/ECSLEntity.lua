ECSLEntity = Class("ECSLEntity",ECSLBehaivor)
ECSLEntity.TYPE = ECSLConfig.Type.Entity

function ECSLEntity:OnInit()
    self.components = ListMap.New()
end

function ECSLEntity:OnDelete()
    if self.components then
        self.components:Range(function (iter)
            iter.value:Delete()
        end)
        self.components:Delete()
        self.components = nil
    end
end

function ECSLEntity:AddComponent(component)
    if not self.world then
        PrintError("实体未指定世界",self)
        return
    end
    component:SetEntity(self)
    component:SetWorld(self.world)
    self[component.NAME or component._className] = component
    self.components:Add(component._className,component)
end

function ECSLEntity:OnUpdate()
    self.components:Range(self.UpdateComponent,self)
end

function ECSLEntity:UpdateComponent(iter)
    iter.value:Update()
end

function ECSLEntity:OnEnable()
end

function ECSLEntity:OnAfterInit()
    self.components:Range(self.InitComponent,self)
    self.components:Range(self.AfterInitComponent,self)
end

function ECSLEntity:InitComponent(iter)
    iter.value:InitComplete()
end

function ECSLEntity:AfterInitComponent(iter)
    iter.value:AfterInit()
end

return ECSLEntity