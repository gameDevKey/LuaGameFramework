--#region 必要文件提前加载
require("Core.Config")
require("Utils.Common")
require("Utils.Class")
require("Utils.String")
require("Utils.Table")
require("Utils.Time")
-- require("Utils.LuaFileUtil")
require("CSUtils.CsFileUtil")
--#endregion


--#region 获得所有Lua文件路径
LuaFiles = {}
local facadeFiles = {}
local facadeModules = {}
local currentDir = CsFileUtil.GetCurrentDir()..'/Scripts/Lua'
local luaFiles = CsFileUtil.GetAllFilePath(currentDir,"*.lua")
for i= 0, luaFiles.Length-1, 1 do
    local path = luaFiles[i]
    local realPath = string.gsub(path, currentDir, "")
    realPath = string.gsub(realPath, ".lua", "")
    local paths = string.split(realPath, '\\')
    local len = #paths
    local key = paths[len]
    local dir = paths[len-1]
    local lastDir = paths[len-2]
    local lastDir2 = paths[len-3]
    if LuaFiles[key] then
        PrintError("Lua文件重名", path)
    else
        if TEST_ENV or not string.contains(realPath,'Debug') then
            LuaFiles[key] = table.concat(paths, ".")
            if lastDir == "Module" then
                if string.endswith(key, "Facade") then
                    facadeFiles[key] = dir
                end
            elseif lastDir2 and lastDir2 == "Module" then
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