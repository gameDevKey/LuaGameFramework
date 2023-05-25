FacadeBase = Class("FacadeBase", ModuleBase)

function FacadeBase:OnInit()
    self.proxys = {}
    self.ctrls = {}
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

function FacadeBase:InitComplete()
    for _, list in ipairs({self.ctrls,self.proxys}) do
        for _, cls in pairs(list) do
            cls:InitComplete()
        end
    end
    self:OnInitComplete()
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

--模块内部广播
function FacadeBase:Broadcast(id,...)
    self.eventDispatcher:Broadcast(id,...)
end

return FacadeBase
