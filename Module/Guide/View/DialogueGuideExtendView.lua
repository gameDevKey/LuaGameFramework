DialogueGuideExtendView = Class("DialogueGuideExtendView", ViewUI)

function DialogueGuideExtendView:OnInit()
end

function DialogueGuideExtendView:OnFindComponent()
    self.dialogue = self:GetTransform("dialogue")
    self.content = self:GetText("dialogue/main/content")
    self.mask = self:GetButton("dialogue/mask")
end

function DialogueGuideExtendView:OnInitComponent()
    ButtonExt.SetClick(self.mask, self:ToFunc("OnCloseBtnClick"))
end

function DialogueGuideExtendView:OnEnter(data)
    self:HideDialogue()
end

function DialogueGuideExtendView:OnEnterComplete()
end

function DialogueGuideExtendView:OnExit()
end

function DialogueGuideExtendView:OnExitComplete()
end

function DialogueGuideExtendView:OnRefresh()
end

function DialogueGuideExtendView:OnHide()
end

function DialogueGuideExtendView:ShowDialogue(role, content, onClose)
    self.dialogue.gameObject:SetActive(true)
    self.content.text = content
    self.onClose = onClose
end

function DialogueGuideExtendView:HideDialogue()
    self.dialogue.gameObject:SetActive(false)
    local onClose = self.onClose
    self.onClose = nil
    _ = onClose and onClose()
end

function DialogueGuideExtendView:OnCloseBtnClick()
    self:HideDialogue()
end

return DialogueGuideExtendView
