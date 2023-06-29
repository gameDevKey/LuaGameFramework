local Guide002 = {}

Guide002.GroupId = 1
Guide002.NextId = ""

Guide002.Listen = {
    Type = "移动时"
}

Guide002.Pos = {
    Type = "屏幕位置",
    Args = {Type = "中央"},
}

Guide002.Action = {
    Type = "显示对话框",
    Args = {Role="001"}
}

return Guide002