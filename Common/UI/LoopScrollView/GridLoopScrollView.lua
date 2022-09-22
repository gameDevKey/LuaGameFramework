GridLoopScrollView = BaseClass("GridLoopScrollView", LoopScrollViewBase)

local ConstraintType = {
    Flexible = 1,
    FixedColumnCount = 2,
    FixedRowCount = 3,
}

function GridLoopScrollView:__Init()
    self.type = LoopScrollViewDefine.Type.Grid
    self.constraint = ConstraintType.Flexible
    if self.setting.maxColNum > 0 and self.setting.maxRowNum == 0 then
        self.constraint = ConstraintType.FixedColumnCount
    end
    if self.setting.maxRowNum > 0 and self.setting.maxColNum == 0 then
        self.constraint = ConstraintType.FixedRowCount
    end
    self.cellW = self.setting.itemWidth + self.setting.gapX
    self.cellH = self.setting.itemHeight + self.setting.gapY
    self.curRowCount = 0
    self.curColCount = 0
end

function GridLoopScrollView:IsHorizontalDir()
    return self.constraint == ConstraintType.FixedRowCount
end

function GridLoopScrollView:ScrollToItem(index, duration, ease, cbFinish)
    local pos = {}
    local isHorizontal = self:IsHorizontalDir()
    pos.x = self.content.localPosition.x
    pos.y = self.content.localPosition.y
    local x = 0
    local y = 0
    if isHorizontal then
        x = math.ceil( index / self.curRowCount ) - 1
        x = x > 0 and x or 0
        pos.x = x * self.cellW + self.setting.paddingLeft
    else
        y = math.ceil( index / self.curColCount ) - 1
        y = y > 0 and y or 0
        pos.y = y * self.cellH + self.setting.paddingTop
    end
    self:ScrollToPosition(pos, duration, ease, cbFinish)
end

function GridLoopScrollView:ScrollToPosition(pos, duration, ease, cbFinish)
    local x = pos.x
    local y = pos.y
    --content横向从右到左移动时，x会逐渐减少
    local minX = self.viewport.rect.width - self.content.rect.width
    x = MathUtils.Clamp(x,minX,0)
    --content纵向从下往上移动时，y会逐渐增大
    local maxY = self.content.rect.height - self.viewport.rect.height
    y = MathUtils.Clamp(y,0,maxY)
    self:MoveTo(Vector3(x,y,0), duration, ease, cbFinish)
end

function GridLoopScrollView:GetFlexibleContentSize()
    local dataLen = #self.tbItemData
    local contentW = self.viewport.rect.width - self.setting.paddingLeft - self.setting.paddingRight
    local colCount = math.floor((contentW + self.setting.gapX) / self.cellW)
    local rowCount = math.ceil(dataLen / colCount)
    local contentH = rowCount * self.cellH - self.setting.gapY
    return contentW,contentH,rowCount,colCount
end

function GridLoopScrollView:GetFixedColCountContentSize()
    local dataLen = #self.tbItemData
    local maxColNum = self.setting.maxColNum
    local colCount = dataLen < maxColNum and dataLen or maxColNum
    local rowCount = math.ceil( dataLen / colCount )
    local contentW = colCount * self.cellW - self.setting.gapX
    local contentH = rowCount * self.cellH - self.setting.gapY
    return contentW,contentH,rowCount,colCount
end

function GridLoopScrollView:GetFixedRowCountContentSize()
    local dataLen = #self.tbItemData
    local maxRowNum = self.setting.maxRowNum
    local rowCount = dataLen < maxRowNum and dataLen or maxRowNum
    local colCount = math.ceil( dataLen / rowCount )
    local contentW = colCount * self.cellW - self.setting.gapX
    local contentH = rowCount * self.cellH - self.setting.gapY
    return contentW,contentH,rowCount,colCount
end

function GridLoopScrollView:UpdateContentSize()
    local contentW = 0
    local contentH = 0
    if self.constraint == ConstraintType.Flexible then
        contentW,contentH,self.curRowCount,self.curColCount = self:GetFlexibleContentSize()
    elseif self.constraint == ConstraintType.FixedRowCount then
        contentW,contentH,self.curRowCount,self.curColCount = self:GetFixedRowCountContentSize()
    elseif self.constraint == ConstraintType.FixedColumnCount then
        contentW,contentH,self.curRowCount,self.curColCount = self:GetFixedColCountContentSize()
    end
    if contentW < 0 then contentW = 0 end
    if contentH < 0 then contentH = 0 end
    contentW = contentW + self.setting.paddingLeft + self.setting.paddingRight
    contentH = contentH + self.setting.paddingTop + self.setting.paddingBottom
    self:SetContentSize(contentW,contentH)
end

function GridLoopScrollView:UpdateList()
    local contentX = -self.content.localPosition.x
    local contentY = self.content.localPosition.y
    if contentX < 0 then contentX = 0 end
    if contentY < 0 then contentY = 0 end

    --计算处于可视范围内的网格
    local grids = {}
    local dataLen = #self.tbItemData
    local viewW = self.viewport.rect.width
    local viewH = self.viewport.rect.height
    local startGridX = math.floor(contentX / self.cellW)
    local startGridY = math.floor(contentY / self.cellH)
    local endGridX = math.ceil((contentX + viewW) / self.cellW)
    local endGridY = math.ceil((contentY + viewH) / self.cellH)
    startGridX = MathUtils.Clamp(startGridX, 1, self.curColCount)
    startGridY = MathUtils.Clamp(startGridY, 1, self.curRowCount)
    endGridX = MathUtils.Clamp(endGridX, 1, self.curColCount)
    endGridY = MathUtils.Clamp(endGridY, 1, self.curRowCount)
    for i = startGridY, endGridY do
        for j = startGridX, endGridX do
            local gridIndex = (i-1) * self.curColCount + j
            if gridIndex >= 1 and gridIndex <= dataLen then
                table.insert(grids,{
                    x = j-1,
                    y = i-1,
                    index = gridIndex
                })
            end
            if gridIndex > dataLen then
                break
            end
        end
    end

    --先把不显示的回收，再生成
    local tempShowItems = self.tbShowingItem
    local tempDatas = {}
    self.tbShowingItem = {}

    for _, grid in ipairs(grids) do
        local renderData = self.tbItemData[grid.index]
        local insData = tempShowItems[renderData]
        if insData and insData.index == grid.index then
            self.tbShowingItem[renderData] = tempShowItems[renderData]
            tempShowItems[renderData] = nil
        end

        local newItem = {}
        newItem.pos = Vector3(grid.x*self.cellW, -grid.y*self.cellH, 0)
        newItem.index = grid.index
        tempDatas[renderData] = newItem
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