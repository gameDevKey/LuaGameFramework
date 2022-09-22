HorizontalLoopScrollView = BaseClass("HorizontalLoopScrollView", LoopScrollViewBase)

function HorizontalLoopScrollView:__Init()
    self.type = LoopScrollViewDefine.Type.Horizontal
end

function HorizontalLoopScrollView:IsHorizontalDir()
    return true
end

function HorizontalLoopScrollView:ScrollToItem(index, duration, ease, cbFinish)
    index = MathUtils.Clamp(index, 1, #self.tbItemData)
    index = index - 1
    local x = self.setting.paddingLeft
    for i = 1, index do
        x = x + self.tbItemData[i].size.w + self.setting.gapX
    end
    self:ScrollToPosition(Vector2(-x,self.content.localPosition.y), duration, ease, cbFinish)
end

function HorizontalLoopScrollView:ScrollToPosition(pos, duration, ease, cbFinish)
    local x = pos.x
    local y = pos.y
    local maxW = self.viewport.rect.width - self.content.rect.width
    x = MathUtils.Clamp(x, maxW, 0)
    self:MoveTo(Vector3(x,y,0), duration, ease, cbFinish)
end

function HorizontalLoopScrollView:UpdateContentSize()
    local w = self.setting.paddingLeft
    local maxH = 0
    for i, data in ipairs(self.tbItemData or {}) do
        w  = w + data.size.w + self.setting.gapX
        if data.size.h > maxH then
            maxH = data.size.h
        end
    end
    w = w + self.setting.paddingRight
    local h = self.setting.paddingTop + self.setting.paddingBottom + maxH
    self:SetContentSize(w, h)
end

function HorizontalLoopScrollView:UpdateList()
    --content左滑x值减少
    --Item越往右x越大
    local startPos = -self.content.localPosition.x --content的左界

    if startPos < 0 then startPos = 0 end

    local bottom = self.content.rect.width - self.viewport.rect.width --content的右界
    if startPos > bottom then startPos = bottom end

    local targetIndex = 1                       --起始索引
    local targetX = self.setting.paddingLeft    --起始坐标
    for i, data in ipairs(self.tbItemData or {}) do
        targetIndex = i
        local x = targetX + data.size.w
        if x >= startPos then
            break
        end
        targetX = x + self.setting.gapX
    end

    local itemX = targetX
    local itemY = 0 --self.content.localPosition.y
    local limitWidth = self.viewport.rect.width

    --先把不显示的回收，再生成
    local tempShowItems = self.tbShowingItem
    local tempDatas = {}
    self.tbShowingItem = {}

    for i = targetIndex, #self.tbItemData, 1 do
        local renderData = self.tbItemData[i]
        local insData = tempShowItems[renderData]
        if insData and insData.index == i then
            self.tbShowingItem[renderData] = tempShowItems[renderData]
            tempShowItems[renderData] = nil
        end

        local newItem = {}
        newItem.pos = Vector3(itemX, itemY, 0)
        newItem.index = i
        tempDatas[renderData] = newItem

        itemX = itemX + (renderData.size.w + self.setting.gapX)

        if itemX-startPos >= limitWidth then
            break
        end
    end

    for _, insData in pairs(tempShowItems or {}) do
        self:TryRecycleItem(insData)
    end

    for renderData, data in pairs(tempDatas) do
        local rect
        local insData = self.tbShowingItem[renderData]
        if insData and insData.index == data.index then
            rect = insData.rectTransform
        else
            local item = self:TryRenderItem(data.index, renderData)
            rect = item.rectTransform
        end
        UnityUtils.SetAnchoredPosition(rect, data.pos.x, data.pos.y)
    end
end