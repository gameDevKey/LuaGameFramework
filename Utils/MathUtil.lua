local MathUtil = {}
local randomseed = math.randomseed

---二分查找法
---@param list table 有序数组
---@param target any 目标值
---@return integer index 目标值的索引，-1表示找不到目标
function MathUtil.BinarySearch(list,target)
    local low = 1
    local high = #list
    local mid = nil
    while(low <= high) do
        if list[low] == target then
            return low
        end
        if list[high] == target then
            return high
        end
        mid = math.floor(low + (high - low) / 2)
        mid = MathUtil.Clamp(mid, 1, high)
        if list[mid] == target then
            return mid
        end
        if list[mid] < target then
            low = mid + 1
        else
            high = mid -1
        end
    end
    return -1
end

function MathUtil.Clamp(num, min, max)
    if min > max then
        local temp = min
        min = max
        max = temp
    end
    if min and num < min then
        num = min
    end
    if max and num > max then
        num = max
    end
    return num
end

function MathUtil.RandomSeed(seed)
    randomseed(seed or tostring(os.time()):reverse():sub(1, 6))
end

return MathUtil