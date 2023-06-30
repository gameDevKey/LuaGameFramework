GuideAction = Class("GuideAction",GuideModuleBase)

function GuideAction:OnInit(timeline,data,callback)
    self.timeline = timeline
    self.data = data
    self.callback = callback
    self.finders = {}
    self.action = nil
    self:Start()
end

function GuideAction:OnDelete()
    
end

function GuideAction:Start()
    for _, data in ipairs(self.data.Find or NIL_TABLE) do
        table.insert(self.finders,self:CreateFinder(data))
    end
    self.action = self:CreateAction()
end

function GuideAction:CreateFinder(data)
    
end

function GuideAction:FinishFinder(result)
    
end

function GuideAction:CreateAction()
    local cls = EGuideModule.ActionMap[self.data.Action.Type]
end

function GuideAction:DoAction()
    
end

function GuideAction:OnUpdate(deltaTime)
    for _, finder in ipairs(self.finders) do
        finder:Update(deltaTime)
    end
    if self.action then
        self.action:Update(deltaTime)
    end
end

function GuideAction:Finish()
    _ = self.callback and self.callback()
end

return GuideAction