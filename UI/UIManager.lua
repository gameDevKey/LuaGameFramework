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
    self.uiStack = {}       --普通界面堆栈 List<ViewUI>
    self.uiHoldList = {}    --常驻界面队列
    self.uiSortOrder = {}   --层级 map[viewLayer]sortOrder
    self.uiRoot = UnityUtil.FindGameObject(UIDefine.UIRootName)
    self.cacheNode = UnityUtil.FindGameObject(UIDefine.UICacheName)
    self.cacheNode:SetActive(false)
end

function UIManager:OnDelete()
    for _, view in ipairs(self.uiStack or NIL_TABLE) do
        view:Delete()
    end
    self.uiStack = nil
    for _, view in ipairs(self.uiHoldList or NIL_TABLE) do
        view:Delete()
    end
    self.uiHoldList = nil
    self.uiSortOrder = nil
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

    if config.EnterType == UIDefine.EnterType.ExitLast then
        self:ActiveTopView(false)
    else
        --TODO more..
    end

    local view = clazz.New(uiType)
    self:addView(view)

    view:SetSortOrder(self:GetSortOrder(view.uiType))

    local pool = CacheManager.Instance:GetPool(CacheDefine.PoolType.UI,true)
    local cacheUI = pool:Get(uiType, {path = view.viewAssetPath, callback = self:ToFunc("onViewEnter"), args = {view=view,data=data}})
    view:SetCacheHandler(cacheUI)

    return view
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

    local config = UIDefine.Config[targetView.uiType]
    local isTopView = targetView == self.uiStack[#self.uiStack]

    --移除UIMgr缓存
    self:removeView(targetView)

    --回收到UI池，移动到隐藏节点
    local pool = CacheManager.Instance:GetPool(CacheDefine.PoolType.UI,true)
    pool:Recycle(targetView.uiType,targetView:GetCacheHandler())

    --数据清理
    targetView:HandleExit()

    if config.ViewLayer == UIDefine.ViewLayer.NormalUI then
        --一般情况下，只有顶部界面会触发关闭界面，假设非顶部界面也想关闭，那就不用ActiveTopView(true)
        if isTopView then
            self:ActiveTopView(true)
        end
    end
end

--栈顶界面出栈
function UIManager:ExitTop()
    local topView = self.uiStack[#self.uiStack]
    if topView then
        self:Exit(topView)
    end
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
            self:removeViewByIndex(curView,i)
            curView:HandleExit()
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

function UIManager:GetSortOrder(uiType)
    return self:AddSortOrder(uiType,0)
end

function UIManager:AddSortOrder(uiType,offset)
    local config = UIDefine.Config[uiType]
    local layer = config.ViewLayer
    if not self.uiSortOrder[layer] then
        self.uiSortOrder[layer] = layer
    end
    if offset ~= 0 then
        self.uiSortOrder[layer] = self.uiSortOrder[layer] + offset
    end
    return self.uiSortOrder[layer]
end

function UIManager:Log()
    local stack = {}
    for _, view in ipairs(self.uiStack) do
        table.insert(stack, string.format("%s 层级:%d",tostring(view),view.sortingOrder))
    end
    PrintLog("\n--------- 当前堆栈 ---------\n",table.concat(stack,'\n'),'\n------------------')
end

--#region 私有函数

function UIManager:addView(view)
    local list = self:getCacheList(view)
    table.insert(list,view)
    self:AddSortOrder(view.uiType,1)
end

function UIManager:removeView(view)
    local list = self:getCacheList(view)
    local _,index = table.Contain(list,view)
    self:removeViewByIndex(view,index)
end

function UIManager:removeViewByIndex(view,index)
    local list = self:getCacheList(view)
    if index then
        table.remove(list, index)
        self:AddSortOrder(view.uiType,-1)
    end
end

function UIManager:getCacheList(view)
    local config = UIDefine.Config[view.uiType]
    if config.ViewLayer == UIDefine.ViewLayer.HoldUI then
        return self.uiHoldList
    end
    return self.uiStack
end

--TODO 复用的界面还需要跑findTargets()?
function UIManager:onViewEnter(args,gameObject)
    local view = args.view
    local data = args.data
    view:SetupViewAsset(gameObject)
    view:Enter(data)
end

--#endregion

return UIManager
