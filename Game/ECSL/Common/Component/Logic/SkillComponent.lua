SkillComponent = Class("SkillComponent",ECSLComponent)

function SkillComponent:OnInit()
    self.skills = ListMap.New()
end

function SkillComponent:OnDelete()
    self.skills:Delete()
end

function SkillComponent:OnUpdate()
    self.skills:Range(self.UpdateSkillByIter,self)
end

function SkillComponent:OnEnable()
    self.skills:Range(self.EnableSkillByIter,self)
end

function SkillComponent:UpdateSkillByIter(iter)
    iter.value:Update()
end

function SkillComponent:EnableSkillByIter(iter)
    iter.value:Enable(self.enable)
end

function SkillComponent:AddSkill(skillId,skillLv)
    if self.skills:Get(skillId) then
        PrintError("技能已存在",skillId)
        return
    end
    local skill = SkillBase.New(skillId,skillLv)
    self.skills:Add(skillId,skill)
end

function SkillComponent:RemoveSkill(skillId)
    self.skills:Remove(skillId)
end

function SkillComponent:AbortSkill(skillId)
    local skill = self.skills:Get(skillId)
    if skill then
        skill:Abort()
    end
end

return SkillComponent