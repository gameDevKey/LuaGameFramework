ECSLEventConfig = StaticClass("ECSLEventConfig")

ECSLEventConfig.Type = Enum.New({
    Input = 1,
    AttrChange = 2,
})

return ECSLEventConfig