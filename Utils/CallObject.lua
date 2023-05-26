CallObject = Class("CallObject")

function CallObject:OnInit(func,caller, args)
    self.func = func
    self.caller = caller
    self.args = args
end

--触发回调，注意args拼接在回调的首位，后面才是传入的参数
function CallObject:Invoke(...)
    if self.func then
        if self.caller then
            if self.args then
                return self.func(self.caller,self.args,...)
            end
            return self.func(self.caller,...)
        end
        return self.func(...)
    end
end

function CallObject:GetFunc()
    return self.func,self.caller,self.args
end

return CallObject