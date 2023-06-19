---技能基类
---流程： 满足释放条件(CD/事件/状态/范围...) --> 选择技能目标 --> 技能释放 --> 执行技能行为 --> 下一次轮询或者结束
---角色发射子弹, 击中目标
---角色绑定技能A
---满足条件 cd=1s 前置条件 监听事件 可释放技能状态 
---技能Timeline配置
---命中系统
---结算系统
SkillBase = Class("SkillBase")

function SkillBase:OnInit(conf)
    self.conf = conf
    self.cdTime = 0
    self.cdTimer = 0
    self.calculator = Calculator.New()
end

function SkillBase:OnDelete()
    if self.calculator then
        self.calculator:Delete()
        self.calculator = nil
    end
end

function SkillBase:SetEntity(entity)
    self.entity = entity
end

function SkillBase:SetCD(cdTime)
    self.cdTime = cdTime
    self.cdTimer = self.cdTime
end

function SkillBase:GetCD()
    return self.cdTimer
end

function SkillBase:IsCD()
    return self.cdTimer > 0
end

--技能释放
function SkillBase:Rel()
    if self:IsCD() then
        return false
    end
    if not self:CheckCond(self.conf.RelCondition) then
        return false
    end
    
end

--技能执行
function SkillBase:Exec()
    
end

--技能结束
function SkillBase:Finish()
    self.cdTimer = self.cdTime
end

---技能被打断
function SkillBase:Abort()
    self.cdTimer = self.cdTime
end

function SkillBase:Update(delatTime)
    if self.cdTime > 0 and self.cdTimer > 0 then
        self.cdTimer = self.cdTimer - delatTime
    else
        self.cdTimer = 0
    end
end

function SkillBase:Enable(enable)
    self.enable = enable
end

function SkillBase:CheckCond(pattern)
    return self.entity.CalcComponent:IsTrue(pattern)
end

return SkillBase