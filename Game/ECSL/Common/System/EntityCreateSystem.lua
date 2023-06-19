EntityCreateSystem = Class("EntityCreateSystem",ECSLSystem)

function EntityCreateSystem:OnInit()
end

function EntityCreateSystem:OnDelete()
end

---创建实体
---@param type EntityConfig.Type
---@return Entity entity
function EntityCreateSystem:CreateEntity(type)
    local cls = EntityConfig.Class[type]
    local entity = _G[cls].New()
    entity:SetWorld(self.world)
    for _, cmp in ipairs(EntityConfig.LogicComponents[type]) do
        entity:AddComponent(_G[cmp].New())
    end
    if self.world:IsRender() then
        for _, cmp in ipairs(EntityConfig.RenderComponents[type]) do
            entity:AddComponent(_G[cmp].New())
        end
        entity:SetGameObject(UnityUtil.NewGameObject(EntityConfig.Type[type]..":"..entity:GetUid()))
        entity.gameObject.transform:SetParent(GameManager.Instance.EntityRoot.transform)
    end
    self.world.EntitySystem:AddEntity(entity)
    return entity
end

function EntityCreateSystem:CreateMainRole()
    local entity = self:CreateEntity(EntityConfig.Type.GamePlay)
    entity:SetPlayerType(EGamePlayModule.PlayerType.Player)
    entity.TransformComponent:SetPos(0,0,0)
    entity.StateComponent:SetFSM(StateFSM.New())
    entity.AttrComponent:SetAttr(AttrConfig.Type.HP,100)
    entity.AttrComponent:SetAttr(AttrConfig.Type.MoveSpeed,10)
    entity.SkinComponent:SetSkin(nil)
    return entity
end

function EntityCreateSystem:CreateProj()
    
end

return EntityCreateSystem