local Enum = {}
Enum._autoIndex = 0

local extraMeta = {}
setmetatable(Enum, extraMeta)
extraMeta.__index = function(tb, key)
    if key == "Index" then
        Enum._autoIndex = Enum._autoIndex + 1
        return Enum._autoIndex
    end
end

return Enum
