TestFacade = SingletonClass("TestFacade",FacadeBase)

function TestFacade:OnInit()
    self:BindCtrl(TestViewCtrl.Instance)
    self:BindCtrl(TestLogicCtrl.Instance)
    self:BindProxy(TestProxy.Instance)
end

function TestFacade:OnInitComplete()
    PrintLog("TestFacade:OnInitComplete")
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.TestModule, "TestFunc", "start TestFacade")
end

function TestFacade:TestFunc(...)
    PrintLog("执行TestFacade:TestFunc",self)
    self:Broadcast(ETestModule.Test,"test success!")
    self:Broadcast(ETestModule.Test,"test success!")
end

return TestFacade