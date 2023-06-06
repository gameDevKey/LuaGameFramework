CalcDefine = StaticClass("CalcDefine")

CalcDefine.Type = Enum.New({
    Op = 1,
    Num = 2,
    Var = 3,
    Func = 4,
})

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

CalcDefine.FuncType = {
    Add = 1,
    Sub = 2,
    Mul = 3,
    Div = 4,

    --自定义函数类型
    IF = 5,
}

CalcDefine.Op2Func = {
    [CalcDefine.OpType.Add] = CalcDefine.FuncType.Add,
    [CalcDefine.OpType.Sub] = CalcDefine.FuncType.Sub,
    [CalcDefine.OpType.Mul] = CalcDefine.FuncType.Mul,
    [CalcDefine.OpType.Div] = CalcDefine.FuncType.Div,
}

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
            if a == 1 then
                return b
            end
            return c
        end,
        argsNum = 3,
    },
}

return CalcDefine