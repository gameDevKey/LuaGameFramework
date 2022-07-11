local TestFSMStateA = Class("TestFSMStateA", ClsFSMState)

function TestFSMStateA:OnEnter(data,cbEnter)
    PrintLog("TestFSMStateA OnEnter",data)
    if cbEnter then
        cbEnter()
    end
end

function TestFSMStateA:OnEnterAgain(data,cbEnter)
    PrintLog("TestFSMStateA OnEnterAgain",data)
    if cbEnter then
        cbEnter()
    end
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