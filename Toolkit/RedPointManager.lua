local RedPointManager = Class("RedPointManager")

local tbAllRedPoint = {}
setmetatable(tbAllRedPoint,{__mode = "v"}) --弱引用表，collectgarbage()之后会自动清除无效引用

---创建节点
---@param nodeId string 节点唯一ID，不能重名
---@param parentNode any
---@param callback any
function RedPointManager.CreateNode(nodeId,parentNode,callback)
    local node = tbAllRedPoint[nodeId] or ClsRedPointNode.New(nodeId)
    node:SetParent(parentNode)
    node:AddOnStateChangeListener(callback)
    tbAllRedPoint[nodeId] = node
    return node
end

local function CreateSubTree(treeData, parentNode)
    local node = RedPointManager.CreateNode(treeData.Id,parentNode,treeData.Callback)
    for _, childData in pairs(treeData.Children or {}) do
        CreateSubTree(childData, node)
    end
    return node
end

---根据红点树数据构建红点数
---@param redPointTreeData RedPointTreeData 红点树数据 Id/Callback/Children
-- RedPointTreeData = {
--     Id = string,
--     Callback = function,
--     Children = {
--         {Id = string, Callback = function, Children = {}},
--         {Id = string, Callback = function, Children = {}},
--     }
-- }
function RedPointManager.CreateTree(tree)
    return CreateSubTree(tree)
end

function RedPointManager.GetNode(nodeId)
    return tbAllRedPoint[nodeId]
end

return RedPointManager