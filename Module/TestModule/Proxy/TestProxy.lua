TestProxy = SingletonClass("TestProxy",ProxyBase)

function TestProxy:InitComplete()
    -- print("绑定Test协议")
    self:ListenProto(ProtoDefine.Test, self:ToFunc("HandleTestProto"), self)
end

function TestProxy:HandleTestProto(data)
    PrintLog("处理Test协议",data)
end

return TestProxy