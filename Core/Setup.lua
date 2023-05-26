--#region 必要文件提前加载
LFS = require("lfs")
require("Core.Config")
require("Utils.Class")
require("Utils.FileUtil")
require("Utils.String")
require("Utils.Common")
require("Utils.Table")
require("Utils.Time")
--#endregion


--#region 获得所有Lua文件路径
LuaFiles = {}
FacadeFiles = {}
local currentDir = LFS.currentdir()
local luaFiles = {}
FindAllFile(currentDir, ".lua", luaFiles)
for _, path in ipairs(luaFiles) do
    local realPath = string.gsub(path, currentDir, "")
    realPath = string.gsub(realPath, ".lua", "")
    local paths = string.split(realPath, '\\')
    local len = #paths
    local key = paths[len]
    local dir = paths[len-1]
    if LuaFiles[key] then
        PrintError("Lua文件重名", path)
    else
        if dir ~= "Debug" or TEST_ENV then
            LuaFiles[key] = table.concat(paths, ".")
            if string.endswith(key, "Facade") then
                FacadeFiles[key] = LuaFiles[key]
            end
        end
    end
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


--卸载所有系统(慎用!)
function Uninstall()
    GameManager.Instance:Delete()
    TestFacade.Instance:Delete()
    CommandManager.Global:Delete()
    EventDispatcher.Global:Delete()
end