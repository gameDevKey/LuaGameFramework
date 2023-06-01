--处理界面相关逻辑
TestViewCtrl = SingletonClass("TestViewCtrl",ViewCtrlBase)

function TestViewCtrl:OnInitComplete()
    self:BindEvents()
end

function TestViewCtrl:BindEvents()
    PrintLog("执行TestViewCtrl:BindEvents")
    self:AddListenerWithSelfFunc(ETestModule.ViewEvent.ActiveTestView, "SetActiveTestView", false)
end

function TestViewCtrl:SetActiveTestView(data)
    PrintLog("执行TestViewCtrl:SetActiveTestView",data)
    self:EnterView(UIDefine.ViewType.TestView,data)
end

return TestViewCtrl