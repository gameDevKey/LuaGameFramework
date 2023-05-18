local Algorithm = {}
local random = math.random

---权重随机
---@param weights table 输入一个整型权重数组，比如{10,50,20}，不要输入小数
---@return integer index 返回一个数组对应的索引，代表本次随机的结果
function Algorithm.GetRandomIndexByWeights(weights)
    local total = 0
    for _, weight in ipairs(weights) do
        total = total + weight
    end
    local result = random(0,total)
    local last = 0
    for i, weight in ipairs(weights) do
        if result >= last and result <= (last + weight) then
            return i
        end
        last = last + weight
    end
    return 0
end

return Algorithm