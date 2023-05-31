UIBase = Class("UIBase", ModuleBase)

function UIBase:OnInit(uiType)
    self.uiType = uiType
    self.assetLoader = AssetLoader.New()
    self.sortingOrder = 0
end

function UIBase:OnDelete()
    self.assetLoader:Delete()
    if self.gameObject then
        GameObject.Destroy(self.gameObject)
        self.gameObject = nil
    end
end

---设置层级
function UIBase:SetSortOrder(order)
    self.sortingOrder = order
end

---添加需要加载的资源
function UIBase:AddAsset(path)
    self.assetLoader:AddAsset(path)
end

---请求加载资源
function UIBase:LoadAsset(callObject)
    self.assetLoadCallback = callObject
    self.assetLoader:LoadAsset(self:ToFunc("AssetLoaded"))
end

---资源加载完成
function UIBase:AssetLoaded(assets)
    self:SetAssets(assets)
    if self.assetLoadCallback then
        self.assetLoadCallback:Invoke(assets)
        self.assetLoadCallback:Delete()
        self.assetLoadCallback = nil
    end
    self:CallFuncDeeply("OnAssetLoaded",true,assets)
end

---设置加载后的资源
function UIBase:SetAssets(assets)
end

---进入界面(只能被外界调用，子类不要调用)
function UIBase:Enter(data)
    self:CallFuncDeeply("OnEnter",true,data)
end

---进入界面完成，界面进入可能是一个耗时的操作（受到加载或者入场动画的影响）
function UIBase:EnterComplete()
    self:CallFuncDeeply("OnEnterComplete",true)
end

---退出界面(只能被外界调用，子类不要调用)
function UIBase:Exit()
    self:CallFuncDeeply("OnExit",false)
end

--退出界面完成，界面退出可能是一个耗时的操作（受到离场动画的影响）
function UIBase:ExitComplete()
    self:CallFuncDeeply("OnExitComplete",false)
end

---上级界面退出后，当前界面重新显示出来
function UIBase:Refresh()
    self:CallFuncDeeply("OnRefresh",true)
end

---上级界面入场后，当前界面暂时隐藏
function UIBase:Hide()
    self:CallFuncDeeply("OnHide",false)
end

--#region 虚函数
function UIBase:OnEnter(data)end
function UIBase:OnEnterComplete()end
function UIBase:OnExit()end
function UIBase:OnExitComplete()end
function UIBase:OnRefresh()end
function UIBase:OnHide()end
function UIBase:OnAssetLoaded(assets)end
--#endregion

return UIBase
