local object1 = Object.New()
local object2 = Object.New()

object1:AddTimer(function()
    print('object1 tick')
end, 2)
object2:AddTimer(function()
    print('object2 tick')
end, 1)

GameManager.Instance():Tick(1)

GameManager.Instance():Tick(1)
