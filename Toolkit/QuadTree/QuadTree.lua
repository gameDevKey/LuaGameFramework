QuadTree = Class("QuadTree")

function QuadTree:OnInit(data)
    self.data = data
    self.tree = QuadTreeNode.New(data)
end

function QuadTree:OnDelete()
    self.data = nil
    self.tree:Delete()
end

--插入
function QuadTree:Insert(rect)
    self.tree:Insert(rect)
end

--查找范围内物体
function QuadTree:Find(rect)
    return self.tree:Find(rect)
end

function QuadTree:Log()
    return self.tree:Log()
end

--创建矩形，左上角为原点
function QuadTree.GetRect(x, y, width, height)
    return { width = width, height = height, x = x, y = y }
end

return QuadTree
