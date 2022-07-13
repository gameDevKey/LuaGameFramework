local queue = ClsOrderQueue.New()


queue:AddSyncOrder(function ()
    print("exe 1")
end,true)

queue:AddSyncOrder(function ()
    print("exe 2")
end,true, EOrderPosType.First)

queue:AddSyncOrder(function ()
    print("exe 3")
end,true)

queue:ExecuteNext()