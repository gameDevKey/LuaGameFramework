ECSLComponent = Class("ECSLComponent",ECSLBase)
ECSLComponent.TYPE = ECSLConfig.Type.Component

function ECSLComponent:OnInit()
    self:SetEnable(true)
end

function ECSLComponent:OnDelete()
end

function ECSLComponent:Update()
    if self.enable then
        self:CallFuncDeeply("OnUpdate",true)
    end
end

function ECSLComponent:SetEnable(enable)
    if enable ~= self.enable then
        self.enable = enable
        self:CallFuncDeeply("OnEnable",true)
    end
end

function ECSLComponent:OnUpdate()
end

function ECSLComponent:OnEnable()
end

return ECSLComponent