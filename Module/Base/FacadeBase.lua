--门面基类，会在游戏启动前自动加载
--负责绑定MVC，以及内部广播
--函数InitComplete()会在Facade安装完成后自顶向下被调用
FacadeBase = Class("FacadeBase", ModuleBase)

function FacadeBase:OnInit()
    self.proxys = {}
    self.ctrls = {}
    --模块内部广播,只有Facade会拥有eventDispatcher对象，因此广播方向是自顶向下的
    self.eventDispatcher = EventDispatcher.New()
end

function FacadeBase:OnDelete()
    for _, list in ipairs({self.ctrls,self.proxys}) do
        for _, cls in pairs(list) do
            cls:SetFacade(nil)
            cls:Delete()
        end
    end
    self.eventDispatcher:Delete()
    self.proxys = nil
    self.ctrls = nil
    self.eventDispatcher = nil
end

function FacadeBase:BindCtrl(ctrl)
    if self.ctrls[ctrl._className] then
        PrintError("Ctrl重复绑定",ctrl)
        return
    end
    ctrl:SetFacade(self)
    self.ctrls[ctrl._className] = ctrl
end

function FacadeBase:BindProxy(proxy)
    if self.proxys[proxy._className] then
        PrintError("Proxy重复绑定",proxy)
        return
    end
    proxy:SetFacade(self)
    self.proxys[proxy._className] = proxy
end

function FacadeBase:OnInitComplete()
    for _, list in ipairs({self.ctrls,self.proxys}) do
        for _, cls in pairs(list) do
            cls:InitComplete()
        end
    end
end

return FacadeBase
