LoginComUI = Class("LoginComUI",ComUI)

function LoginComUI:OnInit()
end

function LoginComUI:OnFindComponent()
    self.img = self:GetImage("Image")
    self.txtName = self:GetText("Image/name")
end

function LoginComUI:OnInitComponent()
    
end

function LoginComUI:OnSetData(data,index,viewUI)
    self.txtName.text = index
end

return LoginComUI