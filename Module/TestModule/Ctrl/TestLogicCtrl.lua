--处理一些纯业务逻辑（不涉及界面的逻辑）
TestLogicCtrl = SingletonClass("TestLogicCtrl",CtrlBase)

function TestLogicCtrl:TestFunc()
    print("执行TestLogicCtrl:TestFunc")
end

return TestLogicCtrl