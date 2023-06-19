EventConfig = StaticClass("EventConfig")

EventConfig.Type = Enum.New({
    Input = 1,
    AttrChange = 2,
})

return EventConfig