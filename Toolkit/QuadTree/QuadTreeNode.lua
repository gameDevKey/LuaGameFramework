--四叉树
QuadTreeNode = Class("QuadTreeNode")

function QuadTreeNode:OnInit(data)
    self.maxDepth = data.maxDepth
    self.capcity = data.capcity

    self.childNodes = {}
    self.objects = {}
    self.depth = data.depth
    self.rect = data.rect
end

function QuadTreeNode:OnDelete()
    
end

--插入
function QuadTreeNode:Insert(rect)
    if not self:Intersects(rect) then
        return false
    end
    local childAmount = #self.childNodes
    if childAmount > 0 then
        local side = self:SideOf(rect)
        if side ~= EQuadTree.Side.Unknown then
            return self.childNodes[side]:Insert(rect)
        end
    end
    table.insert(self.objects,rect)
    if childAmount == 0 and
        (self.maxDepth <= 0 or self.depth <= self.maxDepth) and
        (#self.objects > self.capcity) then
        self:Split()
    end
    return true
end

function QuadTreeNode:Find(rect)
    
end

--分裂
function QuadTreeNode:Split()
    local halfWidth = self.rect.width / 2
    local halfHeight = self.rect.height / 2
    local midX = self.rect.x + halfWidth
    local midY = self.rect.y + halfHeight

    self.childNodes[EQuadTree.Side.LeftTop] = QuadTreeNode.New({
        maxDepth = self.maxDepth,
        capcity = self.capcity,
        depth = self.depth + 1,
        rect = QuadTree.GetRect(self.rect.x,self.rect.y,halfWidth,halfHeight),
    })
    self.childNodes[EQuadTree.Side.LeftBottom] = QuadTreeNode.New({
        maxDepth = self.maxDepth,
        capcity = self.capcity,
        depth = self.depth + 1,
        rect = QuadTree.GetRect(self.rect.x,midY,halfWidth,halfHeight),
    })
    self.childNodes[EQuadTree.Side.RightTop] = QuadTreeNode.New({
        maxDepth = self.maxDepth,
        capcity = self.capcity,
        depth = self.depth + 1,
        rect = QuadTree.GetRect(midX,self.rect.y,halfWidth,halfHeight),
    })
    self.childNodes[EQuadTree.Side.RightBottom] = QuadTreeNode.New({
        maxDepth = self.maxDepth,
        capcity = self.capcity,
        depth = self.depth + 1,
        rect = QuadTree.GetRect(midX,midY,halfWidth,halfHeight),
    })

    local tempObjects = self.objects
    self.objects = {}
    for _, object in ipairs(tempObjects) do
        self:Insert(object)
    end
end

--判断两矩形是否相交
function QuadTreeNode:Intersects(rect)
    
end

--判断目标矩形处于哪个象限，处于交界处不算
function QuadTreeNode:SideOf(rect)
    if rect.x + rect.width <= self.rect.x + self.rect.width / 2 and
        rect.y + rect.height <= self.rect.y + self.rect.height / 2 then
        return EQuadTree.Side.LeftTop
    end
    if rect.x + rect.width  then
        
    end
    return EQuadTree.Side.Unknown
end

return QuadTreeNode