StateComponent = Class("StateComponent", ECSLComponent)

function StateComponent:OnInit()
    self.curFSM = nil
end

function StateComponent:OnDelete()
    if self.curFSM then
        self.curFSM:Delete()
    end
end

function StateComponent:OnUpdate(deltaTime)
    if self.curFSM then
        self.curFSM:Tick(deltaTime)
    end
end

function StateComponent:OnEnable()
end

--关联一个有限状态机，管理角色的状态切换逻辑
function StateComponent:SetFSM(fsm)
    self.curFSM = fsm
end

function StateComponent:AddState()
    --TODO 注意多个添加来源的情况
end

function StateComponent:RemoveState()
    
end

return StateComponent
