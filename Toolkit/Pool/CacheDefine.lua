CacheDefine = {}

CacheDefine.PoolType = Enum.New({
    Test = Enum.Index,
})

---@param MaxAmount     integer 回收最大数量, 0表示不限制
---@param PreloadAmount integer 预加载数量, 不可超过MaxAmount
CacheDefine.BindInfo = {
    [CacheDefine.PoolType.Test] = {
        PoolClass = "TestItemPool",
        ItemClass = "CacheTestItem",
        MaxAmount = 10,
        PreloadAmount = 0,
    }
}

return CacheDefine