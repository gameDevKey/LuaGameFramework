ObjectPool = Class("ObjectPool")

function ObjectPool:OnInit(cbGet)
    self.activePool = {}
    self.recyclePool = {}
    self.cbGet = cbGet
    self.cbAsyncGet = AsyncToSync(self.cbGet)
end

function ObjectPool:Get(isAsync)
    local obj
    if #self.recyclePool > 0 then
        obj = table.remove(self.recyclePool)
    else
        if isAsync and self.cbAsyncGet then
            obj = self.cbAsyncGet()
        elseif self.cbGet then
            obj = self.cbGet()
        end
    end
    if obj ~= nil then
        table.insert(self.activePool, obj)
    end
    return obj
end

function ObjectPool:SyncGet()
    return self:Get(false)
end

function ObjectPool:AsyncGet()
    return self:Get(true)
end

function ObjectPool:Recycle(obj)
    if not table.Contain(self.activePool, obj) then
        return false
    end
    if table.Contain(self.recyclePool, obj) then
        return false
    end
    table.insert(self.recyclePool, obj)
    return true
end

return ObjectPool
