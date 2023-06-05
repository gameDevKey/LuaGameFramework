--[[
    UI界面基类
    1.可选择性实现'#region 虚函数'
    2.界面加载完成后，可直接访问self.gameObject/self.transform等等变量，具体看ViewAssetLoaded()逻辑
]]--
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
function UIBase:AddAsset(path,callObject)
    self.assetLoader:AddAsset(path,callObject)
end

--设置界面资源路径
function UIBase:SetViewAsset(path)
    self:AddAsset(path, CallObject.New(self:ToFunc("ViewAssetLoaded",nil)))
end

--界面加载完成，做一些初始化工作
function UIBase:ViewAssetLoaded(asset)
    self.gameObject = asset
    self.transform = self.gameObject.transform
end

---请求加载所有资源
function UIBase:LoadAsset(callObject)
    self.assetLoadCallback = callObject
    self.assetLoader:LoadAsset(self:ToFunc("AssetLoaded"))
end

---所有资源加载完成
function UIBase:AssetLoaded(assets)
    self:CallFuncDeeply("OnAssetLoaded",false,assets)
    if self.assetLoadCallback then
        self.assetLoadCallback:Invoke(assets)
        self.assetLoadCallback:Delete()
        self.assetLoadCallback = nil
    end
end


---进入界面(只能被外界调用，子类不要调用)
function UIBase:Enter(data)
    self:CallFuncDeeply("OnEnter",false,data)
end

---进入界面完成，界面进入可能是一个耗时的操作（受到加载或者入场动画的影响）
function UIBase:EnterComplete()
    self:CallFuncDeeply("OnEnterComplete",false)
end

---退出界面(子类调用，方便调用)
function UIBase:Exit()
    UIManager.Instance:Exit(self)
end

---退出界面(只能被外界调用，子类不要调用)
function UIBase:HandleExit()
    self:CallFuncDeeply("OnExit",false)
end

--退出界面完成，界面退出可能是一个耗时的操作（受到离场动画的影响）
function UIBase:ExitComplete()
    self:CallFuncDeeply("OnExitComplete",false)
end

---上级界面退出后，当前界面重新显示出来
function UIBase:Refresh()
    self:CallFuncDeeply("OnRefresh",false)
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
