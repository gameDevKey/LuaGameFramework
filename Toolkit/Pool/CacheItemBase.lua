CacheItemBase = Class("CacheItemBase")

function CacheItemBase:OnInit()
    self.isCache = false
end

function CacheItemBase:OnDelete()
    self:SetPool(nil)
    self:ResetField()
end

function CacheItemBase:SetPool(pool)
    self.pool = pool
end

function CacheItemBase:GetPool()
    return self.pool
end

function CacheItemBase:Use()
    self.isCache = false
    self:CallFuncDeeply("OnUse",true)
end

function CacheItemBase:Recycle()
    self.isCache = true
    self:CallFuncDeeply("OnRecycle",false)
end

function CacheItemBase:ResetField()
    for key, value in pairs(self._cache_defaults or NIL_TABLE) do
        self[key] = value
    end
    for key, value in pairs(self._cache_nils or NIL_TABLE) do
        self[key] = nil
    end
end

--#region 虚函数
function CacheItemBase:OnUse()

end
function CacheItemBase:OnRecycle()
    self:ResetField()
end
--#endregion

return CacheItemBase