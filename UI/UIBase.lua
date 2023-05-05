local UIBase = Class("UIBase", Object)

function UIBase:OnInit(...)
end

function UIBase:OnDelete(...)
end

---进入界面
function UIBase:Enter()
    self:OnEnter()
end

---退出界面
function UIBase:Exit()
    self:OnExit()
end

---重复进入界面
function UIBase:Refresh()
    self:OnRefresh()
end

function UIBase:OnEnter()
end

function UIBase:OnExit()
end

function UIBase:OnRefresh()
end

return UIBase
