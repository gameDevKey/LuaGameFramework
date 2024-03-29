--#region 必要文件提前加载
require("Core.Config")
if not PURE_LUA_TEST_ENV then
    require("Core.ClsRef")
end
require("Utils.Common")
require("Utils.Class")
require("Utils.String")
require("Utils.Table")
require("Utils.Time")
if PURE_LUA_TEST_ENV then
    require("Utils.LuaFileUtil")
else
    require("CSUtils.CsFileUtil")
end
--#endregion


--#region 获得所有Lua文件路径
LuaFiles = {}
local MODULE, FACADE, CTRL, PROXY = "Module", "Facade", "Ctrl", "Proxy"
local facadeFiles = {}
local facadeModules = {}
local currentDir
local luaFiles
local startIndex, endIndex
if PURE_LUA_TEST_ENV then
    currentDir = LFS.currentdir()
    luaFiles = {}
    LuaFileUtil.FindAllFile(currentDir, ".lua", luaFiles)
    startIndex, endIndex = 1, #luaFiles
else
    currentDir = CsFileUtil.GetCurrentDir() .. '/Scripts/Lua'
    luaFiles = CsFileUtil.GetAllFilePath(currentDir, "*.lua")
    startIndex, endIndex = 0, luaFiles.Length - 1
end
local function IsValidFile(key, dir, lastDir, lastDir2)
    if string.endswith(key, "meta") then
        return false
    end
    if TEST_ENV then
        return true
    end
    if dir == "Debug" then
        return false
    end
    if dir == "Template" or lastDir == "Template" then
        return false
    end
    return true
end
for i = startIndex, endIndex, 1 do
    local path = luaFiles[i]
    local realPath = string.gsub(path, currentDir, "")
    realPath = string.gsub(realPath, ".lua", "")
    local paths = string.split(realPath, '\\')
    local len = #paths
    local key = paths[len]        --当前文件名
    local dir = paths[len - 1]    --文件夹
    local lastDir = paths[len - 2] --上级文件夹
    local lastDir2 = paths[len - 3] --上两级文件夹
    if LuaFiles[key] then
        PrintError("Lua文件重名", path)
    else
        --文件过滤，带有Debug或者Template的文件不加载
        if IsValidFile(key, dir, lastDir, lastDir2) then
            LuaFiles[key] = table.concat(paths, ".")
            if lastDir == MODULE then
                if string.endswith(key, FACADE) then
                    facadeFiles[key] = dir
                end
            elseif lastDir2 and lastDir2 == MODULE then
                if not facadeModules[lastDir] then
                    facadeModules[lastDir] = {}
                    facadeModules[lastDir].ctrls = {}
                    facadeModules[lastDir].proxys = {}
                end
                if dir == CTRL and string.contains(key, CTRL) then
                    facadeModules[lastDir].ctrls[key] = true
                elseif dir == PROXY and string.contains(key, PROXY) then
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
