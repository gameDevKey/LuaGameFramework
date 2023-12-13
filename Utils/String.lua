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

function string.GetCharSize(ch)
    if not ch then return 0
    elseif ch >= 252 then return 6
    elseif ch >= 248 and ch < 252 then return 5
    elseif ch >= 240 and ch < 248 then return 4
    elseif ch >= 224 and ch < 240 then return 3
    elseif ch >= 192 and ch < 224 then return 2
    elseif ch < 192 then return 1
    end
end

-- 计算utf8字符串字符数, 各种字符都按一个字符计算
-- 例如GetUtf8Length("1你好") => 3
function string.GetUtf8Length(str)
    local len = 0
    local aNum = 0 --字母个数
    local hNum = 0 --汉字个数
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local cs = string.GetCharSize(char)
        currentIndex = currentIndex + cs
        len = len + 1
        if cs == 1 then
            aNum = aNum + 1
        elseif cs >= 2 then
            hNum = hNum + 1
        end
    end
    return len, aNum, hNum
end

-- 截取 utf8 字符串
-- str:             要截取的字符串
-- startIndex:      开始字符下标,从1开始
-- subLen:          要截取的字符长度(不填代表从startIndex截取到字符串尾)
function string.SubUtf8Str(str, startIndex, subLen)
    local len = #str
    subLen = subLen or len

    local index = 1
    while startIndex > 1 do
        local char = string.byte(str, index)
        index = index + string.GetCharSize(char)
        startIndex = startIndex - 1
    end

    local currentIndex = index
    while subLen > 0 and currentIndex <= len do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + string.GetCharSize(char)
        subLen = subLen - 1
    end
    return string.sub( str, index, currentIndex - 1)
end