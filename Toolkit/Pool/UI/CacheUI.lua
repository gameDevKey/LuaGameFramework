CacheUI = Class("CacheUI",CacheItemBase)

function CacheUI:OnInit()
end

function CacheUI:onAssetLoaded(asset)
    self.asset = asset[self.data.path]
    self:OnUse()
end

function CacheUI:OnDelete()
    if self.gameObject then
        GameObject.Destroy(self.gameObject)
        self.gameObject = nil
    end
end

function CacheUI:OnUse()
    if self.asset then
        if not self.gameObject then
            self.gameObject = UnityUtil.Instantiate(self.asset)
            self.gameObject:SetActive(true)
        end
        self.transform = self.gameObject.transform
        self.transform:SetParent(UIManager.Instance.uiRoot.transform)
        RectTransformExt.Reset(self.transform)
        if self.data.callback then
            self.data.callback(self.data.args,self.gameObject)
        end
    else
        self:GetPool():LoadAsset(self.data.path, self:ToFunc("onAssetLoaded"))
    end
end

function CacheUI:OnRecycle()
    if self.gameObject then
        self.transfrom:SetParent(UIManager.Instance.cacheNode.transform)
    end
end

return CacheUI