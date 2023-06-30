EnterGameGuideTrigger = Class("EnterGameGuideTrigger",GuideTrigger)

function EnterGameGuideTrigger:OnInit()
end

function EnterGameGuideTrigger:OnDelete()
end

function EnterGameGuideTrigger:OnGameStart()
    self:Finish()
end

return EnterGameGuideTrigger