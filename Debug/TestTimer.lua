local object1 = ModuleBase.New()
local object2 = ModuleBase.New()

object1:AddTimer(function()
    print('object1 tick')
end, 2)
object2:AddTimer(function()
    print('object2 tick')
end, 1)

GameManager.Instance:Tick(1)

GameManager.Instance:Tick(1)
