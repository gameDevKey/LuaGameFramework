local GameManager = SingletonClass("GameManager")

function GameManager:Tick(deltaTime)
    TimerManager.Instance():Tick(deltaTime)
end

return GameManager
