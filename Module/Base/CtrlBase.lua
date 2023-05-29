--控制器基类，会在游戏启动前自动加载
--处理业务逻辑，以及界面交互逻辑
--函数InitComplete()会在Facade安装完成后自顶向下被调用
CtrlBase = Class("CtrlBase",ModuleBase)

function CtrlBase:OnInitComplete()
end

function CtrlBase:BindMediator(view)
end

return CtrlBase