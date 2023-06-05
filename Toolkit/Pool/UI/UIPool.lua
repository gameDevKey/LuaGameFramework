UIPool = Class("UIPool",CachePoolBase)

function UIPool:OnBeforeGet(obj)
end

function UIPool:OnAfterGet(obj)
end

function UIPool:OnBeforeRecycle(obj)
end

function UIPool:OnAfterRecycle(obj)
end

return UIPool