ProxyBase = Class("ProxyBase",ModuleBase)

function ProxyBase:OnInit()
    self.protoCallback = {}
end

function ProxyBase:OnInitComplete()
    self:AddGolbalListener(EGlobalEvent.Proto,self:ToFunc("HandleProto"), false)
end

function ProxyBase:ListenProto(proto, callback)
    self.protoCallback[proto] = {
        callback = callback
    }
end

function ProxyBase:HandleProto(proto,args)
    if self.protoCallback[proto] then
        local fn = self.protoCallback[proto].callback
        local _ = fn and fn(args)
    end
end

return ProxyBase