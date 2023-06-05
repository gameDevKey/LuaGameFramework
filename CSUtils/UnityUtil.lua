UnityUtil = StaticClass("UnityUtil")

local engine = CS.UnityEngine

function UnityUtil.FindGameObject(name)
    return engine.GameObject.Find(name)
end

function UnityUtil.NewGameObject(name)
    return engine.GameObject(name)
end

function UnityUtil.LoadResources(path)
    return engine.Resources.Load(path)
end

function UnityUtil.Instantiate(prefab)
    return engine.GameObject.Instantiate(prefab)
end

return UnityUtil