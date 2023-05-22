--[[
    事件监听器
]]
--
local EventManager = SingletonClass("EventManager")

function EventManager:OnInit()
    self.tbAllEvent = {} --map[EventId][EventKey]EventObject
    self.eventKeyGenerator = GetAutoIncreaseFunc()
end

---添加监听器
---@param eventId EEvent.Type 监听类型
---@param callback function 回调 function(...) 接收广播数据
---@param callOnce boolean|nil 是否只监听一次
function EventManager:AddListener(eventId, callback, callOnce)
    local eventKey = self.eventKeyGenerator()
    local eventObj = EventObject.New(eventId, callback, callOnce)
    if not self.tbAllEvent[eventId] then
        self.tbAllEvent[eventId] = {}
    end
    self.tbAllEvent[eventId][eventKey] = eventObj
    return eventKey
end

---移除监听器
---@param eventId EEvent.Type 监听类型
function EventManager:RemoveListener(eventId, eventKey)
    if self.tbAllEvent[eventId] and self.tbAllEvent[eventId][eventKey] then
        self.tbAllEvent[eventId][eventKey] = nil
    end
end

---移除所有监听器
function EventManager:RemoveAllListener()
    self.tbAllEvent = {}
end

---广播
---@param eventId EEvent.Type 监听类型
---@param ... any 任意数据
function EventManager:Broadcast(eventId, ...)
    for eventKey, eventObject in pairs(self.tbAllEvent[eventId] or {}) do
        eventObject:Invoke(...)
        if eventObject:IsCallOnce() then
            self:RemoveListener(eventId, eventKey)
        end
    end
end

return EventManager
