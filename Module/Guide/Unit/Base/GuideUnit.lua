--新手引导管理类，串通(监听器 --> 查找器 --> Timeline)
GuideUnit = Class("GuideUnit",GuideModuleBase)

function GuideUnit:OnInit(data,callback)
    self.data = data
    self.callback = callback
    self.passData = {}  --存储引导过程中每一个环节产生的数据
    self:CreateTrigger(
        EGuideModule.ListenMap[self.data.Listen.Type],
        self.data.Listen.Args
    )
end

function GuideUnit:OnDelete()
    self.passData = nil
    if self.trigger then
        self.trigger:Delete()
    end
    if self.finder then
        self.finder:Delete()
    end
    if self.timeline then
        self.timeline:Delete()
    end
end

function GuideUnit:SetTriggerData(v)
    self.passData["TriggerData"] = v or {}
end

function GuideUnit:GetTriggerData()
    return self.passData["TriggerData"]
end

function GuideUnit:SetFinderData(v)
    self.passData["FinderData"] = v or {}
end

function GuideUnit:GetFinderData()
    return self.passData["FinderData"]
end

function GuideUnit:CreateTrigger(type,args)
    self.trigger = _G[type].New(self,args,self:ToFunc("FinishTrigger"))
    self.trigger:SetFacade(self.facade)
    self.trigger:InitComplete()
end

function GuideUnit:FinishTrigger(result)
    if not self.trigger then
        return
    end
    self:SetTriggerData(result)
    self.trigger:Delete()
    self.trigger = nil
    -- self:CreateFinder(
    --     EGuideModule.FinderMap[self.data.Find.Type],
    --     self.data.Find.Args
    -- )
end

-- function GuideUnit:CreateFinder(type,args)
--     self.finder = _G[type].New(self,args,self:ToFunc("FinishFinder"))
--     self.finder:SetFacade(self.facade)
--     self.finder:InitComplete()
-- end

-- function GuideUnit:FinishFinder(result)
--     if not self.finder then
--         return
--     end
--     self:SetFinderData(result)
--     self.finder:Delete()
--     self.finder = nil
--     self:CreateTimeline(self.data.Timeline)
-- end

function GuideUnit:CreateTimeline(data)
    self.timeline = TimelineBase.New(data,{
        actionHandler = GuideTimeline,
        finishFunc = self:ToFunc("FinishTimeline")
    })
end

function GuideUnit:FinishTimeline()
    if not self.timeline then
        return
    end
    self.timeline:Delete()
    self.timeline = nil
    self:Finish()
end

function GuideUnit:Finish()
    _ = self.callback and self.callback(self.data)
end

return GuideUnit