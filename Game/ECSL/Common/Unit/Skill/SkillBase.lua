SkillBase = Class("SkillBase")

function SkillBase:OnInit(skillId,skillLv)
    self.skillId = skillId
    self.skillLv = skillLv
    self.cdTime = 0
    self.cdTimer = 0
end

function SkillBase:OnDelete()
    
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
function SkillBase:Execute()
    
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

function SkillBase:BindEvent(eventId)
    
end

return SkillBase