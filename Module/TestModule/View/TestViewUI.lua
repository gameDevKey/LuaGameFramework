TestViewUI = Class("TestViewUI",ViewUI)

function TestViewUI:OnInit()
    self:SetupExtendView()
end

function TestViewUI:SetupExtendView()
    self:AddExtendView(TestExtendView1)
    self:AddExtendView(TestExtendView2)
end

function TestViewUI:OnEnter(data)
    PrintLog(self,"入场了，数据是",data)
end
function TestViewUI:OnEnterComplete()end
function TestViewUI:OnExit()
    PrintLog(self,"退场了")
end
function TestViewUI:OnExitComplete()end
function TestViewUI:OnRefresh()
    PrintLog(self,"重新显示了")
end
function TestViewUI:OnHide()
    PrintLog(self,"暂时隐藏了")
end
function TestViewUI:OnAssetLoaded(assets)end

return TestViewUI