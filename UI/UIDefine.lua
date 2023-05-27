UIDefine = {}

UIDefine.EnterType = Enum.New({
    ExitLast = Enum.Index,
    KeepLast = Enum.Index,
})

--[[
    界面配置
    Class:界面类
    EnterType:入场方式
    IsMulti:是否允许同时存在多个相同界面
--]]
UIDefine.Config = {
    MainView = {
        Class = MainView,
        EnterType = UIDefine.EnterType.KeepLast,
        IsMulti = false,
    },
}
