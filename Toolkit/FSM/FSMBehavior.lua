--FSM行为
FSMBehavior = Class("FSMBehavior", ECSLBase)

function FSMBehavior:OnInit()
    self.isEnter = false
end

function FSMBehavior:OnDelete()
end

---进入回调
function FSMBehavior:Enter(data)
    if self.isEnter then
        return
    end
    self.isEnter = true
    self:CallFuncDeeply("OnEnter", true, data)
end

---退出回调
function FSMBehavior:Exit(data)
    if not self.isEnter then
        return
    end
    self.isEnter = false
    self:CallFuncDeeply("OnExit", true, data)
end

function FSMBehavior:Tick(deltaTime)
    self:CallFuncDeeply("OnTick", true, deltaTime)
end

--#region 虚函数

function FSMBehavior:CanTransition(data) return true end

function FSMBehavior:OnEnter(data) end

function FSMBehavior:OnExit(data) end

function FSMBehavior:OnTick(deltaTime) end

--#endregion

return FSMBehavior
