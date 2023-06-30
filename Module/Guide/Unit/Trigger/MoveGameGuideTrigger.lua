MoveGameGuideTrigger = Class("MoveGameGuideTrigger",GuideTrigger)

function MoveGameGuideTrigger:OnInit()
end

function MoveGameGuideTrigger:OnDelete()
end

function MoveGameGuideTrigger:OnGameStart()
    self:AddGameListenerWithSelfFunc(EventConfig.Type.MoveInput,"OnMoveInput")
end

function MoveGameGuideTrigger:OnMoveInput(h,v)
    self:Finish({h=h,v=v})
end

return MoveGameGuideTrigger