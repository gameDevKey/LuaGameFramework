local TestFSMStateA = Class("TestFSMStateA", ClsFSMState)

function TestFSMStateA:OnEnter(data)
    PrintLog("TestFSMStateA OnEnter",data)
end

function TestFSMStateA:OnEnterAgain(data)
    PrintLog("TestFSMStateA OnEnterAgain",data)
end

function TestFSMStateA:OnExit(data)
    PrintLog("TestFSMStateA OnExit",data)
end

function TestFSMStateA:OnTick(data)
end

function TestFSMStateA:CanTransition()
    return true
end

return TestFSMStateA