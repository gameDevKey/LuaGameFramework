UIBase = Class("UIBase", ModuleBase)

function UIBase:OnInit()
    --id/order/type
end

function UIBase:OnDelete()
end

function UIBase:SetAsset()
end

---进入界面
function UIBase:Enter(data)
    self:OnEnter(data)
end

---进入界面完成，界面进入可能是一个耗时的操作（受到加载或者入场动画的影响）
function UIBase:EnterComplete()
    self:OnEnterComplete()
end

---退出界面
function UIBase:Exit()
    self:OnExit()
end

--退出界面完成，界面退出可能是一个耗时的操作（受到离场动画的影响）
function UIBase:ExitComplete()
    self:OnExitComplete()
end

---重复进入界面
function UIBase:Refresh()
    self:OnRefresh()
end

--#region 虚函数
function UIBase:OnEnter(data)end
function UIBase:OnEnterComplete()end
function UIBase:OnExit()end
function UIBase:OnExitComplete()end
function UIBase:OnRefresh()end
--#endregion

return UIBase
