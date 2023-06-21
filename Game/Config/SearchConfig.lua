SearchConfig = StaticClass("SearchConfig")

SearchConfig.Range = Enum.New({
    All = Enum.Index,
    Circle = Enum.Index,
    Rect = Enum.Index,
})

return SearchConfig