--公式计算器
--输入类似：1+((2+3)×4)-5，返回其结果
--支持输入变量和自定义运算，如 (a+b)*c 或者 a*c#c 其中#是自定义运算规则

--扩展，支持逻辑符号
--(a+-if(if(1+1!=2,!2,!3),b+c,d+f))*e+(1*-3/(4+8.25678+(6*-8)/123)+-458*(124*3)+max(1,2)/min(3,4))
--ceil(if(1,max(sqrt(2.2),pow(3,3)),min(sin(4.4),cos(5.5))))

Calculator = Class("Calculator")

Calculator.Log = false

---可以传入公式进行初始化
---@param str string
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

---设置公式
---@param str string
function Calculator:SetPattern(str)
    self.calPattern = str
end

---设置变量的值
---@param k any
---@param v number
function Calculator:SetVar(k,v)
    self.kvs[k] = v
    self.finalResult = nil
end

---计算并返回结果，相同的公式只会计算一次
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
        self:log("遍历当前",cur)
        if cur == CalcDefine.FuncArgSplit then
            --遇到逗号截断，并且跳过
            index = index + CalcDefine.FuncArgSplitLength
        else
            local fnName,endIndex = self:findFunc(cur,index,len)
            if fnName then
                -- 函数
                self:log("函数",fnName)
                self:addOp(CalcDefine.OpKind.Func,CalcDefine.FuncSign[fnName])
                index = endIndex + 1
            else
                local op,endIndex = self:findOp(cur,index,len)
                if op then
                    -- 运算符
                    self:log("运算符",cur)
                    if op == CalcDefine.OpType.LBracket then
                        self:addOp(CalcDefine.OpKind.Op,op)
                    elseif op == CalcDefine.OpType.RBracket then
                        self:popToLB()
                    else
                        self:insertOp(op)
                    end
                    index = endIndex + 1
                else
                    local num,endIndex = self:findNumber(cur,index,len)
                    if num then
                        -- 数字
                        self:log("数字",num)
                        self:addResult(CalcDefine.Type.Num, num)
                        index = endIndex + 1
                    else
                        -- 变量
                        local var,endIndex = self:findVar(cur,index,len)
                        if var then
                            self:log("变量",var)
                            self:addResult(CalcDefine.Type.Var, var)
                            index = endIndex + 1
                        else
                            PrintError("出现未知字符",cur,"无法解析公式:",self.calPattern)
                            return
                        end
                    end
                end
            end
            self:logStacks()
        end
    end
    self:log("添加剩余运算符")
    --TODO 检查这里是逆序还是顺序
    for i = #self.opStack, 1, -1 do
        local op = table.remove(self.opStack, i)
        if op.type == CalcDefine.OpKind.Op then
            self:addResult(CalcDefine.Type.Op, op.op)
        else
            self:addResult(CalcDefine.Type.Func, op.op)
        end
    end
    self:logStacks()
end

function Calculator:findOp(cur,startIndex,endIndex)
    if CalcDefine.OpSign[cur] then
        return CalcDefine.OpSign[cur],startIndex
    end
end

function Calculator:findNumber(curChar,startIndex,endIndex)
    if tonumber(curChar) == nil then
        return
    end
    local tb = {}
    local lastIndex = startIndex - 1
    for i = startIndex, endIndex do
        local cur = string.sub(self.calPattern, i, i)
        if cur == CalcDefine.FuncArgSplit then
            --遇到逗号截断，并且跳过
            lastIndex = lastIndex + CalcDefine.FuncArgSplitLength
            break
        end
        local op = CalcDefine.OpSign[cur]
        if op then
            break
        end
        table.insert(tb,cur)
        lastIndex = lastIndex + 1
    end
    return tonumber(table.concat(tb)),lastIndex
end

function Calculator:findVar(curChar,startIndex,endIndex)
    local str = string.sub(self.calPattern, startIndex, endIndex)
    local left,right = string.find(str,"%w+")
    if not left or not right then
        return
    end
    left = startIndex+left-1
    right = startIndex+right-1
    local var = string.sub(self.calPattern, left, right)
    return var,right
end

function Calculator:findFunc(curChar,startIndex,endIndex)
    local str = string.sub(self.calPattern, startIndex, endIndex)
    local left,right = string.find(str,CalcDefine.FuncSignPattern)
    if not left or not right then
        return
    end
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
        if op.op == CalcDefine.OpType.LBracket then
            break
        end
        self:addResult(CalcDefine.Type.Op, op.op)
    end
end

function Calculator:addOp(type,op)
    table.insert(self.opStack, {type=type,op=op})
end

function Calculator:insertOp(op)
    for i = #self.opStack,1,-1 do
        local data = self.opStack[i]
        local topType = data.type
        local topOp = data.op
        if topType == CalcDefine.OpKind.Op then
            if topOp == CalcDefine.OpType.LBracket
                    or CalcDefine.OpPriority[op] > CalcDefine.OpPriority[topOp] then
                break
            else
                table.remove(self.opStack, i)
                self:addResult(CalcDefine.Type.Op, topOp)
            end
        elseif topType == CalcDefine.OpKind.Func then
            table.remove(self.opStack, i)
            self:addResult(CalcDefine.Type.Func, topOp)
        else
            PrintError("未知OpKind",data)
            return
        end
    end
    self:addOp(CalcDefine.OpKind.Op,op)
end

--后缀表达式求值
function Calculator:calc()
    for _, data in ipairs(self.resultStack) do
        if data.type == CalcDefine.Type.Func then
            local result = self:callFunc(data.data)
            table.insert(self.calcStack, result)
        elseif data.type == CalcDefine.Type.Op then
            local result = self:callFuncByOp(data.data)
            table.insert(self.calcStack, result)
        elseif data.type == CalcDefine.Type.Var then
            if not self.kvs[data.data] then
                PrintError("未定义变量具体值",data.data)
                return
            end
            table.insert(self.calcStack, self.kvs[data.data])
        elseif data.type == CalcDefine.Type.Num then
            table.insert(self.calcStack, data.data)
        else
            PrintError("求值失败，未知类型",data)
            return
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
        if cur.type == CalcDefine.OpKind.Op then
            table.insert(ops, CalcDefine.OpSign[cur.op])
        else
            table.insert(ops, CalcDefine.FuncSign[cur.op])
        end
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