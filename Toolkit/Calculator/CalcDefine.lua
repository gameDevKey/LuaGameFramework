CalcDefine = StaticClass("CalcDefine")

CalcDefine.Type = Enum.New({
    Op = 1,
    Num = 2,
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

CalcDefine.OpFunc = {
    [CalcDefine.OpType.Add] = function (a,b)
        return a+b
    end,
    [CalcDefine.OpType.Sub] = function (a,b)
        return a-b
    end,
    [CalcDefine.OpType.Mul] = function (a,b)
        return a*b
    end,
    [CalcDefine.OpType.Div] = function (a,b)
        return a/b
    end,
}

return CalcDefine