UIManager = SingletonClass("UIManager")

--需要解决几个问题
--每个界面显示N个模型，进入退出界面的模型管理
--进入某个界面时会由于上个界面的不同而播放不同的音乐
--界面的复用问题
--item界面的定义，是属于界面？还是属于特殊模块？
--界面的层级问题

--如果能把界面进入或者退出的原因通知到界面本身

function UIManager:OnInit()
    self.uiStack = {}
end

function UIManager:OnDelete()
    for _, view in ipairs(self.uiStack) do
        view:Delete()
    end
end

function UIManager:Enter(uiType, data)
    local config = UIDefine.Config[uiType]
    if not config.IsMulti and self:Exist(uiType) then
        PrintWarning(string.format("界面%s已存在", config.Class._className))
        return
    end
    local clazz = config.Class
    local view = clazz.New(data)
end

--退出某个界面(保持其他界面)
function UIManager:Exit(uiType)
end

--返回到某个界面(这个界面之后的所有界面都会退出)
function UIManager:GoBackTo(uiType)
end

function UIManager:Exist(uiType)
    for _, view in ipairs(self.uiStack) do
        if view.type == uiType then
            return true
        end
    end
    return false
end

return UIManager
