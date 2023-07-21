AssetLoader = Class("AssetLoader")

function AssetLoader:OnInit()
    self.waitLoads = {} --等待加载队列
    self.toLoads = {}   --加载队列
    self.waitCalls = {}
    self.waitFinalCalls = {}
    self.results = {}
    self.csLoader = CS.GameAssetLoader.Instance
end

function AssetLoader:OnDelete()
end

function AssetLoader:getAssetKey(assetType, path)
    return assetType .. path
end

--Asset要避免重复请求加载，在结果返回之前，若Asset已经标记为加载中
--则后续的加载回调都先缓存起来，加载结束后统一回调
function AssetLoader:AddAsset(assetType, path, callObject)
    local key = self:getAssetKey(assetType, path)
    if not self.waitLoads[key] and not self.toLoads[key] then
        self.waitLoads[key] = {
            assetType = assetType,
            path = path,
        }
        print("AssetLoader:AddAsset",assetType,path)
    end
    table.insert(self.waitCalls, callObject)
end

---执行批量加载
---@param fn function func(map[path]object) 结束回调
---@param caller any
function AssetLoader:LoadAsset(fn, caller)
    self:LoadAssetByCallObject(CallObject.New(fn, caller))
end

function AssetLoader:LoadAssetByCallObject(callObject)
    if table.IsValid(self.waitLoads) then
        for key, data in pairs(self.waitLoads) do
            self.toLoads[key] = data
        end
        self.waitLoads = {}
        for _, data in pairs(self.toLoads) do --非保序加载
            print("AssetLoader:StartLoad",data.assetType,data.path)
            if data.assetType == AssetDefine.Type.Prefab then
                self.csLoader:LoadGameObjectAsync(data.path, function(obj)
                    self:OnLoadAsset(data, obj)
                end)
            elseif data.assetType == AssetDefine.Type.Sprite then
                error("接口未实现")
            elseif data.assetType == AssetDefine.Type.Text then
                self.csLoader:LoadTextAsync(data.path, function(obj)
                    self:OnLoadAsset(data, obj)
                end)
            end
        end
    end
    table.insert(self.waitFinalCalls, callObject)
end

function AssetLoader:OnLoadAsset(data, obj)
    local key = self:getAssetKey(data.assetType, data.path)
    if not self.toLoads[key] then
        PrintError("资源加载异常(未经过加载接口自行返回)", data, obj)
        return
    end
    print("AssetLoader:EndLoad",data.assetType,data.path)
    self.toLoads[key] = nil
    for _, call in ipairs(self.waitCalls) do
        call:Invoke(obj, data.path)
    end
    self.waitCalls = {}
    self.results[data.path] = obj
    if not table.IsValid(self.toLoads) and not table.IsValid(self.waitLoads) then
        self:LoadDone()
    end
end

function AssetLoader:LoadDone()
    self.toLoads = {}
    for _, call in ipairs(self.waitFinalCalls) do
        call:Invoke(self.results)
    end
    self.waitFinalCalls = {}
end

return AssetLoader
