local Guide001 = {}

Guide001.GroupId = 1

Guide001.Listen = {
    Type = "进入游戏时"
}

Guide001.Actions = {
    {
        Action = {
            Type = "延迟",
            Args = {Time=0.5},
        },
    },
    {
        Find = {
            {
                Type = "屏幕位置",
                Args = {Type = "中央"},
            },
            {
                Type = "屏幕位置",
                Args = {Type = "底部"},
            }
        },
        Action = {
            Type = "显示对话框",
            Args = {Role="001",Msg="对话内容巴拉巴拉"},
        },
    },
    {
        Action = {
            Type = "点击任意位置",
        },
    },
    {
        Find = {
            Type = "屏幕位置",
            Args = {Type = "顶部"},
        },
        Action = {
            Type = "显示对话框",
            Args = {Role="002",Msg="另一个对话内容巴拉巴拉"},
        },
    },
    {
        Action = {
            Type = "点击任意位置",
        },
    },
    {
        Action = {
            Type = "进入引导",
            Id = "Guide002"
        },
    }
}

return Guide001