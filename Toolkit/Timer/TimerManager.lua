TimerManager = SingletonClass("TimerManager")

function TimerManager:OnInit()
    self.time = 0
    self.tbAllTimer = ListMap.New()
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
end

function TimerManager:AddTimer(callback, tickTime)
    local timerId = self.timerKeyGenerator()
    self.tbAllTimer[timerId] = Timer.New(timerId, callback, tickTime)
    return timerId
end

function TimerManager:RemoveTimer(timerId)
    self.tbAllTimer[timerId] = nil
end

function TimerManager:Tick(deltaTime)
    self.time = self.time + deltaTime
    for timerId, timer in pairs(self.tbAllTimer or NIL_TABLE) do
        if timer:Tick(deltaTime) == true then
            TimerManager.RemoveTimer(timerId)
        end
    end
end

return TimerManager
