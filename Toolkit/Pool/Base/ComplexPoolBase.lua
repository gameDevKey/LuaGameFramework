--复合池，相当于池的池
ComplexPoolBase = Class("ComplexPoolBase",CachePoolBase)

function ComplexPoolBase:OnInit(poolType,poolData)
    self.pools = {}
end

function ComplexPoolBase:OnDelete()
    for key, pool in pairs(self.pools or NIL_TABLE) do
        pool:Delete()
    end
    self.pools = nil
end

function ComplexPoolBase:Get(key,data)
    return CallMySuperFunc(ComplexPoolBase,self:getPool(key),"Get",false,data)
end

function ComplexPoolBase:Recycle(key,obj)
    return CallMySuperFunc(ComplexPoolBase,self:getPool(key),"Recycle",false,obj)
end

--#region

function ComplexPoolBase:getPool(key)
    if not self.pools[key] then
        self.pools[key] = _G[self.config.PoolClass].New(self.poolType)
    end
    return self.pools[key]
end

--#endregion

return ComplexPoolBase