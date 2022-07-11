local TestFSMStateB = Class("TestFSMStateB", ClsFSMState)

function TestFSMStateB:OnEnter(data,cbEnter)
    PrintLog("TestFSMStateB OnEnter",data)
    if cbEnter then
        cbEnter()
    end
end

function TestFSMStateB:OnEnterAgain(data,cbEnter)
    PrintLog("TestFSMStateB OnEnterAgain",data)
    if cbEnter then
        cbEnter()
    end
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