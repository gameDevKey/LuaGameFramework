CacheLuaTable = Class("CacheLuaTable",CacheItemBase)

function CacheLuaTable:OnInit()
    self.tb = {}
    self.tb._cache_class = self
    self.tb.Recycle = self._recycle_tb
end

function CacheLuaTable:OnDelete()
    self.tb = nil
end

function CacheLuaTable:OnUse()
end

function CacheLuaTable:OnRecycle()
    for key, value in pairs(self.tb) do
        if key ~= '_cache_class' and key ~= "Recycle" then
            self.tb[key] = nil
        end
    end
end

function CacheLuaTable:_recycle_tb()
    self._cache_class:Recycle()
end

return CacheLuaTable