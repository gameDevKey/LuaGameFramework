local Calculator = Class("Calculator")

Calculator.SignType = {
    Plus = "+",
    Minus = "-",
    Multiply = "*",
    Divide = "/",
}

function Calculator:OnInit(pattern)
    self.pattern = pattern
    self.tbVar = {}
    self.tbCalcItem = {}
    self.result = nil
end

function Calculator:SetVar(var, value)
    self.tbVar[var] = value
end

function Calculator:StartParse()

end

function Calculator:ParseSubPattern(subPattern)

end

function Calculator:Calc(item) -- sign, var1, var2
    if item.sign == Calculator.SignType.Plus then
        return item.var1 + item.var2
    end
    if item.sign == Calculator.SignType.Minus then
        return item.var1 - item.var2
    end
    if item.sign == Calculator.SignType.Multiply then
        return item.var1 * item.var2
    end
    if item.sign == Calculator.SignType.Divide then
        if item.var2 == 0 then
            PrintError("除数不能为0 ", item)
        end
        return item.var1 / item.var2
    end
end

function Calculator:GetResult()
    if not self.result then
        self:StartParse()
    end
    return self.result
end

function Calculator:OnDelete()
end

return Calculator
