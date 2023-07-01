--处理一些纯业务逻辑（不涉及界面的逻辑）
GuideLogicCtrl = SingletonClass("GuideLogicCtrl",CtrlBase)

function GuideLogicCtrl:OnInitComplete()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.Lanuch, "TryStartGuide",false)
end

function GuideLogicCtrl:TryStartGuide()
    if not self:NeedGuide() then
        return
    end
    local guideId = GuideProxy.Instance:GetBeginGuideId()
    --从当前引导所属的组的首个引导开始
end

function GuideLogicCtrl:NeedGuide()
    return true
end

function GuideLogicCtrl:CreateGuideUnit()
    
end

return GuideLogicCtrl