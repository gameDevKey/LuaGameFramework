local TimerManager = Class("TimerManager")

local tbAllTimer = {}
local timerKeyGenerator = GetAutoIncreaseFunc()

function TimerManager.AddTimer(callback, tickTime)
    local timerId = timerKeyGenerator()
    tbAllTimer[timerId] = Timer.New(timerId, callback, tickTime)
    return timerId
end

function TimerManager.RemoveTimer(timerId)
    tbAllTimer[timerId] = nil
end

function TimerManager.Tick(deltaTime)
    for timerId, timer in pairs(tbAllTimer or {}) do
        if timer:Tick(deltaTime) == true then
            TimerManager.RemoveTimer(timerId)
        end
    end
end

return TimerManager
