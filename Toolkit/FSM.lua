--[[
    一个简单的有限状态机
]]--
local FSM = Class("FSM")

function FSM:Ctor()
    self.tbState = {}
    self.curState = nil
end

---状态是否注册
---@param stateId EFSMState 状态枚举
---@return boolean
function FSM:ContainState(stateId)
    return self.tbState[stateId] ~= nil
end

---添加FSM状态
---@param state FSMState 状态
function FSM:AddState(state)
    local id = state:GetStateID()
    if self:ContainState(id) then
        PrintWarning("FSM：状态已注册",id)
        return
    end
    self.tbState[id] = state
end

---移除FSM状态
---@param state EFSMState 状态枚举
function FSM:RemoveState(stateId)
    if not self:ContainState(stateId) then
        PrintWarning("FSM：状态未注册",stateId)
        return
    end
    self.tbState[stateId] = nil
end

---切换到某个状态
---@param stateId EFSMState 状态枚举
---@param data any|nil 任意数据结构体
---@return boolean transitionSuccess 是否切换成功
function FSM:ChangeState(stateId,data)
    if not self:ContainState(stateId) then
        PrintWarning("FSM：状态未注册",stateId)
        return false
    end

    local state = self.tbState[stateId]
    local lastState = self.curState

    if state ~= lastState then
        if not state:CanTransition() then
            return false
        end
        self.curState = state
        if lastState ~= nil then
            lastState:OnExit()
        end
        self.curState:OnEnter(data)
        return true
    else
        self.curState:OnEnterAgain(data)
        return false
    end
end

---Tick接口
function FSM:Tick(data)
    if self.curState ~= nil then
        self.curState:OnTick(data)
    end
end

return FSM