local tb = {
    ["test1"] = 1,
    ["test2"] = 2,
    ["test3"] = 3,
}

-- local tb1 = table.ReadOnly(tb)
-- tb1.test1 = 100
-- tb1.test4 = 4

local tb2 = table.ReadUpdateOnly(tb)
tb2.test1 = 100
-- tb2.test4 = 4
PrintAny(tb2.test1)
PrintAny(tb2.test2)
