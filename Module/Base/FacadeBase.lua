--外部只分发一个通知ID，Facade去通知Ctrl、Proxy，具体是干啥由他们自己决定
--Ctrl可以控制View，Proxy不可以
--View层不应该直接监听外界事件，全部统一通过Facade-->Ctrl-->View的方式
--Proxy只监听和处理协议数据，然后对Facade或者全局进行通知

local FacadeBase = Class("FacadeBase")

function FacadeBase:OnInit()
    self.proxys = {}
    self.ctrls = {}
end

function FacadeBase:OnDelete()

end

function FacadeBase:BindCtrl(ctrl)

end

function FacadeBase:BindProxy(proxy)

end

return FacadeBase
