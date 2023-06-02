--处理一些纯业务逻辑（不涉及界面的逻辑）
LoginLogicCtrl = SingletonClass("LoginLogicCtrl",CtrlBase)

function LoginLogicCtrl:OnInitComplete()
    self:AddListenerWithSelfFunc(ELoginModule.LogicEvent.DoSomething, "LoginFunc", false)
end

function LoginLogicCtrl:LoginFunc(result)
    PrintLog("执行LoginLogicCtrl:LoginFunc",result)
    for i = 1, 3 do
        self:Broadcast(ELoginModule.ViewEvent.ActiveLoginView,{msg="数据"..i})
        UIManager.Instance:Log()
    end

    for i = 1, 2 do
        UIManager.Instance:ExitTop()
        UIManager.Instance:Log()
    end
end

return LoginLogicCtrl