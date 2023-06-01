TestExtendView2 = Class("TestExtendView2",ViewUI)

function TestExtendView2:OnEnter(data)
    PrintLog(self,"入场了，数据是",data)
end
function TestExtendView2:OnEnterComplete()end
function TestExtendView2:OnExit()
    PrintLog(self,"退场了")
end
function TestExtendView2:OnExitComplete()end
function TestExtendView2:OnRefresh()
    PrintLog(self,"重新显示了")
end
function TestExtendView2:OnHide()
    PrintLog(self,"暂时隐藏了")
end
function TestExtendView2:OnAssetLoaded(assets)end

return TestExtendView2