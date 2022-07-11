local callback = function (id,state)
    PrintLog("节点[",id,"]状态改变-->",state)
end

local data = {
    Id = "Root",
    Callback = callback,
    Children = {
        {
            Id = "Node1",
            Callback = callback,
            Children = {
                
            },
        },
        {
            Id = "Node2",
            Callback = callback,
            Children = {
                {
                    Id = "Node2_1",
                    Callback = callback,
                    Children = {
                        {
                            Id = "Node2_1_1",
                            Callback = callback,
                            Children = {
                                
                            },
                        },
                    },
                },
                {
                    Id = "Node2_2",
                    Callback = callback,
                    Children = {
                        
                    },
                },
            },
        },
        {
            Id = "Node3",
            Callback = callback,
            Children = {
                {
                    Id = "Node3_1",
                    Callback = callback,
                    Children = {
                        
                    },
                },
            },
        }
    }
}

RedPointManager.CreateTree(data)

local Node2_1_1 = RedPointManager.GetNode("Node2_1_1")
Node2_1_1:SetState(RedPointState.Active)

PrintLog("=======================")
Node2_1_1:SetState(RedPointState.Inactive)

Node2_1_1 = nil
collectgarbage()

print(RedPointManager.GetNode("Node2_1_1") == nil and 'Node2_1_1销毁了' or 'Node2_1_1仍然存在')



