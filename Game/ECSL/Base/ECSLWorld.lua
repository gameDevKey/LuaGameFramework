ECSLWorld = Class("ECSLWorld",ECSLBase)
ECSLWorld.TYPE = ECSLConfig.Type.World

function ECSLWorld:OnInit()
    self.systems = ListMap.New()
end

function ECSLWorld:OnDelete()
    if self.systems then
        self.systems:Range(function (iter)
            iter.value:Delete()
        end)
        self.systems:Delete()
    end
end

function ECSLWorld:AddSystem(system)
    system:SetWorld(self)
    self[system.NAME or system._className] = system
    self.systems:Add(system._className,system)
end

function ECSLWorld:Update()
    self:CallFuncDeeply("OnUpdate",true)
end

function ECSLWorld:OnUpdate()
    self.systems:Range(self.UpdateSystem,self)
end

function ECSLWorld:UpdateSystem(iter)
    iter.value:Update()
end

return ECSLWorld