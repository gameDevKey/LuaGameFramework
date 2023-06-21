UIBaseExtend = ExtendClass(UIBase)

local Engine = CS.UnityEngine
local CS_UI = Engine.UI

function UIBaseExtend:GetComponent(path,cmp,transform)
    transform = transform or self.transform
    if not transform then return end
    local child = transform:Find(path)
    if not child then return end
    if not cmp then return child end
    return child.gameObject:GetComponent(typeof(cmp))
end

function UIBaseExtend:GetTransform(path,transform)
    return self:GetComponent(path,nil,transform)
end

function UIBaseExtend:GetCanvas(path,transform)
    return self:GetComponent(path,Engine.Canvas,transform)
end

function UIBaseExtend:GetImage(path,transform)
    return self:GetComponent(path,CS_UI.Image,transform)
end

function UIBaseExtend:GetButton(path,transform)
    return self:GetComponent(path,CS_UI.Button,transform)
end

function UIBaseExtend:GetText(path,transform)
    return self:GetComponent(path,CS_UI.Text,transform)
end

function UIBaseExtend:GetRectTransform(path,transform)
    return self:GetComponent(path,CS_UI.Text,transform)
end

return UIBaseExtend
