local FSM = ClsFSM.New()

local ClsTestFSMStateA = require("Debug.TestFSMStateA")
local ClsTestFSMStateB = require("Debug.TestFSMStateB")

FSM:AddState(ClsTestFSMStateA.New(EFSMState.StateA))
FSM:AddState(ClsTestFSMStateB.New(EFSMState.StateB))

FSM:ChangeState(EFSMState.StateA,'try change to A')

PrintLog("=============")
FSM:ChangeState(EFSMState.StateB,'try change to B')

-- FSM:RemoveState(EFSMState.StateA)
-- FSM:ChangeState(EFSMState.StateB,'try enter B again')

PrintLog("=============")
FSM:ChangeStateByOrder(ClsFSMOrder.New(EFSMState.StateA, function ()
    PrintLog("进入状态A结束")
end),'hello world')