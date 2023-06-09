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

CalcDefine.FuncType = Enum.New({
    Add = "Add",
    Sub = "Sub",
    Mul = "Mul",
    Div = "Div",
    IF = "IF",
    Equal = "Equal",
    Large = "Large",
    LargeEqual ="LargeEqual",
    Small ="Small",
    SmallEqual = "SmallEqual",
    NotEqual = "NotEqual",
    Not = "Not",
    Max = "Max",
    Min = "Min",
})

-- 因为函数名需要和变量作区分，所以要单独标记一下
CalcDefine.FuncSign = Enum.New({
    [CalcDefine.FuncType.IF] = "if",
    [CalcDefine.FuncType.Not] = "not",
    [CalcDefine.FuncType.Max] = "max",
    [CalcDefine.FuncType.Min] = "min",
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
    [CalcDefine.FuncType.IF] = {
        fn = function (a,b,c)
            return a > 0 and b or c
        end,
        argsNum = 3,
    },
    [CalcDefine.FuncType.Equal] = {
        fn = function (a,b)
            return a==b and 1 or 0
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Large] = {
        fn = function (a,b)
            return a>b and 1 or 0
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.LargeEqual] = {
        fn = function (a,b)
            return a>=b and 1 or 0
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Small] = {
        fn = function (a,b)
            return a<b and 1 or 0
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.SmallEqual] = {
        fn = function (a,b)
            return a<=b and 1 or 0
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.NotEqual] = {
        fn = function (a,b)
            return a~=b and 1 or 0
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Not] = {
        fn = function (a)
            return a == 0 and 1 or 0
        end,
        argsNum = 1,
    },
    [CalcDefine.FuncType.Min] = {
        fn = function (a,b)
            return a < b and a or b
        end,
        argsNum = 2,
    },
    [CalcDefine.FuncType.Max] = {
        fn = function (a,b)
            return a > b and a or b
        end,
        argsNum = 2,
    },
}

--#endregion

--#region 操作符

CalcDefine.OpType = Enum.New({
    LBracket = Enum.Index,
    RBracket = Enum.Index,
    Add = Enum.Index,
    Sub = Enum.Index,
    Mul = Enum.Index,
    Div = Enum.Index,
    Equal = Enum.Index,
    Large = Enum.Index,
    LargeEqual = Enum.Index,
    Small = Enum.Index,
    SmallEqual = Enum.Index,
    NotEqual = Enum.Index,
})

CalcDefine.OpSign = Enum.New({
    [CalcDefine.OpType.LBracket] = "(",
    [CalcDefine.OpType.RBracket] = ")",
    [CalcDefine.OpType.Add] = "+",
    [CalcDefine.OpType.Sub] = "-",
    [CalcDefine.OpType.Mul] = "*",
    [CalcDefine.OpType.Div] = "/",
    [CalcDefine.OpType.Equal] = "==",
    [CalcDefine.OpType.Large] = ">",
    [CalcDefine.OpType.LargeEqual] = ">=",
    [CalcDefine.OpType.Small] = "<",
    [CalcDefine.OpType.SmallEqual] = "<=",
    [CalcDefine.OpType.NotEqual] = "!=",
})

CalcDefine.OpPriority = Enum.New({
    -- 括号是最高优先级
    [CalcDefine.OpType.LBracket] = 9999,
    [CalcDefine.OpType.RBracket] = 9999,
    -- 先乘除
    [CalcDefine.OpType.Mul] = 20,
    [CalcDefine.OpType.Div] = 20,
    -- 后加减
    [CalcDefine.OpType.Add] = 10,
    [CalcDefine.OpType.Sub] = 10,
    -- 比较
    [CalcDefine.OpType.Equal] = 5,
    [CalcDefine.OpType.Large] = 5,
    [CalcDefine.OpType.LargeEqual] = 5,
    [CalcDefine.OpType.Small] = 5,
    [CalcDefine.OpType.SmallEqual] = 5,
    [CalcDefine.OpType.NotEqual] = 5,
},"OpPriority",{allowRepeat=true})

-- 操作符与函数的映射（操作符其实也是一种函数，所以需要转义）
CalcDefine.Op2Func = {
    [CalcDefine.OpType.Add] = CalcDefine.FuncType.Add,
    [CalcDefine.OpType.Sub] = CalcDefine.FuncType.Sub,
    [CalcDefine.OpType.Mul] = CalcDefine.FuncType.Mul,
    [CalcDefine.OpType.Div] = CalcDefine.FuncType.Div,
    [CalcDefine.OpType.Equal] = CalcDefine.FuncType.Equal,
    [CalcDefine.OpType.Large] = CalcDefine.FuncType.Large,
    [CalcDefine.OpType.LargeEqual] = CalcDefine.FuncType.LargeEqual,
    [CalcDefine.OpType.Small] = CalcDefine.FuncType.Small,
    [CalcDefine.OpType.SmallEqual] = CalcDefine.FuncType.SmallEqual,
    [CalcDefine.OpType.NotEqual] = CalcDefine.FuncType.NotEqual,
}

--#endregion

--#region 数据预处理

CalcDefine.FuncArgSplitLength = string.len(CalcDefine.FuncArgSplit)

--初始化查找字典
local function init_sign_map(enum)
    local map = {}
    local maxLen = 0
    for _, sign in enum:Pairs() do
        local len = string.len(sign)
        if len > maxLen then
            maxLen = len
        end
        for i = 1, len do
            local subSign = string.sub(sign,i,i)
            map[subSign] = true
        end
    end
    return map,maxLen
end

CalcDefine.FuncSignMap,CalcDefine.MAX_FUNC_LEN = init_sign_map(CalcDefine.FuncSign)
CalcDefine.OpSignMap,CalcDefine.MAX_OP_LEN = init_sign_map(CalcDefine.OpSign)

--#endregion

return CalcDefine