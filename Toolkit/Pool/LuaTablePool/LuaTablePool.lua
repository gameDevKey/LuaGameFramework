LuaTablePool = Class("LuaTablePool",CachePoolBase)

function LuaTablePool:OnBeforeGet(obj)
end

function LuaTablePool:OnAfterGet(obj)
end

function LuaTablePool:OnBeforeRecycle(obj)
end

function LuaTablePool:OnAfterRecycle(obj)
end

--不要改成Get()，会重名...
function LuaTablePool.GetTb()
    local obj = CacheManager.Instance:Get(CacheDefine.PoolType.LuaTable)
    return obj.tb
end

--不要改成Log()，会重名...
function LuaTablePool.LogTb()
    CacheManager.Instance:GetPool(CacheDefine.PoolType.LuaTable,true):Log()
end

return LuaTablePool