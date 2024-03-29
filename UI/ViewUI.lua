--ViewUI即是一个界面的容器，本身可以没有任何渲染的内容
--ViewUI可以包含N个其他ViewUI，共存亡，共调用
--生命周期函数的调用顺序：容器 > 扩展视图1 > 扩展视图2 > ...
ViewUI = Class("ViewUI", UIBase)

function ViewUI:OnInit()
    self.belongView = nil
    self.extendViews = {}
    self.comUIs = {}
    self.sortingOrder = nil
end

function ViewUI:OnDelete()
    self:CallExtendViewsFunc("Delete")
    self.extendViews = nil
    self:CallComUIsFunc("Delete")
    self.comUIs = nil
end

---设置层级
function ViewUI:SetSortOrder(order)
    self.sortingOrder = order
    if self.canvas then
        self.canvas.sortingOrder = order
    end
    self:CallExtendViewsFunc("SetSortOrder", self.sortingOrder)
end

function ViewUI:_batchCreateComUI(comUIType, parent, amount, prefab, datas)
    local comUIs = {}
    for i = 1, amount do
        local data = datas and datas[i]
        local com = self:CreateComUI(comUIType, prefab)
        com:SetParent(parent)
        com:SetData(data, i, self)
        table.insert(comUIs, com)
    end
    return comUIs
end

---批量创建ComUI
function ViewUI:BatchCreateComUI(comUIType, parent, datas, prefab)
    return self:_batchCreateComUI(comUIType, parent, #datas, prefab, datas)
end

function ViewUI:BatchCreateComUIByAmount(comUIType, parent, amount, prefab)
    return self:_batchCreateComUI(comUIType, parent, amount, prefab, nil)
end

---SetAsset传入的path如何处理！！！！
---创建ComUI，注意这里是同步加载，传入的是prefab而不是path
function ViewUI:CreateComUI(comUIType, prefab, enterData)
    local config = UIDefine.ComUI[comUIType]
    if not config then
        PrintError("组件配置不存在", comUIType)
        return
    end
    local cls = _G[config.Class]
    if not cls then
        PrintError("组件类不存在", config.Class)
        return
    end
    local comUI = cls.New(comUIType)
    self:AddComUI(comUI)
    UIUtil.CreateUIByPool(comUI.uiType, prefab, comUI, enterData)
    return comUI
end

function ViewUI:AddComUI(comUI)
    if not table.Contain(self.comUIs, comUI) then
        table.insert(self.comUIs, comUI)
    end
end

function ViewUI:RecycleAllComUI()
    for _, comUI in ipairs(self.comUIs) do
        comUI:RecycleOrDelete()
    end
end

function ViewUI:SetBelongView(view)
    self.belongView = view
end

--添加界面扩展类
function ViewUI:AddExtendView(viewCls)
    if viewCls._className == self._className then
        PrintError(self, "不可以添加自己为自己的界面扩展类")
        return
    end
    if self.belongView ~= nil then
        PrintError(self, "是界面扩展类，不应该再包含其他扩展类，否则容易导致界面相互依赖")
        return
    end
    if not self.extendViews[viewCls._className] then
        local view = viewCls.New(self.uiType)
        view:SetBelongView(self)
        self.extendViews[viewCls._className] = view
    end
    return self.extendViews[viewCls._className]
end

function ViewUI:CallExtendViewsFunc(fnName, ...)
    for name, view in pairs(self.extendViews or NIL_TABLE) do
        view[fnName](view, ...)
    end
end

function ViewUI:CallComUIsFunc(fnName, ...)
    for _, com in ipairs(self.comUIs or NIL_TABLE) do
        com[fnName](com, ...)
    end
end

---退出界面(子类调用，方便调用)
function ViewUI:Exit()
    if self.viewCtrl then
        self.viewCtrl:ExitView(self)
    else
        PrintWarning("建议使用ViewCtrl管理该界面逻辑:", self)
        UIManager.Instance:Exit(self)
    end
end

---退出界面(只能被外界调用，子类不要调用)
function ViewUI:HandleExit()
    self:CallFuncDeeply("OnExit", false)
end

--退出界面完成，界面退出可能是一个耗时的操作（受到离场动画的影响）
function ViewUI:ExitComplete()
    self:CallFuncDeeply("OnExitComplete", false)
end

function ViewUI:OnFindComponent()
    self.canvas = self.gameObject:GetComponent(typeof(UnityEngine.Canvas))
    self.canvas.overrideSorting = true
    self:SetSortOrder(self.sortingOrder)
end

function ViewUI:OnSetupViewAsset(gameObject)
    self:CallExtendViewsFunc("SetupViewAssetFromView", self)
end

function ViewUI:OnEnter(data)
    self:CallExtendViewsFunc("Enter", data)
end

function ViewUI:OnEnterComplete()
    if self.viewCtrl then
        self.viewCtrl:EnterViewComplete(self)
    end
    self:CallExtendViewsFunc("EnterComplete")
end

function ViewUI:OnExit()
    self:RecycleAllComUI()
    self:CallExtendViewsFunc("HandleExit")
end

function ViewUI:OnExitComplete()
    self:CallExtendViewsFunc("ExitComplete")
end

function ViewUI:OnRefresh()
    self:CallComUIsFunc("Refresh")
    self:CallExtendViewsFunc("Refresh")
end

function ViewUI:OnHide()
    self:CallComUIsFunc("Hide")
    self:CallExtendViewsFunc("Hide")
end

function ViewUI:OnAssetLoaded(assets)
    self:CallExtendViewsFunc("AssetLoaded", assets)
end

return ViewUI
