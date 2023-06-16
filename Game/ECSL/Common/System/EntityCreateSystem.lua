EntityCreateSystem = Class("EntityCreateSystem",ECSLSystem)

function EntityCreateSystem:OnInit()
end

function EntityCreateSystem:OnDelete()
end

---创建实体
---@param type ECSLEntityConfig.Type
---@return Entity entity
function EntityCreateSystem:CreateEntity(type)
    local cls = ECSLEntityConfig.Class[type]
    local entity = _G[cls].New()
    entity:SetWorld(self.world)
    for _, cmp in ipairs(ECSLEntityConfig.LogicComponents[type]) do
        entity:AddComponent(_G[cmp].New())
    end
    if self.world:IsRender() then
        for _, cmp in ipairs(ECSLEntityConfig.RenderComponents[type]) do
            entity:AddComponent(_G[cmp].New())
        end
        entity.gameObject = UnityUtil.NewGameObject(ECSLEntityConfig.Type[type]..":"..entity:GetUid())
        entity.gameObject.transform:SetParent(GameManager.Instance.EntityRoot.transform)
        entity.SkinComponent:SetSkin(nil)
    end
    self.world.EntitySystem:AddEntity(entity)
    return entity
end

return EntityCreateSystem