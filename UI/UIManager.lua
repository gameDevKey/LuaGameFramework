UIManager = SingletonClass("UIManager")

--需要解决几个问题
--每个界面显示N个模型，进入退出界面的模型管理
--进入某个界面时会由于上个界面的不同而播放不同的音乐
--界面的复用问题
--item界面的定义，是属于界面？还是属于特殊模块？
--界面的层级问题

--把界面进入或者退出的原因通知到界面本身(上下文)
--常驻界面如何处理？

function UIManager:OnInit()
    self.uiStack = {}
    self.sortOrder = 0
end

function UIManager:OnDelete()
    for _, view in ipairs(self.uiStack) do
        view:Delete()
    end
    self.uiStack = {}
end

function UIManager:Enter(uiType, data)
    local config = UIDefine.Config[uiType]
    if not config.IsMulti and self:GetViewByType(uiType) ~= nil then
        PrintWarning("界面已存在:", config.Class)
        return
    end

    local clazz = _G[config.Class]
    if not clazz then  
        PrintError("界面类不存在:", config.Class)
        return
    end

    self:ActiveTopView(false)

    local view = clazz.New(uiType)
    self:addView(view)

    view:LoadAsset()
    view:Enter(data)
    view:SetSortOrder(self.sortOrder)
end

--退出某个界面
function UIManager:Exit(targetView)
    if not targetView then
        PrintError("界面为空，无法退出")
        return
    end

    local _,index = self:GetViewByInstance(targetView)
    if not index then
        PrintError("界面不存在堆栈中",targetView)
        return
    end

    self:removeView(index)

    targetView:Exit()
    self:ActiveTopView(true)
end

--返回到某个界面(这个界面之后的所有界面都会退出)
function UIManager:GoBackTo(uiType)
    local view = self:GetViewByType(uiType)
    if not view then
        PrintError("堆栈中无类型为",UIDefine.ViewType[uiType],'的界面')
        return
    end
    for i = #self.uiStack, 1, -1 do
        local curView = self.uiStack[i]
        if curView.uiType ~= uiType then
            self:removeView(i)
            curView:Exit()
        end
    end
    self:ActiveTopView(true)
end

function UIManager:ActiveTopView(active)
    local topView = self.uiStack[#self.uiStack]
    if topView then
        if active then
            topView:Refresh()
        else
            topView:Hide()
        end
    end
end

function UIManager:GetViewByType(uiType)
    --同一类型的界面不止一个，只能遍历
    for i, view in ipairs(self.uiStack) do
        if view.uiType == uiType then
            return view, i
        end
    end
end

function UIManager:GetViewByInstance(targetView)
    --同一类型的界面不止一个，只能遍历
    for i, view in ipairs(self.uiStack) do
        if view == targetView then
            return view, i
        end
    end
end

--#region 私有函数

function UIManager:addView(view)
    table.insert(self.uiStack, view)
    self.sortOrder = self.sortOrder + 1
end

function UIManager:removeView(index)
    table.remove(self.uiStack,index)
    self.sortOrder = self.sortOrder - 1
end

--#endregion

return UIManager
