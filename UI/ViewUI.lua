ViewUI = Class("ViewUI", UIBase)

--解决几个问题
--触发入场动画、音效等等
--可能要考虑打开界面完成后自动触发一些事件，比如入场完成事件，关闭界面同理
--管理ComUI，可复用的界面、ScrollView的Item等等，都属于ComUI

function ViewUI:OnInit()
    self.comUIs = {}
end

function ViewUI:OnDelete()
    
end

function ViewUI:AddComUI(comType)
    
end

return ViewUI
