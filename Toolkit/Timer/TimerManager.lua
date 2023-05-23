local TimerManager = SingletonClass("TimerManager")

function TimerManager:OnInit()
    self.tbAllTimer = {}
    self.timerKeyGenerator = GetAutoIncreaseFunc()
end

function TimerManager:OnDelete()
    for timerId, timer in pairs(self.tbAllTimer) do
        timer:Delete()
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
    for timerId, timer in pairs(self.tbAllTimer or {}) do
        if timer:Tick(deltaTime) == true then
            TimerManager.RemoveTimer(timerId)
        end
    end
end

return TimerManager
