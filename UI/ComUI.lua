--ComUI依赖ViewUI，本身不会独立存在，没有主动行为，受到外界的输入才会有输出，ViewUI卸载时ComUI也会被卸载
ComUI = Class("ComUI", UIBase)

function ComUI:OnInit()
    -- self:SetAssetPath("xxx")
end

function ComUI:OnDelete()
    self.data = nil
end

function ComUI:SetData(data,index,viewUI)
    self.data = data
    self.index = index
    self.viewUI = viewUI
    self:CallFuncDeeply("OnSetData",true,data,index,viewUI)
end

function ComUI:SetParent(parent)
    if parent then
        self.gameObject.transform:SetParent(parent)
    end
    if self.rectTransform then
        RectTransformExt.Reset(self.rectTransform)
    end
end

--#region 虚函数

function ComUI:OnSetData(data,index,viewUI) end

--#endregion

return ComUI
