TimerManager = SingletonClass("TimerManager")

function TimerManager:OnInit()
    self.time = 0
    self.tbAllTimer = ClassListMap.New()
    self.timerKeyGenerator = GetAutoIncreaseFunc()
end

function TimerManager:OnDelete()
    if self.tbAllTimer then
        self.tbAllTimer:Range(function (iter)
            iter.value:Delete()
        end)
        self.tbAllTimer:Delete()
        self.tbAllTimer = nil
    end
    self:TryRemoveTimers()
end

function TimerManager:AddTimer(callback, tickTime)
    local timerId = self.timerKeyGenerator()
    self.tbAllTimer:Add(timerId,Timer.New(timerId, callback, tickTime))
    return timerId
end

function TimerManager:RemoveTimer(timerId)
    if not self.removeTimerIds then
        self.removeTimerIds = {}
    end
    table.insert(self.removeTimerIds,timerId)
end

function TimerManager:Tick(deltaTime)
    self.deltaTime = deltaTime
    self.time = self.time + deltaTime
    self.tbAllTimer:Range(self.UpdateTimer,self)
    self:TryRemoveTimers()
end

function TimerManager:UpdateTimer(iter)
    if iter.value:Tick(self.deltaTime) then
        self:RemoveTimer(iter.key)
    end
end

function TimerManager:TryRemoveTimers()
    if not self.removeTimerIds then
        return
    end
    for _, timerId in ipairs(self.removeTimerIds or NIL_TABLE) do
        local timer = self.tbAllTimer:GetVal(timerId)
        _ = timer and timer:Delete()
        self.tbAllTimer:Remove(timerId)
    end
    self.removeTimerIds = nil
end

return TimerManager
