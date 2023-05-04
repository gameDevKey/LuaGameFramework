--[[
    对FSM状态切换指令的封装
]]
   --
local FSMOrder = Class("FSMOrder")

function FSMOrder:OnInit(stateId, cbEnter)
    self.stateId = stateId
    self.cbEnter = cbEnter
end

function FSMOrder:GetStateId()
    return self.stateId
end

function FSMOrder:GetEnterCallback()
    return self.cbEnter
end

return FSMOrder
