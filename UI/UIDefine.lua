UIDefine = {}

UIDefine.UIRootName = "UIRoot"
UIDefine.UICacheName = "UICache"

UIDefine.ViewLayer = Enum.New({
    BG = 1000,       --背景层
    NormalUI = 4000, --普通界面层（后进先出）
    HoldUI = 7000,   --常驻界面层（不会受到堆栈影响）
    Popup = 10000,   --弹窗层
    Top = 13000,     --通知层（最重要的展示信息）
})

--当界面进入时
UIDefine.EnterType = Enum.New({
    None = Enum.Index,
    ExitLast = Enum.Index, --关闭上一个界面
})

--当界面关闭时
UIDefine.ExitType = Enum.New({
    None = Enum.Index,
})

UIDefine.ViewType = {
    TemplateView = "TemplateView",
    LoginView = "LoginView",
    GameMenuView = "GameMenuView",
    GameView = "GameView",
    GenericView = "GenericView",
    GuideView = "GuideView",
}

UIDefine.ComType = {
    TemplateCom = "TemplateCom",
    LoginCom = "LoginCom",
    ServerListItem = "ServerListItem",
    GamePlayMenuItem = "GamePlayMenuItem",
}

--[[
    界面配置
    Class:界面类
    EnterType:入场方式
    ExitType:出场方式
    ViewLayer:层级类型
    IsMulti:是否允许多个同类界面共存
--]]
UIDefine.Config = {
    [UIDefine.ViewType.TemplateView] = {
        Class = "TemplateViewUI",
        EnterType = UIDefine.EnterType.ExitLast,
        ExitType = UIDefine.ExitType.None,
        ViewLayer = UIDefine.ViewLayer.NormalUI,
        IsMulti = true,
    },
    [UIDefine.ViewType.LoginView] = {
        Class = "LoginViewUI",
        EnterType = UIDefine.EnterType.ExitLast,
        ExitType = UIDefine.ExitType.None,
        ViewLayer = UIDefine.ViewLayer.NormalUI,
        IsMulti = false,
    },
    [UIDefine.ViewType.GameMenuView] = {
        Class = "GamePlayMenuViewUI",
        EnterType = UIDefine.EnterType.ExitLast,
        ExitType = UIDefine.ExitType.None,
        ViewLayer = UIDefine.ViewLayer.NormalUI,
        IsMulti = false,
    },
    [UIDefine.ViewType.GameView] = {
        Class = "GamePlayViewUI",
        EnterType = UIDefine.EnterType.ExitLast,
        ExitType = UIDefine.ExitType.None,
        ViewLayer = UIDefine.ViewLayer.NormalUI,
        IsMulti = false,
    },
    [UIDefine.ViewType.GenericView] = {
        Class = "GenericViewUI",
        ViewLayer = UIDefine.ViewLayer.HoldUI,
        IsMulti = false,
    },
    [UIDefine.ViewType.GuideView] = {
        Class = "GuideViewUI",
        ViewLayer = UIDefine.ViewLayer.HoldUI,
        IsMulti = false,
    },
}

UIDefine.ComUI = {
    [UIDefine.ComType.TemplateCom] = {
        Class = "TemplateComUI",
    },
    [UIDefine.ComType.LoginCom] = {
        Class = "LoginComUI",
    },
    [UIDefine.ComType.ServerListItem] = {
        Class = "ServerListItem",
    },
    [UIDefine.ComType.GamePlayMenuItem] = {
        Class = "GamePlayMenuItem",
    },
}

return UIDefine
