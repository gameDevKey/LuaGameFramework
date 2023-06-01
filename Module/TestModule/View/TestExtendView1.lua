TestExtendView1 = Class("TestExtendView1",ViewUI)

function TestExtendView1:OnEnter(data)
    PrintLog(self,"入场了，数据是",data)
end
function TestExtendView1:OnEnterComplete()end
function TestExtendView1:OnExit()
    PrintLog(self,"退场了")
end
function TestExtendView1:OnExitComplete()end
function TestExtendView1:OnRefresh()
    PrintLog(self,"重新显示了")
end
function TestExtendView1:OnHide()
    PrintLog(self,"暂时隐藏了")
end
function TestExtendView1:OnAssetLoaded(assets)end

return TestExtendView1