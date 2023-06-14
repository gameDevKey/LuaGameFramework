ECSLBehaivor = Class("ECSLBehaivor",ECSLBase)
ECSLBehaivor.TYPE = ECSLConfig.Type.Nil

function ECSLBehaivor:OnInit()
    self:SetEnable(true)
end

function ECSLBehaivor:OnDelete()
end

function ECSLBehaivor:Update()
    if self.enable then
        self:CallFuncDeeply("OnUpdate",true)
    end
end

function ECSLBehaivor:SetEnable(enable)
    if enable ~= self.enable then
        self.enable = enable
        self:CallFuncDeeply("OnEnable",true)
    end
end

function ECSLBehaivor:OnUpdate()
end

function ECSLBehaivor:OnEnable()
end

return ECSLBehaivor