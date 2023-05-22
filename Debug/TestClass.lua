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
