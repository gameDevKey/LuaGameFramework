--[[
    FSM基类
]]--
local FSMState = Class("FSMState")

---@param stateId EFSMState 状态ID枚举
function FSMState:Ctor(stateId)
    self.stateId = stateId
end

function FSMState:GetStateID()
    return self.stateId
end

function FSMState:OnEnter(data)
end

function FSMState:OnEnterAgain(data)
end

function FSMState:OnExit(data)
end

function FSMState:OnTick(data)
end

function FSMState:CanTransition()
    return true
end

return FSMState