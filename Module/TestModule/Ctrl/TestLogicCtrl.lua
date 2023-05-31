--处理一些纯业务逻辑（不涉及界面的逻辑）
TestLogicCtrl = SingletonClass("TestLogicCtrl",CtrlBase)

function TestLogicCtrl:OnInitComplete()
    self:AddListenerWithSelfFunc(ETestModule.Test, "TestFunc", true)
end

function TestLogicCtrl:TestFunc(...)
    print("执行TestLogicCtrl:TestFunc",...)
end

return TestLogicCtrl