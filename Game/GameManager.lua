GameManager = SingletonClass("GameManager")

function GameManager:OnInit()
end

function GameManager:OnDelete()
end

function GameManager:Tick(deltaTime)
    TimerManager.Instance:Tick(deltaTime)
end

return GameManager
