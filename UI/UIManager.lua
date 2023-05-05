local UIManager = Class("UIManager")

--需要解决几个问题
--每个界面显示N个模型，进入退出界面的模型管理
--进入某个界面时会由于上个界面的不同而播放不同的音乐
--界面的复用问题
--item界面的定义，是属于界面？还是属于特殊模块？
--界面的层级问题

function UIManager:OnInit()
    self.uiStack = {}
end

function UIManager:Enter()

end

function UIManager:Exit()

end

return UIManager
