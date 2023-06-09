function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function string.contains(str, sub)
    return str:find(sub, 1, true) ~= nil
end

function string.startswith(str, start)
    return str:sub(1, #start) == start
end

function string.endswith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

function string.valid(str)
    return IsString(str) and string.len(str) > 0
end

function string.trim(str)
    return string.gsub(str,"%s+","")
end