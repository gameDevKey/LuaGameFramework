local calc = Calculator.New()

local str = "((1-2)*(8-5)-2+(4-5))*(2-3)/(5-2)"
print("计算",str,"结果",calc:Calc(str))