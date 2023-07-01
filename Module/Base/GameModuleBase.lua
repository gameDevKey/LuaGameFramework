--游戏业务模块基类，除了ModuleBase的基础功能外，还支持游戏中的逻辑处理
GameModuleBase = Class("GameModuleBase",ModuleBase)

function GameModuleBase:OnInit()
    self.tbEventGameKey = {}
end

function GameModuleBase:OnDelete()
    self:RemoveAllGameListener()
end

function GameModuleBase:SetWorld(world)
    self.world = world
end

function GameModuleBase:GetWorld()
    return self.world or RunWorld
end

function GameModuleBase:AddGameListener(eventId, callObject, judgeData, once)
    local world = self:GetWorld()
    if not world then
        return
    end
    local key = world.GameEventSystem:AddListener(eventId, callObject, judgeData, once)
    self.tbEventGameKey[key] = eventId
    return key
end

function GameModuleBase:AddGameListenerWithSelfFunc(eventId, fnName, judgeData, once)
    local world = self:GetWorld()
    if not world then
        return
    end
    return self:AddGameListener(eventId, CallObject.New(self:ToFunc(fnName)), judgeData, once)
end

function GameModuleBase:RemoveGameListener(eventId, eventKey)
    local world = self:GetWorld()
    if not world then
        return
    end
    world.GameEventSystem:RemoveListener(eventId, eventKey)
end

function GameModuleBase:BindGameEventHandler(eventId, callObject)
    local world = self:GetWorld()
    if not world then
        return
    end
    world.GameEventSystem:BindHandler(eventId, callObject)
end

function GameModuleBase:RemoveAllGameListener()
    local world = self:GetWorld()
    if not world then
        return
    end
    for eventKey, eventId in pairs(self.tbEventGameKey) do
        self:RemoveGameListener(eventId,eventKey)
    end
    self.tbEventGameKey = {}
end

return GameModuleBase
