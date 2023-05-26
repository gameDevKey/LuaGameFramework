TestProxy = SingletonClass("TestProxy",ProxyBase)

function TestProxy:InitComplete()
    -- print("绑定Test协议")
    self:ListenProto(ProtoDefine.Test, self:ToFunc("HandleTestProto"), self)
    self.dataWatcher = TableDataWatcher.New()
    self.dataWatcher:SetChangeFunc(self:ToFunc("OnDataChange"),self)
    self.dataWatcher:SetCompareFunc(self:ToFunc("OnDataCompare"),self)
end

function TestProxy:OnDelete()
    self.dataWatcher:Delete()
end

function TestProxy:HandleTestProto(data)
    PrintLog("处理Test协议",data)
    for key, value in pairs(data) do
        self.dataWatcher:SetVal(key,value)
    end
end

function TestProxy:OnDataChange(key,new,old)
    PrintLog("TestProxy:键",key,"发生变化",old,'->',new)
end

function TestProxy:OnDataCompare(key,new,old)
    PrintLog("TestProxy:比较 键",key,'新值:',new,'旧值:',old)
    return new == old
end

return TestProxy