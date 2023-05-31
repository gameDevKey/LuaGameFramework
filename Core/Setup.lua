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
local facadeFiles = {}
local facadeModules = {}
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
    local lastDir = paths[len-2]
    if LuaFiles[key] then
        PrintError("Lua文件重名", path)
    else
        if dir ~= "Debug" or TEST_ENV then
            LuaFiles[key] = table.concat(paths, ".")
            if dir and dir ~= "Module" and string.endswith(dir, "Module") then
                if string.endswith(key, "Facade") then
                    facadeFiles[key] = dir
                end
            elseif lastDir and string.endswith(lastDir, "Module") then
                if not facadeModules[lastDir] then
                    facadeModules[lastDir] = {}
                    facadeModules[lastDir].ctrls = {}
                    facadeModules[lastDir].proxys = {}
                end
                if dir == "Ctrl" and string.contains(key,"Ctrl") then
                    facadeModules[lastDir].ctrls[key] = true
                elseif dir == "Proxy" and string.contains(key,"Proxy") then
                    facadeModules[lastDir].proxys[key] = true
                end
            end
        end
    end
end
--安装模块（一次性，因为Facade没有卸载的必要性）
function SetupFacadeModules()
    if not facadeFiles or not facadeModules then
        return
    end
    local facades = {}
    for facade, dir in pairs(facadeFiles) do
        local ins = _G[facade].Instance
        facades[ins] = true
        local modules = facadeModules[dir]
        for ctrl, _ in pairs(modules.ctrls) do
            ins:BindCtrl(_G[ctrl].Instance)
        end
        for proxy, _ in pairs(modules.proxys) do
            ins:BindProxy(_G[proxy].Instance)
        end
    end
    for facade, _ in pairs(facades) do
        facade:InitComplete()
    end
    facadeFiles = nil
    facadeModules = nil
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