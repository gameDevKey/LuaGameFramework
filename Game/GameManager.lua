--统一管理游戏内所有逻辑
GameManager = SingletonClass("GameManager")

function GameManager:OnInit()
    self.EntityRoot = UnityUtil.FindGameObject("EntityRoot")
end

function GameManager:OnDelete()
end

function GameManager:Tick(deltaTime)
    TimerManager.Instance:Tick(deltaTime)
    WorldManager.Instance:Tick(deltaTime)
    UpdateManager.Instance:Update(deltaTime)
end

return GameManager
