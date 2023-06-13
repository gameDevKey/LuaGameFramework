ECSLSystem = Class("ECSLSystem",ECSLBase)
ECSLSystem.TYPE = ECSLConfig.Type.System

function ECSLSystem:OnInit()
end

function ECSLSystem:OnDelete()
end

function ECSLSystem:Update()
    self:CallFuncDeeply("OnUpdate",true)
end

function ECSLSystem:OnUpdate()
end

return ECSLSystem