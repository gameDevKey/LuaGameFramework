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
