EventDispatcher = Class("EventDispatcher")

function EventDispatcher:OnInit()
    self.tbAllEvent = {} --map[EventId][EventKey]EventObject
    self.eventKeyGenerator = GetAutoIncreaseFunc()
end

function EventDispatcher:OnDelete()
    self:RemoveAllListener()
end

---添加监听器
---@param eventId any 监听类型
---@param callback function 回调 function(...) 接收广播数据
---@param callOnce boolean|nil 是否只监听一次
function EventDispatcher:AddListener(eventId, callback, caller, callOnce)
    local eventKey = self.eventKeyGenerator()
    local eventObj = EventObject.New(eventId, callback, caller, callOnce)
    if not self.tbAllEvent[eventId] then
        self.tbAllEvent[eventId] = {}
    end
    self.tbAllEvent[eventId][eventKey] = eventObj
    return eventKey
end

---移除监听器
---@param eventId any 监听类型
function EventDispatcher:RemoveListener(eventId, eventKey)
    if self.tbAllEvent[eventId] and self.tbAllEvent[eventId][eventKey] then
        self.tbAllEvent[eventId][eventKey]:Delete()
        self.tbAllEvent[eventId][eventKey] = nil
    end
end

---移除所有监听器
function EventDispatcher:RemoveAllListener()
    for eventId, dict in pairs(self.tbAllEvent) do
        for eventKey, eventObject in pairs(dict) do
            eventObject:Delete()
        end
    end
    self.tbAllEvent = {}
end

---广播
---@param eventId any 监听类型
---@param ... any 任意数据
function EventDispatcher:Broadcast(eventId, ...)
    for eventKey, eventObject in pairs(self.tbAllEvent[eventId] or NIL_TABLE) do
        eventObject:Invoke(...)
        if eventObject:IsCallOnce() then
            self:RemoveListener(eventId, eventKey)
        end
    end
end

return EventDispatcher
