GuideFinder = Class("GuideFinder",GuideModuleBase)

function GuideFinder:OnInit(guideUnit,args,callback)
    self.guideUnit = guideUnit
    self.args = args
    self.callback = callback
end

function GuideFinder:OnInitComplete()
end

function GuideFinder:OnDelete()
end

function GuideFinder:Finish(result)
    if self.callback then
        self.callback(result)
    end
end

return GuideFinder