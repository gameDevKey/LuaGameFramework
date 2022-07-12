--[[
    事件监听器
]]--
local EventManager = Class("EventManager")

local tbAllEvent = {}

---添加监听器
---@param eventId EEventType 监听类型
---@param listenerId integer 监听者ID
---@param callback function 回调 function(...) 接收广播数据
---@param callOnce boolean|nil 是否只监听一次
function EventManager.AddListener(eventId,listenerId,callback,callOnce)
    local eventObject = tbAllEvent[eventId] and tbAllEvent[eventId][listenerId]
    if eventObject then
        eventObject:SetCallback(callback)
        eventObject:SetCallOnce(callOnce)
    else
        eventObject = ClsEventObject.New(eventId,listenerId,callback,callOnce)
    end
    if not tbAllEvent[eventId] then
        tbAllEvent[eventId] = {}
    end
    tbAllEvent[eventId][listenerId] = eventObject
end

---移除监听器
---@param eventId EEventType 监听类型
---@param listenerId int|nil 监听者ID
function EventManager.RemoveListener(eventId,listenerId)
    if tbAllEvent[eventId] then
        if listenerId then
            tbAllEvent[eventId][listenerId] = nil
        else
            tbAllEvent[eventId] = nil
        end
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
    for listenerId,eventObject in pairs(tbAllEvent[eventId] or {}) do
        eventObject:Invoke(...)
        if eventObject:IsCallOnce() then
            EventManager.RemoveListener(eventId)
        end
    end
end

return EventManager