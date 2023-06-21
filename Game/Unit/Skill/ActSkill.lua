--主动技能，CD好了直接释放
ActSkill = Class("ActSkill",SkillBase)

function ActSkill:OnInit()
end

function ActSkill:OnDelete()
end

function ActSkill:TryRel()
    if self:IsCD() then
        return
    end
    self:Rel()
end

function ActSkill:OnUpdate()
    self:TryRel()
end

return ActSkill