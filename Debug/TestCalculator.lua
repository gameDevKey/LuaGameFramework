-- local str = "((a-3)*(8-5)-2+(4-5))*(2-3)/(5-2)"
-- local str = "((a-3)*(8-5)-2+(4-5))"
local str = "if(1,2,3)"
local calc = Calculator.New()
calc:SetPattern(str)
calc:SetVar("a",9)
print("计算",str,"结果",calc:Calc())

-- local str = "a11b*23^sb"
-- local a,b,c = string.find(str,"%w+")
-- print("测试",str,'结果',a,b,c)