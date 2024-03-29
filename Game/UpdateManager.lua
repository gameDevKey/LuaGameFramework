UpdateManager = SingletonClass("UpdateManager")

function UpdateManager:OnInit()
    self.updaters = ListMap.New()
    self.index = 0
end

function UpdateManager:OnDelete()
    self.updaters:Delete()
end

function UpdateManager:Register(func)
    if not func then
        return
    end
    self.index = self.index + 1
    self.updaters:Add(self.index, func)
    return self.index
end

function UpdateManager:Unregister(index)
    self.updaters:Remove(index)
end

function UpdateManager:Update(deltaTime)
    self.deltaTime = deltaTime
    self.updaters:Range(self.OnUpdate, self)
end

function UpdateManager:OnUpdate(iter)
    iter.value(self.deltaTime)
end

return UpdateManager
