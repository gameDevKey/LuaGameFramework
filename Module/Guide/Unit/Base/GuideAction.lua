GuideAction = Class("GuideAction", GuideModuleBase)

function GuideAction:OnInit(clip, args, finderResults, callback)
    self.clip = clip
    self.args = args
    self.finderResults = finderResults
    self.callback = callback
end

function GuideAction:OnDelete()

end

function GuideAction:Finish()
    _ = self.callback and self.callback()
end

return GuideAction
