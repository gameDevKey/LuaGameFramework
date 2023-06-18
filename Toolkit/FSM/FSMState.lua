--FSM的叶子节点，只处理具体逻辑，不能包含子节点
FSMState = Class("FSMState", FSMBehavior)

function FSMState:OnInit(stateId)
    self.stateId = stateId
end

function FSMState:GetStateID()
    return self.stateId
end

function FSMState:SetOwnerFSM(fsm)
    self.ownerFSM = fsm
end

function FSMState:GetOwnerFSM()
    return self.ownerFSM
end

return FSMState
