--公式计算器
--输入类似：1+((2+3)×4)-5，返回其结果
--支持输入变量和自定义运算，如 (a+b)*c 或者 a*c#c 其中#是自定义运算规则

--扩展，支持逻辑符号
--(a+-if(if(1+1!=2,!2,!3),b+c,d+f))*e+(1*-3/(4+8.25678+(6*-8)/123)+-458*(124*3)+max(1,2)/min(3,4))
--ceil(if(1,max(sqrt(2.2),pow(3,3)),min(sin(4.4),cos(5.5))))



Calculator = Class("Calculator")

function Calculator:OnInit()
    self:reset()
end

function Calculator:Calc(str)
    -- PrintLog("计算",str)
    self:reset()
    self.calPattern = str
    self:parse()
    return self:calc()
end

function Calculator:reset()
    self.calPattern = nil
    self.opStack = {}       --运算符
    self.resultStack = {}   --后缀表达式堆栈
    self.calcStack = {}
end

--中缀表达式转后缀表达式
--TODO 支持小数点
function Calculator:parse()
    for i = 1, string.len(self.calPattern) do
        local cur = string.sub(self.calPattern, i, i)
        local op = CalcDefine.OpSign[cur]
        if op then
            -- PrintLog("运算符",cur)
            if op == CalcDefine.OpType.LBracket then
                self:addOp(op)
            elseif op == CalcDefine.OpType.RBracket then
                self:popToLB()
            else
                self:insertOp(op)
            end
        else
            -- PrintLog("操作数",cur)
            local num = tonumber(cur)
            if not num then
                PrintError("数字转换失败",cur)
                return
            end
            self:addResult(CalcDefine.Type.Num, num)
        end
        -- self:log()
    end
    --TODO 检查这里是逆序还是顺序
    for i = #self.opStack, 1, -1 do
        local op = self:removeOp(i)
        self:addResult(CalcDefine.Type.Op, op)
    end
    -- self:log()
end

function Calculator:addResult(type, data)
    table.insert(self.resultStack, {type=type, data=data})
end

function Calculator:popToLB()
    for i = #self.opStack, 1, -1 do
        local op = self:removeOp(i)
        if op == CalcDefine.OpType.LBracket then
            break
        end
        self:addResult(CalcDefine.Type.Op, op)
    end
end

function Calculator:addOp(op)
    table.insert(self.opStack, op)
end

function Calculator:removeOp(index)
    return table.remove(self.opStack, index)
end

function Calculator:insertOp(op)
    for i = #self.opStack,1,-1 do
        local topOp = self.opStack[i]
        if topOp == CalcDefine.OpType.LBracket
            or CalcDefine.OpPriority[op] > CalcDefine.OpPriority[topOp] then
            break
        else
            self:removeOp(i)
            self:addResult(CalcDefine.Type.Op, topOp)
        end
    end
    self:addOp(op)
end

--后缀表达式求值
function Calculator:calc()
    for _, data in ipairs(self.resultStack) do
        if data.type == CalcDefine.Type.Op then
            local num2 = table.remove(self.calcStack, #self.calcStack)
            local num1 = table.remove(self.calcStack, #self.calcStack)
            if not num1 or not num2 then
                PrintError("参数不足, 请检查parse逻辑")
                return
            end
            local fn = CalcDefine.OpFunc[data.data]
            if not fn then
                PrintError("未定义求值函数 OpType=",data.data)
                return
            end
            local result = fn(num1,num2)
            -- PrintLog("计算",num1,CalcDefine.OpSign[data.data],num2,'=',result)
            table.insert(self.calcStack, result)
        else
            table.insert(self.calcStack, data.data)
        end
    end
    if #self.calcStack ~= 1 then
        PrintError("计算出错，请检查逻辑")
        return
    end
    return self.calcStack[1]
end

function Calculator:log()
    local ops = {}
    for _, cur in ipairs(self.opStack) do
        table.insert(ops, CalcDefine.OpSign[cur])
    end
    PrintLog("当前opStack",table.concat(ops,' '))
    local res = {}
    for _, cur in ipairs(self.resultStack) do
        if cur.type == CalcDefine.Type.Op then
            table.insert(res, CalcDefine.OpSign[cur.data])
        else
            table.insert(res, tostring(cur.data))
        end
    end
    PrintLog("当前resultStack",table.concat(res,' '))
end

return Calculator