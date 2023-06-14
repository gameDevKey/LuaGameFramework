TransformComponent = Class("TransformComponent",ECSLComponent)

function TransformComponent:OnInit()
end

function TransformComponent:OnDelete()
end

function TransformComponent:OnUpdate()
end

function TransformComponent:OnEnable()
end

function TransformComponent:SetPos(x,y,z)
    self.posX,self.posY,self.posZ = (x or 0),(y or 0),(z or 0)
end

function TransformComponent:GetPos()
    return self.posX,self.posY,self.posZ
end

return TransformComponent