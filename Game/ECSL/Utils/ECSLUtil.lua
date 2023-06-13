ECSLUtil = StaticClass("ECSLUtil")

ECSLUtil.Uids = {}

function ECSLUtil.GetUid(type)
    if not ECSLUtil.Uids[type] then
        ECSLUtil.Uids[type] = 0
    end
    ECSLUtil.Uids[type] = ECSLUtil.Uids[type] + 1
    return ECSLUtil.Uids[type]
end

return ECSLUtil