--[[
    UI界面基类
    1.可选择性实现'#region 虚函数'
    2.界面加载完成后，可直接访问self.gameObject/self.transform等等变量，具体看ViewAssetLoaded()逻辑
]]--
UIBase = Class("UIBase", ModuleBase)
local _ = UIExtendBase

function UIBase:OnInit(uiType)
    self.uiType = uiType
    self.sortingOrder = 0
end

function UIBase:OnDelete()
    if self.gameObject then
        UnityUtil.DestroyGameObject(self.gameObject)
        self.gameObject = nil
    end
end

--关联一个UI缓存处理类
function UIBase:SetCacheHandler(handler)
    self.cacheHandler = handler
end

function UIBase:GetCacheHandler()
    return self.cacheHandler
end

---设置层级
function UIBase:SetSortOrder(order)
    self.sortingOrder = order
end

--设置界面资源路径
function UIBase:SetAssetPath(path)
    self.uiAssetPath = path
end

--界面资源初始化
function UIBase:SetupViewAsset(gameObject)
    self.gameObject = gameObject
    self.transform = self.gameObject.transform
    self.rectTransform = self.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    self:CallFuncDeeply("OnFindComponent",true)
    self:CallFuncDeeply("OnInitComponent",true)
end

---进入界面(只能被外界调用，子类不要调用)
function UIBase:Enter(data)
    self:CallFuncDeeply("OnEnter",false,data)
end

---进入界面完成，界面进入可能是一个耗时的操作（受到加载或者入场动画的影响）
function UIBase:EnterComplete()
    self:CallFuncDeeply("OnEnterComplete",false)
end

---上级界面退出后，当前界面重新显示出来
function UIBase:Refresh()
    self:CallFuncDeeply("OnRefresh",false)
end

---上级界面入场后，当前界面暂时隐藏
function UIBase:Hide()
    self:CallFuncDeeply("OnHide",false)
end

--#region 虚函数(生命周期)
function UIBase:OnEnter(data)end
function UIBase:OnEnterComplete()end
function UIBase:OnRefresh()end
function UIBase:OnHide()end
--#endregion

--#region 虚函数(行为)
function UIBase:OnFindComponent()end
function UIBase:OnInitComponent()end
--#endregion

return UIBase
