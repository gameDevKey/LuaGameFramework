AssetLoader = Class("AssetLoader")

function AssetLoader:OnInit()
    
end

function AssetLoader:OnDelete()
    if self.finishCallback then
        self.finishCallback:Delete()
        self.finishCallback = nil
    end
end

function AssetLoader:LoadAsset(fn,caller)
    self.finishCallback = CallObject.New(fn,caller)
end

function AssetLoader:AddAsset(path)
end

function AssetLoader:SetAssets(paths)
end

return AssetLoader