--处理界面相关逻辑
TestViewCtrl = SingletonClass("TestViewCtrl",CtrlBase)

function TestViewCtrl:OnInitComplete()
    self:AddListenerWithSelfFunc(ETestModule.Test, "TestFunc", true)
end

function TestViewCtrl:TestFunc(...)
    print("执行TestViewCtrl:TestFunc",...)
end

return TestViewCtrl