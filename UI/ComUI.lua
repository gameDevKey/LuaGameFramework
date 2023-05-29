ComUI = Class("ComUI", UIBase)

--解决几个问题
--组件复用问题
--组件自身应该没有主动监听某些事件的行为，所有的数据都是外界传入的
--或者说组件本身不会主动去做某些事情
--组件一般情况下不会单独存在，都是依赖某个界面共存亡

function ComUI:SetData(data,viewUI)
    self.data = data
    self.viewUI = viewUI
end

function ComUI:Refresh()
    self:CallFuncDeeply("OnRefresh")
end

--#region 虚函数

function ComUI:OnRefresh() end

--#endregion

return ComUI
