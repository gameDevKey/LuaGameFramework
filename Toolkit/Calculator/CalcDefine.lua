CalcDefine = StaticClass("CalcDefine")

--ResultStack里面的类型
CalcDefine.Type = Enum.New({
    Op = 1,
    Num = 2,
    Var = 3,
    Func = 4,
})

--OpStack里面的类型
CalcDefine.OpKind = Enum.New({
    Op = 1,
    Func = 2,
})

--#region 函数

CalcDefine.FuncArgSplit = ","

CalcDefine.FuncType = {
    Add = 1,
    Sub = 2,
    Mul = 3,
    Div = 4,

    --自定义函数类型
    IF = 5,
}

-- 因为函数名需要和变量作区分，所以要单独标记一下
CalcDefine.FuncSign = Enum.New({
    [CalcDefine.FuncType.IF] = "if",
})

CalcDefine.Func = {
    [CalcDefine.FuncType.Add] = {
        fn = function (a,b)
            return a+b
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Sub] = {
        fn = function (a,b)
            return a-b
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Mul] = {
        fn = function (a,b)
            return a*b
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Div] = {
        fn = function (a,b)
            return a/b
        end,
        argsNum = 2,
    },

    --自定义函数
    [CalcDefine.FuncType.IF] = {
        fn = function (a,b,c)
            if a > 0 then
                return b
            end
            return c
        end,
        argsNum = 3,
    },
}

--#endregion

--#region 操作符

CalcDefine.OpType = Enum.New({
    Add = 1,
    Sub = 2,
    Mul = 3,
    Div = 4,
    LBracket = 5,
    RBracket = 6,
})

CalcDefine.OpSign = Enum.New({
    [CalcDefine.OpType.Add] = "+",
    [CalcDefine.OpType.Sub] = "-",
    [CalcDefine.OpType.Mul] = "*",
    [CalcDefine.OpType.Div] = "/",
    [CalcDefine.OpType.LBracket] = "(",
    [CalcDefine.OpType.RBracket] = ")",
})

CalcDefine.OpPriority = Enum.New({
    [CalcDefine.OpType.Add] = 1,
    [CalcDefine.OpType.Sub] = 1,
    [CalcDefine.OpType.Mul] = 2,
    [CalcDefine.OpType.Div] = 2,
    [CalcDefine.OpType.LBracket] = 9999,
    [CalcDefine.OpType.RBracket] = 9999,
},"OpPriority",{allowRepeat=true})

-- 操作符与函数的映射
CalcDefine.Op2Func = {
    [CalcDefine.OpType.Add] = CalcDefine.FuncType.Add,
    [CalcDefine.OpType.Sub] = CalcDefine.FuncType.Sub,
    [CalcDefine.OpType.Mul] = CalcDefine.FuncType.Mul,
    [CalcDefine.OpType.Div] = CalcDefine.FuncType.Div,
}

--#endregion

--#region 数据预处理

local funcSignPattern = {"["}
local tempFuncSignPattern = {}
for key, value in CalcDefine.FuncSign:Pairs() do
    table.insert(tempFuncSignPattern,value)
end
table.insert(funcSignPattern,table.concat(tempFuncSignPattern,"|"))
table.insert(funcSignPattern,"]+")
CalcDefine.FuncSignPattern = table.concat(funcSignPattern)

CalcDefine.FuncArgSplitLength = string.len(CalcDefine.FuncArgSplit)

--#endregion

return CalcDefine