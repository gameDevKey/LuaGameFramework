--ViewUI即是一个界面的容器，本身可以没有任何渲染的内容
--ViewUI可以包含N个其他ViewUI，共存亡，共调用
--生命周期函数的调用顺序：容器 > 扩展视图1 > 扩展视图2 > ...
ViewUI = Class("ViewUI", UIBase)

function ViewUI:OnInit()
    self.belongView = nil
    self.extendViews = {}
    self.comUIs = {}
end

function ViewUI:OnDelete()
    self:CallExtendViewsFunc("Delete")
    self.extendViews = nil
    self:CallComUIsFunc("Delete")
    self.comUIs = nil
end

function ViewUI:AddComUI(comUI)
    if not table.Contain(self.comUIs, comUI) then
        table.insert(self.comUIs, comUI)
    end
end

function ViewUI:SetBelongView(view)
    self.belongView = view
end

--添加界面扩展类
function ViewUI:AddExtendView(viewCls)
    if viewCls._className == self._className then
        PrintError(self,"不可以添加自己为自己的界面扩展类")
        return
    end
    if self.belongView ~= nil then
        PrintError(self,"是界面扩展类，不应该再包含其他扩展类，否则容易导致界面相互依赖")
        return
    end
    if not self.extendViews[viewCls._className] then
        local view = viewCls.New(self.uiType)
        view:SetBelongView(self)
        self.extendViews[viewCls._className] = view
    end
end

function ViewUI:CallExtendViewsFunc(fnName,...)
    for name, view in pairs(self.extendViews or NIL_TABLE) do
        view[fnName](view,...)
    end
end

function ViewUI:CallComUIsFunc(fnName,...)
    for _, com in ipairs(self.comUIs or NIL_TABLE) do
        com[fnName](com,...)
    end
end

function ViewUI:OnEnter(data)
    self:CallExtendViewsFunc("Enter",data)
end
function ViewUI:OnEnterComplete()
    self:CallExtendViewsFunc("EnterComplete")
end
function ViewUI:OnExit()
    self:CallComUIsFunc("Delete")
    self.comUIs = {}
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
    self:CallExtendViewsFunc("AssetLoaded",assets)
end

return ViewUI
