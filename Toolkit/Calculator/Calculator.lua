--公式计算器
--输入类似：1+((2+3)×4)-5，返回其结果
--支持输入变量和自定义运算，如 (a+b)*c 或者 a*c#c 其中#是自定义运算规则

--扩展，支持逻辑符号
--(a+-if(if(1+1!=2,!2,!3),b+c,d+f))*e+(1*-3/(4+8.25678+(6*-8)/123)+-458*(124*3)+max(1,2)/min(3,4))
--ceil(if(1,max(sqrt(2.2),pow(3,3)),min(sin(4.4),cos(5.5))))

Calculator = Class("Calculator")

Calculator.Log = false

function Calculator:OnInit(str)
    self:reset()
    self:SetPattern(str)
end

function Calculator:OnDelete()
    self.opStack = nil
    self.resultStack = nil
    self.calcStack = nil
    self.kvs = nil
end

function Calculator:SetPattern(str)
    self.calPattern = str
end

function Calculator:SetVar(k,v)
    self.kvs[k] = v
end

function Calculator:Calc()
    if self.finalResult then
        return self.finalResult
    end
    self:parse()
    return self:calc()
end

function Calculator:reset()
    self.opStack = {}       --运算符堆栈
    self.resultStack = {}   --后缀表达式堆栈
    self.calcStack = {}     --求值堆栈
    self.kvs = {}           --自定义键值对
end

--中缀表达式转后缀表达式
function Calculator:parse()
    local len = string.len(self.calPattern)
    local index = 1
    while index <= len do
        local cur = string.sub(self.calPattern, index, index)
        local op = CalcDefine.OpSign[cur]
        if op then
            -- 运算符
            self:log("运算符",cur)
            if op == CalcDefine.OpType.LBracket then
                table.insert(self.opStack, op)
            elseif op == CalcDefine.OpType.RBracket then
                self:popToLB()
            else
                self:insertOp(op)
            end
            index = index + 1
        else
            if tonumber(cur) then
                -- 数字
                local num,endIndex = self:findNumber(index,len)
                if not num or endIndex == 0 then
                    PrintError("数字查找失败，位置:",index)
                    return
                end
                self:log("操作数",num)
                self:addResult(CalcDefine.Type.Num, num)
                index = endIndex + 1
            else
                -- 变量
                local var,endIndex = self:findVar(index,len)
                if not var or endIndex == 0 then
                    PrintError("变量查找失败，位置:",index)
                    return
                end
                self:log("操作数[变量]",var)
                self:addResult(CalcDefine.Type.Var, var)
                index = endIndex + 1
            end
        end
        self:logStacks()
    end
    --TODO 检查这里是逆序还是顺序
    for i = #self.opStack, 1, -1 do
        local op = table.remove(self.opStack, i)
        self:addResult(CalcDefine.Type.Op, op)
    end
    self:logStacks()
end

function Calculator:findNumber(startIndex,endIndex)
    local tb = {}
    local lastIndex = startIndex - 1
    for i = startIndex, endIndex do
        local cur = string.sub(self.calPattern, i, i)
        local op = CalcDefine.OpSign[cur]
        if op then
            break
        end
        table.insert(tb,cur)
        lastIndex = lastIndex + 1
    end
    return tonumber(table.concat(tb)),lastIndex
end

function Calculator:findVar(startIndex,endIndex)
    local str = string.sub(self.calPattern, startIndex, endIndex)
    local left,right = string.find(str,"%w+")
    left = startIndex+left-1
    right = startIndex+right-1
    local var = string.sub(self.calPattern, left, right)
    return var,right
end

function Calculator:addResult(type, data)
    table.insert(self.resultStack, {type=type, data=data})
end

function Calculator:popToLB()
    for i = #self.opStack, 1, -1 do
        local op = table.remove(self.opStack, i)
        if op == CalcDefine.OpType.LBracket then
            break
        end
        self:addResult(CalcDefine.Type.Op, op)
    end
end

function Calculator:insertOp(op)
    for i = #self.opStack,1,-1 do
        local topOp = self.opStack[i]
        if topOp == CalcDefine.OpType.LBracket
            or CalcDefine.OpPriority[op] > CalcDefine.OpPriority[topOp] then
            break
        else
            table.remove(self.opStack, i)
            self:addResult(CalcDefine.Type.Op, topOp)
        end
    end
    table.insert(self.opStack, op)
end

--后缀表达式求值
function Calculator:calc()
    for _, data in ipairs(self.resultStack) do
        if data.type == CalcDefine.Type.Op then
            local result = self:callFuncByOp(data.data)
            table.insert(self.calcStack, result)
        elseif data.type == CalcDefine.Type.Var then
            if not self.kvs[data.data] then
                PrintError("未定义变量具体值",data.data)
                return
            end
            table.insert(self.calcStack, self.kvs[data.data])
        else
            table.insert(self.calcStack, data.data)
        end
    end
    if #self.calcStack ~= 1 then
        PrintError("计算出错，请检查逻辑")
        return
    end
    self.finalResult = self.calcStack[1]
    self:reset()
    return self.finalResult
end

function Calculator:callFunc(fnType)
    if not fnType then
        return
    end
    local fnData = CalcDefine.Func[fnType]
    if not fnData then
        PrintError("未配置求值函数 FuncType=",fnType)
        return
    end
    local fn = fnData.fn
    local args = {}
    for i = fnData.argsNum, 1, -1 do
        local arg = table.remove(self.calcStack)
        table.insert(args,1,arg)
    end
    if fnData.argsNum ~= #args then
        PrintError("参数个数不匹配 FuncType=",fnType)
        return
    end
    return fn(table.SafeUpack(args))
end

function Calculator:callFuncByOp(op)
    return self:callFunc(CalcDefine.Op2Func[op])
end

function Calculator:log(...)
    if not self.Log then
        return
    end
    PrintLog(...)
end

function Calculator:logStacks()
    if not self.Log then
        return
    end
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