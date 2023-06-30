--新手引导业务基类，支持战斗内外监听事件
GuideModuleBase = Class("GuideModuleBase", GameModuleBase)

function GuideModuleBase:OnInit()
end

function GuideModuleBase:OnDelete()
end

function GuideModuleBase:OnInitComplete()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.GameStart,"_OnGameStart")
end

function GuideModuleBase:_OnGameStart()
    self:SetWorld(RunWorld)
    self:CallFuncDeeply("OnGameStart",true)
end

function GuideModuleBase:Update(deltaTime)
    self:CallFuncDeeply("OnUpdate",true,deltaTime)
end

function GuideModuleBase:OnUpdate(deltaTime) end
function GuideModuleBase:OnGameStart() end

return GuideModuleBase