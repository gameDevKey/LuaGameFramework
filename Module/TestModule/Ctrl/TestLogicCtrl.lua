--处理一些纯业务逻辑（不涉及界面的逻辑）
TestLogicCtrl = SingletonClass("TestLogicCtrl",CtrlBase)

function TestLogicCtrl:OnInitComplete()
    self:AddListenerWithSelfFunc(ETestModule.LogicEvent.DoSomething, "TestFunc", false)
end

function TestLogicCtrl:TestFunc(result)
    PrintLog("执行TestLogicCtrl:TestFunc",result)
    for i = 1, 3 do
        self:Broadcast(ETestModule.ViewEvent.ActiveTestView,{msg="数据"..i})
        UIManager.Instance:Log()
    end

    for i = 1, 2 do
        UIManager.Instance:ExitTop()
        UIManager.Instance:Log()
    end
end

return TestLogicCtrl