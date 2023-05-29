TestProxy = SingletonClass("TestProxy",ProxyBase)

function TestProxy:OnInitComplete()
    -- PrintLog("绑定Test协议")
    self:ListenData("Test.data","TestDataChange")
    self:ListenData("Test.a.c","TestDataChange1")
    self:ListenProto(ProtoDefine.Test, "HandleTestProto")
end

function TestProxy:OnDelete()
end

function TestProxy:HandleTestProto(data)
    -- PrintLog("处理Test协议",data)
end

function TestProxy:TestDataChange(new,old)
    PrintLog("TestProxy:Test.data 新值",new,'旧值',old)
end

function TestProxy:TestDataChange1(new,old)
    PrintLog("TestProxy:Test.a.c 新值",new,'旧值',old)
end

return TestProxy