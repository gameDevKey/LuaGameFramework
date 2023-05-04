local UIBase = Class("UIBase")

function UIBase:OnInit(...)
end

function UIBase:OnDelete(...)
end

function UIBase:Enter()
    self:OnEnter()
end

function UIBase:Exit()
    self:OnExit()
end

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
