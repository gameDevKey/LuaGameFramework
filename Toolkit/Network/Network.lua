Network = SingletonClass("Network")

function Network:OnInit()

end

function Network:Send(proto,args)
    --TODO
end

function Network:Recv(proto,args)
    --TODO
    EventDispatcher.Global:Broadcast(EGlobalEvent.Proto,proto,args)
end

return Network