ECSLEntityConfig = StaticClass("ECSLEntityConfig")

ECSLEntityConfig.Type = Enum.New({
    GamePlay = 1,
})

ECSLEntityConfig.Class = {
    [ECSLEntityConfig.Type.GamePlay] = "GamePlayEntity",
}

ECSLEntityConfig.LogicComponents = {
    [ECSLEntityConfig.Type.GamePlay] = {
        "TransformComponent"
    },
}

ECSLEntityConfig.RenderComponents = {
    [ECSLEntityConfig.Type.GamePlay] = {
        "TransformRenderComponent"
    },
}

return ECSLEntityConfig