--阻塞式Timeline
GuideTimeline = Class("GuideTimeline",GuideModuleBase)

function GuideTimeline:OnInit(datas,callback)
    self.datas = datas
    self.callback = callback
    self.actionIndex = 0
    self.amount = #self.datas
    self:NextAction()
end

function GuideTimeline:OnDelete()
    if self.curAction then
        self.curAction:Delete()
        self.curAction = nil
    end
end

function GuideTimeline:NextAction()
    if self.curAction then
        self.curAction:Delete()
        self.curAction = nil
    end
    self.actionIndex = self.actionIndex + 1
    if self.actionIndex > self.amount then
        self:Finish()
        return
    end
    local data = self.datas[self.actionIndex]
    self.curAction = self:CreateAction(data)
end

function GuideTimeline:CreateAction(data)
    local action = GuideAction.New(self,data,self:ToFunc("NextAction"))
    action:SetFacade(self.facade)
    action:InitComplete()
    return action
end

function GuideTimeline:OnUpdate(deltaTime)
    if self.curAction then
        self.curAction:Update(deltaTime)
    end
end

function GuideTimeline:Finish()
    _ = self.callback and self.callback()
end

return GuideTimeline