local Skill001 = {}

--冷却时间，-1表示不进行冷却倒计时，0表示冷却立即完成
Skill001.CD = 1000

Skill001.RelCondition = "HP > 0 && MoveSpeed > 0"

Skill001.TargetNum = 3

Skill001.TargetCondition = "HP > 0"

Skill001.Action = "SkillAction001"

return Skill001