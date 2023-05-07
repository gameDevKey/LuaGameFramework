--#region 必要文件提前加载
LFS = require("lfs")
require("Utils.FileUtil")
require("Utils.String")
require("Utils.Common")
require("Utils.Table")
require("Utils.Time")
require("Core.Config")
--#endregion


--#region 获得所有Lua文件路径
LuaFiles = {}
local currentDir = LFS.currentdir()
local luaFiles = {}
FindAllFile(currentDir, ".lua", luaFiles)
for _, path in ipairs(luaFiles) do
    local realPath = string.gsub(path, currentDir, "")
    realPath = string.gsub(realPath, ".lua", "")
    local paths = string.split(realPath, '\\')
    local key = paths[#paths]
    if LuaFiles[key] then
        PrintError("Lua文件重名", path)
    end
    LuaFiles[key] = table.concat(paths, ".")
end
--#endregion


--#region 懒加载Lua类,访问文件名时自动require
local parentG = {}
setmetatable(_G, parentG)
parentG.__index = function(tb, key)
    local luaPath = LuaFiles[key]
    if luaPath then
        if not package.loaded[luaPath] then
            require(luaPath)
        end
        return package.loaded[luaPath]
    end
end
--#endregion
