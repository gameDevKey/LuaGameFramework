--[[
    无限滚动列表

    用法：
    1.New一个继承LoopScrollViewBase的类的实例，传入ScrollRect和Setting
    2.使用SetDatas/SetDataCount等数据接口设置数据
    3.调用Start接口启动
    4.使用Destroy接口释放
]]--
LoopScrollViewBase = BaseClass("LoopScrollViewBase")

local HorizontalAlignConfig = {
    [LoopScrollViewDefine.AlignType.Top] = {
        anchors = {minX = 0,minY = 0,maxX = 0,maxY = 1},
        pivot = {x = 0, y = 1},
    },
    [LoopScrollViewDefine.AlignType.Center] = {
        anchors = {minX = 0,minY = 0,maxX = 0,maxY = 1},
        pivot = {x = 0, y = 0.5},
    },
    [LoopScrollViewDefine.AlignType.Bottom] = {
        anchors = {minX = 0,minY = 0,maxX = 0,maxY = 1},
        pivot = {x = 0, y = 0},
    }
}

local VerticalAlignConfig = {
    [LoopScrollViewDefine.AlignType.Top] = {
        anchors = {minX = 0,minY = 1,maxX = 1,maxY = 1},
        pivot = {x = 0, y = 1},
    },
    [LoopScrollViewDefine.AlignType.Center] = {
        anchors = {minX = 0,minY = 1,maxX = 1,maxY = 1},
        pivot = {x = 0.5, y = 1},
    },
    [LoopScrollViewDefine.AlignType.Bottom] = {
        anchors = {minX = 0,minY = 1,maxX = 1,maxY = 1},
        pivot = {x = 1, y = 1},
    }
}

function LoopScrollViewBase:__Init(scrollRect, setting)
    self.tbItemData = {}    --List<{data:any, size:{w,h}}>  存储渲染数据
    self.tbShowingItem = {} --Dict<{data:any, size:{w,h}}, {data,index,obj,width,height}> 映射渲染数据和实体
    self.showingPool = {}   --List<{item:BaseView, holderRect:RectTransform}> BaseView的使用池
    self.recyclePool = {}   --List<{item:BaseView, holderRect:RectTransform}> BaseView的回收池
    self.type = LoopScrollViewDefine.Type.Unknown
    self:Init(scrollRect, setting)
end

function LoopScrollViewBase:__Delete()
    for _, data in ipairs(self.showingPool or {}) do
        data.item:Destroy()
        local holder = data.holderRect.gameObject
        if not BaseUtils.IsNull(holder) then
            GameObject.Destroy(holder)
        end
    end
    for _, data in ipairs(self.recyclePool or {}) do
        data.item:Destroy()
        local holder = data.holderRect.gameObject
        if not BaseUtils.IsNull(holder) then
            GameObject.Destroy(holder)
        end
    end
    self.tbItemData = nil
    self.tbShowingItem = nil
    self.showingPool = nil
    self.recyclePool = nil
end

local function GetSetting(setting)
    setting = setting or {}
    setting.paddingLeft = setting.paddingLeft or 0
    setting.paddingRight = setting.paddingRight or 0
    setting.paddingTop = setting.paddingTop or 0
    setting.paddingBottom = setting.paddingBottom or 0
    setting.gapX = setting.gapX or 0
    setting.gapY = setting.gapY or 0
    setting.maxRowNum = setting.maxRowNum or 0
    setting.maxColNum = setting.maxColNum or 0
    setting.itemWidth = setting.itemWidth or 0
    setting.itemHeight = setting.itemHeight or 0
    setting.alignType = setting.alignType or LoopScrollViewDefine.AlignType.Top
    return setting
end

---初始化
---Setting:
---     paddingLeft   左边距
---     paddingRight  右边距
---     paddingTop    上边距
---     paddingBottom 下边距
---     gapX          水平间隔
---     gapY          垂直间隔
---     itemWidth     Item的默认宽度
---     itemHeight    Item的默认高度
---     alignType     对齐模式(LoopScrollViewDefine.AlignType)
---     maxColNum     最大列数(GridLoopScrollView中生效)
---     maxRowNum     最大行数(GridLoopScrollView中生效)
---     onCreate      Item的创建回调,Item继承BaseView
---     onRender      Item的业务处理回调
---@param scrollRect ScrollRect 滚动组件
---@param setting table 配置
function LoopScrollViewBase:Init(scrollRect, setting)
    self.scrollRect = scrollRect
    self.setting = GetSetting(setting)

    self.viewport = self.scrollRect.viewport
    self.content = self.scrollRect.content
    self.scrollRect.onValueChanged:RemoveAllListeners()
    self.scrollRect.onValueChanged:AddListener(self:ToFunc("OnScroll"))

    if self.setting.onCreate then
        self:AddOnItemCreateCallback(self.setting.onCreate)
    end
    if self.setting.onRender then
        self:AddOnItemRenderCallback(self.setting.onRender)
    end

    self.lastScrollVec = self.content.localPosition
end

---启动
function LoopScrollViewBase:Start()
    self:AdjuestContentAnchorAndPivot()
    self:OnDataChange()
end

---销毁
function LoopScrollViewBase:Destroy()
    self:Delete()
end

---创建回调
---@param callback function func(index, [data]) -- 返回一个继承自 BaseView 的对象
function LoopScrollViewBase:AddOnItemCreateCallback(callback)
    self.cbOnCreateItem = callback
end

---渲染回调
---@param callback function func(item, index, [data])
function LoopScrollViewBase:AddOnItemRenderCallback(callback)
    self.cbOnRenderItem = callback
end

function LoopScrollViewBase:CreateItemRoot()
    local item = GameObject("ItemHolder")
    local rect = item:AddComponent(RectTransform)
    item.transform:SetParent(self.content)
    item.transform.localScale = Vector3.one
    UnityUtils.SetAnchorMinAndMax(item.transform,0,1,0,1)
    UnityUtils.SetPivot(item.transform,0,1)
    return rect
end

function LoopScrollViewBase:CreateItem(index, data)
    local item
    local holderRect
    if #self.recyclePool > 0 then
        local cache = table.remove(self.recyclePool)
        item = cache.item
        holderRect = cache.holderRect
    elseif self.cbOnCreateItem then
        holderRect = self:CreateItemRoot()
        item = self.cbOnCreateItem(index, data)
        local scale = item.gameObject.transform.localScale
        item.rectTransform:SetParent(holderRect)
        item.gameObject.transform.localScale = scale
        UnityUtils.SetAnchoredPosition(item.gameObject.transform,0,0)
    end
    if not item then
        LogError("获取Item失败! Index:",index,
            "是否存在创建回调",(self.cbOnCreateItem ~= nil),
            "使用池缓存",#self.showingPool,
            "回收池缓存",#self.recyclePool)
        return
    end
    holderRect.gameObject:SetActive(true)
    table.insert(self.showingPool, {item = item, holderRect = holderRect})
    -- print("LoopScrollViewBase 创建对象",index,self,"激活池",#self.showingPool,"回收池",#self.recyclePool)
    return item,holderRect
end

function LoopScrollViewBase:OnRenderItem(item, index, data)
    if self.cbOnRenderItem then
        self.cbOnRenderItem(item, index, data)
    end
end

function LoopScrollViewBase:OnScroll(vec)
    local cur = self.content.localPosition
    local dis = Vector3.Distance(cur, self.lastScrollVec)
    if dis > 5 then --降低灵敏度
        self.lastScrollVec = cur
        self:UpdateList()
    end
end

function LoopScrollViewBase:OnDataChange()
    self:UpdateContentSize()
    self:UpdateList()
end

function LoopScrollViewBase:TryRenderItem(index, renderData)
    local item = {}
    local obj,holderRect = self:CreateItem(index, renderData)
    assert(obj,"创建Item失败")
    assert(holderRect,"获取挂载点Rect失败")
    item.obj = obj
    item.rectTransform = holderRect
    item.index = index
    item.data = renderData.data
    item.width = renderData.size.w
    item.height = renderData.size.h
    self.tbShowingItem[renderData] = item
    self:OnRenderItem(obj, index, renderData)
    return item
end

function LoopScrollViewBase:TryRecycleItem(insData)
    local index = insData.index
    local _item = insData.obj
    local rect = insData.rectTransform
    for _, data in ipairs(self.recyclePool or {}) do
        if data.item == _item then
            LogError("对象被重复回收! Index:",index)
            return false
        end
    end
    for i = #self.showingPool, 1, -1 do
        local data = self.showingPool[i]
        if data.item == _item then
            table.remove(self.showingPool, i)
        end
    end
    rect.gameObject:SetActive(false)
    table.insert(self.recyclePool, {item = _item, holderRect = rect})
    -- print("LoopScrollViewBase 回收对象",index,self,"激活池",#self.showingPool,"回收池",#self.recyclePool)
    return true
end

function LoopScrollViewBase:ScrollToBottom(cbFinish)
    local len = #self.tbItemData
    if len <= 0 then
        return
    end
    self:ScrollToItem(len - 1, cbFinish)
end

function LoopScrollViewBase:MoveTo(vec3, duration, ease, cbFinish)
    local tween = self.content:DOLocalMove(vec3,duration)
    if ease then
        tween = tween:SetEase(ease)
    end
    if cbFinish then
        tween = tween:OnComplete(cbFinish)
    end
    return tween
end

function LoopScrollViewBase:SetContentSize(w,h)
    self.content:SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, w)
    self.content:SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, h)
end

function LoopScrollViewBase:AdjuestContentAnchorAndPivot()
    local config = self:IsHorizontalDir() and HorizontalAlignConfig or VerticalAlignConfig
    local detail = config[self.setting.alignType]
    UnityUtils.SetAnchorMinAndMax(self.content,
        detail.anchors.minX,detail.anchors.minY,
        detail.anchors.maxX,detail.anchors.maxY)
    UnityUtils.SetPivot(self.content,detail.pivot.x, detail.pivot.y)
end

--#region 数据相关

function LoopScrollViewBase:GetDefaultItemData(sc)
    sc = sc or {}
    sc.size = sc.size or {w=(self.setting.itemWidth or 0),h=(self.setting.itemHeight or 0)}
    return sc
end

---设置数据数量
---@param count integer
function LoopScrollViewBase:SetDataCount(count, notifyChange)
    count = count or 0
    local list = {}
    for i = 1, count do
        table.insert(list, {})
    end
    self:SetDatas(list, notifyChange)
end

---添加数据数量
---@param count integer
function LoopScrollViewBase:AddDataCount(count, notifyChange)
    count = count or 0
    for i = 1, count do
        local notify = notifyChange
        if i < count then
            notify = false
        end
        self:AddData(nil, notify)
    end
end

---设置一组数据
---@param list table List<{data:any, size:{w,h}}>
function LoopScrollViewBase:SetDatas(list,notifyChange)
    list = list or {}
    for i, data in ipairs(list) do
        list[i] = self:GetDefaultItemData(data)
    end
    self.tbItemData = list
    if notifyChange then
        self:OnDataChange()
    end
end

---添加数据
---@param sc table|nil {data:any, size:{w,h}}
function LoopScrollViewBase:AddData(sc, notifyChange)
    table.insert(self.tbItemData, self:GetDefaultItemData(sc))
    if notifyChange then
        self:OnDataChange()
    end
end

---移除数据
---@param index integer 下标
function LoopScrollViewBase:RemoveDataAt(index,notifyChange)
    table.remove(self.tbItemData, index)
    if notifyChange then
        self:OnDataChange()
    end
end

---清除所有数据
function LoopScrollViewBase:ClearAllData(notifyChange)
    self.tbItemData = {}
    if notifyChange then
        self:OnDataChange()
    end
end

--#endregion


--#region 虚方法

function LoopScrollViewBase:ScrollToItem(index, duration, ease, cbFinish) end
function LoopScrollViewBase:ScrollToPosition(pos, duration, ease, cbFinish) end
function LoopScrollViewBase:UpdateContentSize() end
function LoopScrollViewBase:UpdateList() end
function LoopScrollViewBase:IsHorizontalDir() return false end

--#endregion