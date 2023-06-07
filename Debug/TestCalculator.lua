-- local str = "((a-3)*(8-5)-2+(4-5))*(2-3)/(5-2)" -- -2
-- local str = "((a-3)*(8-5)-2+(4-5))" -- 6
local str = "if((a-6),2,3)" -- 3
local calc = Calculator.New()
calc:SetPattern(str)
calc:SetVar("a",6)
print("计算",str,"结果",calc:Calc())