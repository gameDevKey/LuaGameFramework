ECSLBase = Class("ECSLBase")
ECSLBase.TYPE = ECSLConfig.Type.Nil

function ECSLBase:OnInit()
    self.world = nil
    self:SetUid()
end

function ECSLBase:OnDelete()
    self.uid = nil
    self.world = nil
end

function ECSLBase:SetWorld(world)
    self.world = world
end

function ECSLBase:SetUid()
    self.uid = ECSLUtil.GetUid(self.TYPE)
end

function ECSLBase:GetUid()
    return self.uid
end

return ECSLBase