DataWatcher = Class("DataWatcher",DataWatcherBase)

function DataWatcher:OnInit()
    self.data = nil
end

function DataWatcher:OnDelete()
end

function DataWatcher:SetVal(val)
    local change = false
    if self.data ~= nil then
        if self.compareFunc then
            if not self.compareFunc:Invoke(val,self.data) then
                change = true
            end
        else
            change = self.data ~= val
        end
    end
    local old = self.data
    self.data = val
    if change then
        self.changeFunc:Invoke(self.data,old)
    end
end

function DataWatcher:GetVal()
    return self.data
end

return DataWatcher