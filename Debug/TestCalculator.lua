local tester = { tb = {}, calculator = Calculator.New() }
function tester:add(calc, result)
    table.insert(self.tb, { calc = calc, result = result })
end

function tester:start()
    for index, data in ipairs(self.tb) do
        self.calculator:SetPattern(data.calc)
        local result = self.calculator:Calc()

        if result ~= data.result then
            print(data.calc, "结果", result, "错误,应为", data.result)
        end
    end
    print("测试结束")
end

-- 逻辑
-- tester:add("not(3)+if(1,2,3)", 2)
-- tester:add("if((9-6),2,3)", 2)
-- tester:add("-if(1,2,3)", -2)
-- tester:add("(1-if(if(1+1!=2,not(2),not(3)),2+3,4+5))*6+(1*-33/(4+8+(6*-8)/48)", -51)
-- tester:add("if(if(1,2,3),2+3,4+5)", 5)
-- tester:add("if(if(1+1!=2,not(2),not(3)),2+3,4+5)", 9)
-- tester:add("not(0)", 1)
-- tester:add("max(1,2)", 2)
-- tester:add("min(3,4)", 3)

-- 四则运算
-- tester:add("((9-3)*(8-5)-2+(4-5))*(2-3)/(5-2)", -5)
-- tester:add("1*-1/(1+1.05+(1*-2))/2.5", -8) --这里的错误应该是除法有浮点数但是没有显示出来
-- tester:add("-+1*-2+-24", -22)
-- tester:add("--3", 3)
-- tester:add("+-3", -3)
-- tester:add("+-3-+4", -7)
-- tester:add("-2*3", -6)
-- tester:add("-2*-3", 6)
-- tester:add("-2*-if(1,2,3)", 4)

-- 比较
-- tester:add("-1==-2", 0)
-- tester:add("-1>=-2", 1)
-- tester:add("-1>-2", 1)
-- tester:add("-1<=-2", 0)
-- tester:add("-1<-2", 0)
-- tester:add("-1!=-2", 1)

-- 错误输入
-- tester:add("1>>>2", 0)

tester:start()


--复用逻辑
-- local calculator = Calculator.New()
-- calculator:SetPattern("1+a-5")
-- calculator:SetVarVal("a", 100)
-- print("100 结果", calculator:Calc())
-- calculator:SetVarVal("a", 200)
-- print("200 结果", calculator:Calc())
-- calculator:SetPattern("1+a")
-- calculator:SetVarVal("a", 300)
-- print("200 结果", calculator:Calc())
-- calculator:SetVarVal("a", 400)
-- print("200 结果", calculator:Calc())
