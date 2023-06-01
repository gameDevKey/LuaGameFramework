AssetLoader = Class("AssetLoader")

function AssetLoader:OnInit()
    self.assets = {}
end

function AssetLoader:OnDelete()
    if self.finishCallback then
        self.finishCallback:Delete()
        self.finishCallback = nil
    end
end

function AssetLoader:LoadAsset(fn,caller)
    self.finishCallback = CallObject.New(fn,caller)
    --TODO 加载过的资源直接触发完成回调

    --测试----
    self.finishCallback:Invoke()
    self:SetAssets(nil)
    ---------
end

function AssetLoader:AddAsset(path)
    table.insert(self.assets, path)
end

function AssetLoader:SetAssets(paths)
    self.assets = paths
end

return AssetLoader