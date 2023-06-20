---技能基类
---流程： 满足释放条件(CD/事件/状态/范围...) --> 选择技能目标 --> 技能释放 --> 执行技能行为 --> 下一次轮询或者结束
---角色发射子弹, 击中目标
---角色绑定技能A
---满足条件 cd=1s 前置条件 监听事件 可释放技能状态 
---技能Timeline配置
---命中系统
---结算系统
SkillBase = Class("SkillBase",ECSLBase)

function SkillBase:OnInit(conf)
    self.enable = true
    self.conf = conf
    self.skillId = self.conf.Id
    self.cdTime = 0
    self.cdTimer = 0
    self.canReduceCD = true
    self:SetCD(self.conf.CD)
end

function SkillBase:OnDelete()
end

--技能释放
function SkillBase:Rel()
    if not self.enable then
        return false
    end
    local targetUids = self:FindTargets()
    self:Exec(targetUids)
end

--技能执行
function SkillBase:Exec(targetUids)
    if not self.enable then
        return
    end
    --TODO
    PrintLog("技能释放对象",targetUids)


    --Test
    self:Finish()
end

--技能结束
function SkillBase:Finish()
    self.cdTimer = self.cdTime
end

---技能被打断
function SkillBase:Abort()
    self.cdTimer = self.cdTime
end

function SkillBase:SetEntity(entity)
    self.entity = entity
end

---设置冷却时间
---@param cdTime number 数值小于0时, 表示冷却时间无穷大
function SkillBase:SetCD(cdTime)
    self.cdTime = cdTime
    self.cdTimer = self.cdTime
    self.canReduceCD = self.cdTime >= 0
end

function SkillBase:GetCD()
    return self.cdTime
end

function SkillBase:GetRemainCD()
    return self.cdTimer
end

function SkillBase:IsCD()
    if not self.canReduceCD then
        return true
    end
    return self.cdTimer > 0
end

function SkillBase:UpdateCD(delatTime)
    if not self.canReduceCD then
        return
    end
    if self.cdTimer > 0 then
        self.cdTimer = self.cdTimer - delatTime
    else
        self.cdTimer = 0
    end
end

function SkillBase:Update(delatTime)
    self:UpdateCD(delatTime)
    self:CallFuncDeeply("OnUpdate",true,delatTime)
end

function SkillBase:Enable(enable)
    self.enable = enable
end

function SkillBase:CheckCond(pattern)
    return self.entity.CalcComponent:IsTrue(pattern)
end

function SkillBase:FindTargets()
    local targets = self.world.SearchSystem:FindEntity({
        entityUid = self.entity:GetUid(),
        rangeData = self.conf.Range,
        matchPattern = nil,
    })
    return targets
end

function SkillBase:OnUpdate(delatTime) end

return SkillBase