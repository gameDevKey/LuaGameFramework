TimelineBase = Class("TimelineBase")

---初始化
---@param data table { Id, Duration, Actions }
---@param setting table { actionFunc/actionHandler, finishFunc }
---@param actionFunc function action处理回调(可选)
---@param actionHandler Class action处理类(可选)
---@param finishFunc function timeline结束回调
function TimelineBase:OnInit(data, setting)
    self.data = data
    self.setting = setting
    self.duration = self.data.Duration
    self.actionFunc = self.setting.actionFunc
    self.actionHandler = self.setting.actionHandler
    self.finishFunc = self.setting.finishFunc

    self.timer = 0
    self.actionIndex = 0
    self.actionAmount = #self.data.Actions

    self:NextStep()
end

function TimelineBase:OnDelete()
    _ = self.finishFunc and self.finishFunc(self.data)
end

function TimelineBase:Update(deltaTime)
    if not self._alive then
        return
    end
    self.timer = self.timer + deltaTime
    if self.duration > 0 and self.timer > self.duration then
        self:Delete()
        return
    end
    if self.timer >= self.nextTime then
        self:RunAction()
        self:NextStep()
    end
end

function TimelineBase:NextStep()
    self.actionIndex = self.actionIndex + 1
    if self.actionIndex > self.actionAmount then
        self:Delete()
        return
    end
    self.actionData = self.data.Actions[self.actionIndex]
    self.nextTime = self.actionData.Time or 0
end

function TimelineBase:RunAction()
    if not self.actionData then
        return
    end
    local fn = self.actionFunc
    if fn then
        fn(self.actionData)
    elseif self.actionHandler then
        if self.actionHandler._isInstance then
            fn = self.actionHandler:ToFunc(self.actionData.Action)
            _ = fn and fn(self.actionHandler,self.actionData)
        else
            fn = self.actionHandler[self.actionData.Action]
            _ = fn and fn(self.actionData)
        end
        if not fn then
            PrintError("找不到处理类函数",self.actionData)
        end
    else
        if not fn then
            PrintError("需要指定actionFunc或actionHandler",self.data)
        end
    end
end

return TimelineBase