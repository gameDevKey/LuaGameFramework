UIExtendBase = ExtendClass(UIBase)

local CS_UI = CS.UnityEngine.UI

function UIExtendBase:GetComponent(path,cmp,transform)
    transform = transform or self.transform
    if not transform then return end
    local child = transform:Find(path)
    if not child then return end
    if not cmp then return child end
    return child.gameObject:GetComponent(typeof(cmp))
end

function UIExtendBase:GetTransform(path,transform)
    return self:GetComponent(path,nil,transform)
end

function UIExtendBase:GetImage(path,transform)
    return self:GetComponent(path,CS_UI.Image,transform)
end

function UIExtendBase:GetButton(path,transform)
    return self:GetComponent(path,CS_UI.Button,transform)
end

function UIExtendBase:GetText(path,transform)
    return self:GetComponent(path,CS_UI.Text,transform)
end

function UIExtendBase:GetRectTransform(path,transform)
    return self:GetComponent(path,CS_UI.Text,transform)
end

return UIExtendBase
