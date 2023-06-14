ECSLBehaivor = Class("ECSLBehaivor",ECSLBase)
ECSLBehaivor.TYPE = ECSLConfig.Type.Nil

function ECSLBehaivor:OnInit()
    self:SetEnable(true)
end

function ECSLBehaivor:OnDelete()
end

-- 所有系统、实体或者组件执行OnInit后，调用OnInitComplete
function ECSLBehaivor:InitComplete()
    self:CallFuncDeeply("OnInitComplete",true)
end

-- 所有系统、实体或者组件执行OnInitComplete后，调用OnAfterInit
function ECSLBehaivor:AfterInit()
    self:CallFuncDeeply("OnAfterInit",true)
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

function ECSLBehaivor:OnInitComplete()end
function ECSLBehaivor:OnAfterInit()end
function ECSLBehaivor:OnEnable()end
function ECSLBehaivor:OnUpdate()end

return ECSLBehaivor