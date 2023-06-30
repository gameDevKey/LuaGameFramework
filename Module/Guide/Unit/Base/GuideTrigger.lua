GuideTrigger = Class("GuideTrigger",GuideModuleBase)

function GuideTrigger:OnInit(guideUnit,args,callback)
    self.guideUnit = guideUnit
    self.args = args
    self.callback = callback
end

function GuideTrigger:OnInitComplete()
end

function GuideTrigger:OnDelete()
end

function GuideTrigger:Finish(result)
    if self.callback then
        self.callback(result)
    end
end

return GuideTrigger