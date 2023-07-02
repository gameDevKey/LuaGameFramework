DialogueGuideAction = Class("DialogueGuideAction", GuideAction)

function DialogueGuideAction:OnInit()
    GuideFacade.Instance:Broadcast(EGuideModule.Event.ActiveDialogue,
        true, self.args.Role, self.args.Msg, self:ToFunc("Finish"))
end

function DialogueGuideAction:OnDelete()
end

function DialogueGuideAction:OnUpdate(deltaTime)
end

return DialogueGuideAction
