local Guide001 = {}

Guide001.GroupId = 1
Guide001.NextId = "Guide002"

Guide001.Listen = {
    Type = "进入游戏时"
}

Guide001.Pos = {
    Type = "屏幕位置",
    Args = {Type = "Center"},
}

Guide001.Action = {
    Type = "显示对话框",
    Args = {Role="001"}
}

return Guide001