GamePlayOperateSystem = Class("GamePlayOperateSystem",ECSLSystem)

function GamePlayOperateSystem:OnInitComplete()
    self:AddListeners()
    self.targetPosOffset = CS.UnityEngine.Vector3.zero
end

function GamePlayOperateSystem:AddListeners()
    self.world.GameEventSystem:AddListener(ECSLEventConfig.Type.Input,
        CallObject.New(self:ToFunc("OnUserInput")),nil)
end

function GamePlayOperateSystem:OnUserInput(h,v)
    local mainRole = self.world.GamePlayEntranceSystem.mainRole
    if not mainRole then
        return
    end
    local speed = mainRole.AttrComponent:GetAttr(ECSLAttrConfig.Type.MoveSpeed)
    self.targetPosOffset.x = h * self.world.deltaTime * speed
    self.targetPosOffset.y = v * self.world.deltaTime * speed
    local targetPos = mainRole.TransformComponent:GetPosVec3() + self.targetPosOffset
    mainRole.TransformComponent:SetPosVec3(targetPos)
    -- mainRole.MoveComponent:To(ECSLMoveConfig.Type.Linear,{
    --     targetPos = targetPos,
    --     speed = 10,
    -- })
end

return GamePlayOperateSystem