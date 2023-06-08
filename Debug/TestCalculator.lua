local tester = { tb={}, calculator = Calculator.New()}
function tester:add(calc,result)
    table.insert(self.tb,{calc=calc,result=result})
end
function tester:start()
    for index, data in ipairs(self.tb) do
        self.calculator:SetPattern(data.calc)
        local result = self.calculator:Calc()
        print("测试",data.calc,"结果",result,
            (result==data.result) and "正确" or "======错误=======")
    end
end

tester:add("((9-3)*(8-5)-2+(4-5))*(2-3)/(5-2)",-5)
tester:add("((9-3)*(8-5)-2+(4-5))",15)
tester:add("if((9-6),2,3)",2)
tester:add("not(3)+if(1,2,3)",2)

tester:add("if(if(1,2,3),2+3,4+5)",5)
tester:add("if(if(1+1!=2,not(2),not(3)),2+3,4+5)",9)
tester:add("1*-3/(4+8.25+(6*-8)/100",-11.77)
tester:add("-2*3",-6)
tester:add("-2*-3",6)
tester:add("-2*-if(1,2,3)",4)
tester:add("-1==-2",0)
tester:add("-if(1,2,3)",-2)
-- tester:add("(1-if(if(1+1!=2,not(2),not(3)),2+3,4+5))*6+(1*-3/(4+8.25678+(6*-8)/123)",)

tester:start()

--(a+-if(if(1+1!=2,!2,!3),b+c,d+f))*e+(1*-3/(4+8.25678+(6*-8)/123)+-458*(124*3)+max(1,2)/min(3,4))
--ceil(if(1,max(sqrt(2.2),pow(3,3)),min(sin(4.4),cos(5.5))))


-- local str = "2"
-- -- local str = "if(!3,8,9)"
-- -- local str = "2+!3"
-- -- local pat = "[*|/|==|>|>=|<|<=|!=|!|(|)|+|-]+"
-- local pat = "%d"

-- local a,b = string.find(str,pat)
-- print("find",str,a,b)

-- local a,b = string.match(str,pat)
-- print("match",str,a,b)