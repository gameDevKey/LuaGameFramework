local TestFSMStateB = Class("TestFSMStateB", ClsFSMState)

function TestFSMStateB:OnEnter(data)
    PrintLog("TestFSMStateB OnEnter",data)
end

function TestFSMStateB:OnEnterAgain(data)
    PrintLog("TestFSMStateB OnEnterAgain",data)
end

function TestFSMStateB:OnExit(data)
    PrintLog("TestFSMStateB OnExit",data)
end

function TestFSMStateB:OnTick(data)
end

function TestFSMStateB:CanTransition()
    return true
end

return TestFSMStateB