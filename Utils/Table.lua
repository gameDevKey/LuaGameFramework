function table.Count(tb)
    if not IsTable(tb) then
        PrintWarning("table.Count 只接受 table 类型的入参 : ", tb)
        return 0
    end
    local count = 0
    for _, v in pairs(tb) do
        count = count + 1
    end
    return count
end

function table.IsValid(tb)
    return table.Count(tb) > 0
end

function table.Contain(tb,obj)
    for _, item in pairs(tb or {}) do
        if item == obj then
            return true
        end
    end
    return false
end