GuideViewUI = Class("GuideViewUI", ViewUI)

function GuideViewUI:OnInit()
    self:SetAssetPath("GuideWindow")
    self:SetupExtendView()
end

function GuideViewUI:SetupExtendView()
    self.dialogue = self:AddExtendView(DialogueGuideExtendView)
end

function GuideViewUI:OnFindComponent()
end

function GuideViewUI:OnInitComponent()

end

function GuideViewUI:OnEnter(data)
    self.data = data
    self:EnterComplete()
end

function GuideViewUI:OnEnterComplete()
end

function GuideViewUI:OnExit()
end

function GuideViewUI:OnExitComplete()
end

function GuideViewUI:OnRefresh()
    self.gameObject:SetActive(true)
end

function GuideViewUI:OnHide()
    self.gameObject:SetActive(false)
end

return GuideViewUI
