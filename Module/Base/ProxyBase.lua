--代理基类，会在游戏启动前自动加载
--处理协议或者业务数据，数据更新后通过Facade或者全局事件向外通知
--禁止直接访问视图层
--函数InitComplete()会在Facade安装完成后自顶向下被调用
ProxyBase = Class("ProxyBase",ModuleBase)

function ProxyBase:OnInit()
    self.protoCallback = {}
end

function ProxyBase:OnDelete()
    for proto, callObject in pairs(self.protoCallback) do
        callObject:Delete()
    end
end

function ProxyBase:InitComplete()
    self:AddGolbalListenerWithSelfFunc(EGlobalEvent.Proto,"HandleProto", false)
end

function ProxyBase:ListenProto(proto, callback, caller)
    self.protoCallback[proto] = CallObject.New(callback,caller)
end

function ProxyBase:HandleProto(proto,args)
    local handler = self.protoCallback[proto]
    if handler then
        handler:Invoke(args)
    end
end

return ProxyBase