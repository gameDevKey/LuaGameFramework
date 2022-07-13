local clsA = Class("ClsA",Object)
function clsA:Ctor()
    self.a = 10
end
function clsA:OnInit()
    clsA._super.OnInit(self)
    self.active = true
end
function clsA:OnDestory()
    clsA._super.OnDestory(self)
    self.active = false
end
function clsA:ToString()
    return "ObjectID:"..self:GetObjectId().." Active:"..tostring(self.active)
end

local pool = ClsObjectPool.New(
    function ()
        return clsA.New()
    end
)

for i = 1, 10, 1 do
    local item = pool:SyncGet()
    item:OnInit()
    print("实例化",item)
    if i > 5 then
        item:OnDestory()
        print("回收",pool:Recycle(item))
    end
end