--处理界面相关逻辑
TemplateViewCtrl = SingletonClass("TemplateViewCtrl",ViewCtrlBase)

function TemplateViewCtrl:OnInitComplete()
    self:BindEvents()
end

function TemplateViewCtrl:BindEvents()
    PrintLog("执行TemplateViewCtrl:BindEvents")
    self:AddListenerWithSelfFunc(ETemplateModule.ViewEvent.ActiveTemplateView, "SetActiveTemplateView", false)
end

function TemplateViewCtrl:SetActiveTemplateView(data)
    PrintLog("执行TemplateViewCtrl:SetActiveTemplateView",data)
    self:EnterView(UIDefine.ViewType.TemplateView,data)
end

return TemplateViewCtrl