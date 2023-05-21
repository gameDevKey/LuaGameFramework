<<<<<<< HEAD
local ParentClass = Class("ParentClass")
function ParentClass:Func1(...)
    print("call parent func1:", ...)
    print("parent data:", self.Data.a)
end

local ChildClass = Class("ChildClass", ParentClass)
ChildClass.Data = { a = 1 }
function ChildClass:Func1(...)
    self:SuperFunc("Func1", ...)
    print("call child func1:", ...)
    print("child data:", self.Data.a)
end

local childInstance = ChildClass.New()
childInstance:Func1("参数1", "ABC")
=======
local inA = Interface("InterfaceA")
function inA:InterfaceFuncA()
    print("Call InterfaceFuncA")
end

local clsA = Class("ClassA",nil,{inA})
function clsA:FuncA()
    print("Call FuncA")
end

local clsB = Class("ClassB", clsA)
function clsB:FuncB()
    print("Call FuncB")
end

local clsC = Class("ClassC",clsB)
function clsC:FuncC()
    print("Call FuncC")
end

local objC = clsC.New()
objC:FuncA()
objC:InterfaceFuncA()

objC:Delete()

local func = objC:ToFunc("FuncC")
func()
>>>>>>> a5a34bf739c885e7dcd5d551c719a8a8edf7c4a6
