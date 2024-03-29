DelayGuideAction = Class("DelayGuideAction", GuideAction)

function DelayGuideAction:OnInit()
    self.timer = 0
    self.time = self.args.Time
end

function DelayGuideAction:OnDelete()
end

function DelayGuideAction:OnUpdate(deltaTime)
    self.timer = self.timer + deltaTime
    if self.timer >= self.time then
        self:Finish()
    end
end

return DelayGuideAction
