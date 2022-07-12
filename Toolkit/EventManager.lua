--[[
    事件监听器
]]--
local EventManager = Class("EventManager")

local tbAllEvent = {}   --map[EventId][EventKey]EventObject
local eventKeyGenerator = GetAutoIncreaseFunc()

---添加监听器
---@param eventId EEventType 监听类型
---@param callback function 回调 function(...) 接收广播数据
---@param callOnce boolean|nil 是否只监听一次
function EventManager.AddListener(eventId,callback,callOnce)
    local eventKey = eventKeyGenerator()
    local eventObj = ClsEventObject.New(eventId,callback,callOnce)
    if not tbAllEvent[eventId] then
        tbAllEvent[eventId] = {}
    end
    tbAllEvent[eventId][eventKey] = eventObj
    return eventKey
end

---移除监听器
---@param eventId EEventType 监听类型
function EventManager.RemoveListener(eventId,eventKey)
    if tbAllEvent[eventId] and tbAllEvent[eventId][eventKey] then
        tbAllEvent[eventId][eventKey] = nil
    end
end

---移除所有监听器
function EventManager.RemoveAllListener()
    tbAllEvent = {}
end

---广播
---@param eventId EEventType 监听类型
---@param ... any 任意数据
function EventManager.Broadcast(eventId,...)
    for eventKey,eventObject in pairs(tbAllEvent[eventId] or {}) do
        eventObject:Invoke(...)
        if eventObject:IsCallOnce() then
            EventManager.RemoveListener(eventId,eventKey)
        end
    end
end

return EventManager