--[[
    FSM基类
]]
   --

local FSMState = Class("FSMState")

function FSMState:OnInit(stateId)
    self.stateId = stateId
end

function FSMState:GetStateID()
    return self.stateId
end

---进入回调
---@param data any
---@param cbEnter function
function FSMState:OnEnter(data, cbEnter)
end

---再次进入回调
---@param data any
---@param cbEnter function
function FSMState:OnEnterAgain(data, cbEnter)
end

---退出回调
---@param data any
function FSMState:OnExit(data)
end

---能否切换
---@return boolean
function FSMState:CanTransition()
    return true
end

function FSMState:OnTick(data)
end

return FSMState
