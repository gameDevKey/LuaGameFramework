local FSM = ClsFSM.New()

local ClsTestFSMStateA = require("Debug.TestFSMStateA")
local ClsTestFSMStateB = require("Debug.TestFSMStateB")

FSM:AddState(ClsTestFSMStateA.New(EFSMState.StateA))
FSM:AddState(ClsTestFSMStateB.New(EFSMState.StateB))

FSM:ChangeState(EFSMState.StateA,'try change to A')
FSM:ChangeState(EFSMState.StateB,'try change to B')

-- FSM:RemoveState(EFSMState.StateA)
FSM:ChangeState(EFSMState.StateB,'try enter B again')