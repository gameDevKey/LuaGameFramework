--处理一些纯业务逻辑（不涉及界面的逻辑）
GamePlayCtrl = SingletonClass("GamePlayCtrl",CtrlBase)

function GamePlayCtrl:OnInitComplete()
    RunWorld = nil
end

function GamePlayCtrl:StartGame()
    if RunWorld then
        PrintError("游戏已开始")
        return
    end
    RunWorld = GamePlayWorld.New()
    WorldManager.Instance:AddWorld(RunWorld)
end

function GamePlayCtrl:GameOver()
    if not RunWorld then
        PrintError("游戏未开始")
        return
    end
    WorldManager.Instance:AddWorld(RunWorld)
    RunWorld = nil
end

return GamePlayCtrl