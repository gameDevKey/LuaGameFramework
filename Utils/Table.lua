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

function table.Contain(tb, obj)
    for _, item in pairs(tb or {}) do
        if item == obj then
            return true
        end
    end
    return false
end

function table.ToString(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp = tmp .. table.ToString(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end
