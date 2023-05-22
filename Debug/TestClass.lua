-- local inA = Interface("InterfaceA")
-- function inA:InterfaceFuncA()
--     print("Call InterfaceFuncA")
-- end

-- local clsA = Class("ClassA",nil,{inA})
-- function clsA:FuncA()
--     print("Call FuncA")
-- end

-- local clsB = Class("ClassB", clsA)
-- function clsB:FuncB()
--     print("Call FuncB")
-- end

-- local clsC = Class("ClassC",clsB)
-- function clsC:FuncC()
--     print("Call FuncC")
-- end

-- local objC = clsC.New()
-- objC:FuncA()
-- objC:InterfaceFuncA()

-- objC:Delete()

-- local func = objC:ToFunc("FuncC")
-- func()

local cls = Class("Class")
function cls:ToString()
    return "重载ClassToString"
end
print("创建类",cls)

local scls = SingletonClass("SingletonClass")
print("创建单例类",scls)
local insA = scls.New()
print("创建单例类实例A",insA)
local insB = scls.New()
print("创建单例类实例B",insB)

local staticCls = StaticClass("StaticClass")
print("创建静态类",staticCls)
staticCls:Delete()
