UIDefine = {}

UIDefine.ViewType = Enum.New({
    MainView = Enum.Index,
    TestView = Enum.Index,
})

UIDefine.ComType = Enum.New({
    TestCom = Enum.Index,
})

--当界面进入时
UIDefine.EnterType = Enum.New({
    None = Enum.Index,
    ExitLast = Enum.Index,--关闭上一个界面
})

--当界面关闭时
UIDefine.ExitType = Enum.New({
    None = Enum.Index,
})

--[[
    界面配置
    Class:界面类
    EnterType:入场方式
    IsMulti:是否允许同时存在多个相同界面
--]]
UIDefine.Config = {
    [UIDefine.ViewType.MainView] = {
        Class = "MainView",
        EnterType = UIDefine.EnterType.None,
        ExitType = UIDefine.ExitType.None,
        IsMulti = false,
    },
    [UIDefine.ViewType.TestView] = {
        Class = "TestView",
        EnterType = UIDefine.EnterType.None,
        ExitType = UIDefine.ExitType.None,
        IsMulti = false,
    },
}
