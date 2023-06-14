TransformRenderComponent = Class("TransformRenderComponent",ECSLRenderComponent)

function TransformRenderComponent:OnInit()
end

function TransformRenderComponent:OnDelete()
end

local vec3 = CS.UnityEngine.Vector3.zero
function TransformRenderComponent:OnUpdate()
    local logicTransform = self.entity.TransformComponent
    if not logicTransform then
        return
    end
    vec3.x,vec3.y,vec3.z = logicTransform:GetPos()
    self.entity.gameObject.transform.localPosition = vec3
end

function TransformRenderComponent:OnEnable()
end

return TransformRenderComponent