StateComponent = Class("StateComponent", ECSLComponent)

function StateComponent:OnInit()
    self.curFSM = nil
end

function StateComponent:OnDelete()
    if self.curFSM then
        self.curFSM:Delete()
    end
end

function StateComponent:OnUpdate(deltaTime)
    if self.curFSM then
        self.curFSM:Tick(deltaTime)
    end
end

function StateComponent:OnEnable()
end

function StateComponent:SetFSM(fsm)
    self.curFSM = fsm
end

return StateComponent
