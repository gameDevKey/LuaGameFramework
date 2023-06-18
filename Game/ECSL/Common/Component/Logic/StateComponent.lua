StateComponent = Class("StateComponent", ECSLComponent)

function StateComponent:OnInit()
    self.curFSM = self:CreateFSM(StateConfig.FSM.State)
end

function StateComponent:OnDelete()
end

function StateComponent:OnUpdate(deltaTime)
    self.curFSM:Tick(deltaTime)
end

function StateComponent:OnEnable()
end

---根据配置构造FSM
function StateComponent:CreateFSM(fsmType)
    local config = StateConfig.FSMConfig[fsmType]
    local fsmIns = _G[fsmType].New(fsmType)
    fsmIns:SetWorld(self.world)
    for _, state in pairs(config.States or NIL_TABLE) do
        fsmIns:AddState(_G[state].New(state))
    end
    for state1, state2 in pairs(config.ExitTo or NIL_TABLE) do
        fsmIns:SetExitLink(state1, state2)
    end
end

return StateComponent
