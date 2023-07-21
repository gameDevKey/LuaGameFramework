AssetLoaderUtil = StaticClass("AssetLoaderUtil")

function AssetLoaderUtil.LoadGameObject(path,func)
    CS.GameAssetLoader.Instance:LoadGameObjectAsync(path,func)
end

function AssetLoaderUtil.LoadText(path,func)
    CS.GameAssetLoader.Instance:LoadTextAsync(path,func)
end

return AssetLoaderUtil