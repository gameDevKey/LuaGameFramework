--[[
    公式计算器
    用法:
    local str = "((a-3)*(8-5)-2+(4-5))*(2-3)/(5-2)"
    local calc = Calculator.New()
    calc:SetPattern(str)
    calc:SetVar("a",6)
    print("计算",str,"结果",calc:Calc())
--]]

Calculator = Class("Calculator")

Calculator.Log = false

function Calculator:OnInit()
    self:reset()
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
    -- self:fixCalcPattern(str)
    self.finalResult = nil
end

---设置变量的值
---@param k any
---@param v number
function Calculator:SetVarVal(k, v)
    self.kvs[k] = v
    self.finalResult = nil
end

---计算并返回结果，相同的公式只会计算一次
function Calculator:Calc()
    if self.finalResult then
        return self.finalResult
    end
    self:parse()
    self.finalResult = self:calc()
    self:reset()
    return self.finalResult
end

function Calculator:reset()
    self.opStack = {}     --运算符堆栈
    self.resultStack = {} --后缀表达式堆栈
    self.calcStack = {}   --求值堆栈
    self.kvs = {}         --自定义键值对
    self.waitOps = {}
end

--中缀表达式转后缀表达式
function Calculator:parse()
    local len = string.len(self.calPattern)
    local index = 1
    local lastElem = {}
    while index <= len do
        local cur = string.sub(self.calPattern, index, index)
        self:log("----当前字符 ", cur, ' ----   位置', index)
        if cur == CalcDefine.FuncArgSplit then
            --遇到逗号截断，上一组Op入栈，并且跳过
            self:popLastOp()
            index = index + CalcDefine.FuncArgSplitLength
            lastElem.data = cur
            lastElem.type = nil
        else
            local num, endIndex = self:findNumber(cur, index, len)
            if num then
                -- 数字
                self:log("数字", num)
                self:addResult(CalcDefine.Type.Num, num)
                index = endIndex + 1
                lastElem.data = cur
                lastElem.type = CalcDefine.Type.Num
            else
                local fnName, endIndex = self:findFunc(cur, index, len)
                if fnName then
                    -- 函数
                    self:log("函数", fnName)
                    self:addOp(CalcDefine.OpKind.Func, CalcDefine.FuncSign[fnName])
                    index = endIndex + 1
                    lastElem.data = cur
                    lastElem.type = CalcDefine.Type.Func
                else
                    local op, endIndex = self:findOp(cur, index, len)
                    if op then
                        -- 运算符
                        self:log("运算符", op)
                        if ( op == CalcDefine.OpType.Sub or op == CalcDefine.OpType.Add )
                            and ( index == 1 or lastElem.type == CalcDefine.Type.Op ) then
                            -- +/-比较特殊，可以用来修饰后面的组，比如-2*-3,4*-(4+5)
                            self:pushWaitOp(op)
                        else
                            if op == CalcDefine.OpType.LBracket then
                                self:addOp(CalcDefine.OpKind.Op, op)
                            elseif op == CalcDefine.OpType.RBracket then
                                self:popToLB()
                            else
                                self:insertOp(op)
                            end
                        end
                        index = endIndex + 1
                        lastElem.data = cur
                        lastElem.type = CalcDefine.Type.Op
                    else
                        -- 变量
                        local var, endIndex = self:findVar(cur, index, len)
                        if var then
                            self:log("变量", var)
                            self:addResult(CalcDefine.Type.Var, var)
                            index = endIndex + 1
                            lastElem.data = cur
                            lastElem.type = CalcDefine.Type.Var
                        else
                            PrintError("出现未知字符", cur, "无法解析公式:", self.calPattern)
                            return
                        end
                    end
                end
            end
            self:logStacks()
        end
    end
    self:log("添加剩余运算符")
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

function Calculator:findOp(cur, startIndex, endIndex)
    if string.find(cur, "%w") then
        return
    end
    if CalcDefine.OpSign[cur] then
        return CalcDefine.OpSign[cur], startIndex
    end
    --两位长度以上的运算符走正则，前提是运算符之间不可粘连
    local str = string.sub(self.calPattern, startIndex, endIndex)
    local left, right = string.find(str, CalcDefine.OpSignPattern)
    if not left or not right then
        return
    end
    left = startIndex + left - 1
    right = startIndex + right - 1
    local var = string.sub(self.calPattern, left, right)
    return CalcDefine.OpSign[var], right
end

function Calculator:findNumber(curChar, startIndex, endIndex)
    if tonumber(curChar) == nil then
        return
    end
    local tb = {}
    local lastIndex = startIndex - 1
    for i = startIndex, endIndex do
        local cur = string.sub(self.calPattern, i, i)
        if cur == CalcDefine.FuncArgSplit then
            break
        end
        if cur ~= "." and not string.find(cur, "%d") then
            break
        end
        table.insert(tb, cur)
        lastIndex = lastIndex + 1
    end
    return tonumber(table.concat(tb)), lastIndex
end

function Calculator:findVar(curChar, startIndex, endIndex)
    if tonumber(curChar) then
        return
    end
    local str = string.sub(self.calPattern, startIndex, endIndex)
    local left, right = string.find(str, "%w+")
    if not left or not right then
        return
    end
    left = startIndex + left - 1
    right = startIndex + right - 1
    local var = string.sub(self.calPattern, left, right)
    return var, right
end

function Calculator:findFunc(curChar, startIndex, endIndex)
    if not string.find(curChar, "%a") then
        return
    end
    local str = string.sub(self.calPattern, startIndex, endIndex)
    local left, right = string.find(str, CalcDefine.FuncSignPattern)
    if not left or not right then
        return
    end
    left = startIndex + left - 1
    right = startIndex + right - 1
    local var = string.sub(self.calPattern, left, right)
    return var, right
end

function Calculator:popLastOp()
    local len = #self.opStack
    local topOp = self.opStack[len]
    if topOp then
        if topOp.type == CalcDefine.OpKind.Op and topOp.op == CalcDefine.OpType.LBracket then
            return
        end
        table.remove(self.opStack, len)
        if topOp.type == CalcDefine.OpKind.Op then
            self:addResult(CalcDefine.Type.Op, topOp.op)
        elseif topOp.type == CalcDefine.OpKind.Func then
            self:addResult(CalcDefine.Type.Func, topOp.op)
        end
    end
end

function Calculator:popToLB()
    for i = #self.opStack, 1, -1 do
        local op = table.remove(self.opStack, i)
        if op.type == CalcDefine.OpKind.Op then
            if op.op == CalcDefine.OpType.LBracket then
                --函数都是右侧调用的，括号闭合时直接让函数入栈
                local top = self.opStack[i - 1]
                if top and top.type == CalcDefine.OpKind.Func then
                    self:log("括号闭合时直接让函数入栈")
                    op = table.remove(self.opStack, i - 1)
                    self:addResult(CalcDefine.Type.Func, op.op)
                end
                self:popWaitOp()
                break
            end
            self:addResult(CalcDefine.Type.Op, op.op)
        elseif op.type == CalcDefine.OpKind.Func then
            self:addResult(CalcDefine.Type.Func, op.op)
        end
    end
end

function Calculator:addResult(type, data)
    local sc = { type = type, data = data }
    table.insert(self.resultStack, sc)
    if type == CalcDefine.Type.Num or type == CalcDefine.Type.Var then
        local valid = true
        for _, op in ipairs(self.opStack) do
            if op.type == CalcDefine.OpKind.Func then
                valid = false
            end
        end
        if valid then
            self:popWaitOp()
        end
    end
end

function Calculator:addOp(type, op)
    local sc = { type = type, op = op }
    table.insert(self.opStack, sc)
end

function Calculator:insertOp(op)
    for i = #self.opStack, 1, -1 do
        local data = self.opStack[i]
        local topType = data.type
        local topOp = data.op
        if topType == CalcDefine.OpKind.Op then
            if topOp == CalcDefine.OpType.LBracket then
                --左括号停止
                break
            elseif CalcDefine.OpPriority[op] > CalcDefine.OpPriority[topOp] then
                --当前符号优先级比栈顶符号高，停止
                break
            else
                --栈顶符号入result栈，保证优先运算
                table.remove(self.opStack, i)
                self:addResult(CalcDefine.Type.Op, topOp)
            end
        elseif topType == CalcDefine.OpKind.Func then
            --函数入result栈，保证优先运算
            table.remove(self.opStack, i)
            self:addResult(CalcDefine.Type.Func, topOp)
        else
            PrintError("未知OpKind", data)
            return
        end
    end
    self:addOp(CalcDefine.OpKind.Op, op)
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
                PrintError("未定义变量具体值", data.data)
                return
            end
            table.insert(self.calcStack, self.kvs[data.data])
        elseif data.type == CalcDefine.Type.Num then
            table.insert(self.calcStack, data.data)
        else
            PrintError("求值失败，未知类型", data)
            return
        end
    end
    if #self.calcStack ~= 1 then
        PrintError("计算出错，请检查逻辑")
        return
    end
    return self.calcStack[1]
end

function Calculator:callFunc(fnType)
    if not fnType then
        return
    end
    local fnData = CalcDefine.Func[fnType]
    if not fnData then
        PrintError("未配置求值函数 FuncType=", fnType)
        return
    end
    local fn = fnData.fn
    local args = {}
    local argsCount = 0
    for i = fnData.argsNum, 1, -1 do
        local index = fnData.argsNum - i + 1 --倒序
        local num = table.remove(self.calcStack)
        args[index] = num or fnData.defaultVal
        if args[index] ~= nil then
            argsCount = argsCount + 1
        end
    end
    self:log("计算", fnType, args)
    if fnData.argsNum ~= argsCount then
        PrintError("函数", fnType, '需要', fnData.argsNum, '个参数，却输入了', argsCount, '个')
        return
    end
    return fn(table.SafeUpack(args))
end

function Calculator:callFuncByOp(op)
    return self:callFunc(CalcDefine.Op2Func[op])
end

--入栈时机
--1.运算符粘连
--2.首字符为运算符
function Calculator:pushWaitOp(op)
    table.insert(self.waitOps,op)
    self:log(" >>> pushWaitOp",CalcDefine.OpSign[op])
end

--出栈时机
--1.右括号闭合
--2.在非函数体内时，数字或者变量加入了result栈
function Calculator:popWaitOp()
    local op = #self.waitOps > 0 and table.remove(self.waitOps)
    if op then
        self:log(" >>> popWaitOp",CalcDefine.OpSign[op])
        if op == CalcDefine.OpType.Add then
            self:addResult(CalcDefine.Type.Num, 1)
        elseif op == CalcDefine.OpType.Sub then
            self:addResult(CalcDefine.Type.Num, -1)
        else
            PrintError("错误的类型",op)
            return
        end
        self:addResult(CalcDefine.Type.Op, CalcDefine.OpType.Mul)
    end
end

--#region 分析过程太复杂了尤其是要考虑函数的闭合问题

-- --公式格式化
-- function Calculator:fixCalcPattern(str)
--     local len = string.len(str)
--     local index = 1
--     local stack = {}
--     while index <= len do
--         local cur = string.sub(str, index, index)
--         if cur == CalcDefine.FuncArgSplit then
--             index = index + CalcDefine.FuncArgSplitLength
--             table.insert(stack,{data=cur,type=nil})
--         else
--             local num, endIndex = self:findNumber(cur, index, len)
--             if num then
--                 index = endIndex + 1
--                 table.insert(stack,{data=num,type=CalcDefine.Type.Num})
--             else
--                 local fnName, endIndex = self:findFunc(cur, index, len)
--                 if fnName then
--                     index = endIndex + 1
--                     table.insert(stack,{data=fnName,type=CalcDefine.Type.Func})
--                 else
--                     local op, endIndex = self:findOp(cur, index, len)
--                     if op then
--                         index = endIndex + 1
--                         table.insert(stack,{data=CalcDefine.OpSign[op],type=CalcDefine.Type.Op})
--                     else
--                         local var, endIndex = self:findVar(cur, index, len)
--                         if var then
--                             index = endIndex + 1
--                             table.insert(stack,{data=var,type=CalcDefine.Type.Var})
--                         else
--                             PrintError("出现未知字符", cur, "无法解析公式:", str)
--                             return
--                         end
--                     end
--                 end
--             end
--         end
--     end
--     PrintLog("stack:",stack)
--     -- 加号/减号补全：
--     -- 1.运算符粘连 -a*-b ==> (0-a)*(0-b)
--     -- 2.首个字符就是运算符  -a ==> 0-a
--     local len = #stack
--     local index = 1
--     local result = {}
--     local last
--     while index <= len do
--         local ele = stack[index]
--         --运算符粘连
--         if ele.type == CalcDefine.Type.Op and last and last.type == CalcDefine.Type.Op then
--             if ele.data == "-" or ele.data == "+" then
--                 table.insert(result,"(0")
--                 table.insert(result,ele.data)
--                 local nextIndex
--                 local findFunc = false
--                 for j = index+1, len do
--                     local next = stack[j]
--                     if next.type == CalcDefine.Type.Func then
--                         findFunc = true
--                     elseif next.type == CalcDefine.Type.Op then
--                         if not findFunc then
                            
--                         end
--                         if next.data == ")" then
--                             break
--                         end
--                     end
--                     table.insert(result,ele.data)
--                     nextIndex = j
--                 end
--                 if nextIndex then
--                     index = nextIndex+1
--                     table.insert(result,")")
--                 end
--             else
--                 PrintLog("公式有误，运算符粘连",str)
--                 return
--             end
--         else
--             table.insert(result,ele.data)
--             index = index + 1
--         end
--         last = ele
--     end
-- end

--#endregion

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
    PrintLog("当前opStack", table.concat(ops, ' '))
    local res = {}
    for _, cur in ipairs(self.resultStack) do
        if cur.type == CalcDefine.Type.Op then
            table.insert(res, CalcDefine.OpSign[cur.data])
        elseif cur.type == CalcDefine.Type.Func then
            table.insert(res, CalcDefine.FuncSign[cur.data])
        else
            table.insert(res, tostring(cur.data))
        end
    end
    PrintLog("当前resultStack", table.concat(res, ' '))
end

return Calculator
