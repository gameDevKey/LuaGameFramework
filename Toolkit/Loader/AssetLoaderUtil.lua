AssetLoaderUtil = StaticClass("AssetLoaderUtil")

function AssetLoaderUtil.GetGameObjectAsync(path,func)
    CS.GameAssetLoader.Instance:GetGameObjectAsync(path,func)
end

function AssetLoaderUtil.GetTextAsync(path,func)
    CS.GameAssetLoader.Instance:GetTextAsync(path,func)
end

return AssetLoaderUtil