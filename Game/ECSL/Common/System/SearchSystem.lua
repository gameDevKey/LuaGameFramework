SearchSystem = Class("SearchSystem",ECSLSystem)

function SearchSystem:OnInit()
end

function SearchSystem:OnDelete()
end

function SearchSystem:OnUpdate()
end

function SearchSystem:OnEnable()
end

---搜索所有符合条件的实体
---@param searchData table { entityUid, rangeData, matchPattern, ... }
----@inparam rangeData:table  { type, radius/... }
function SearchSystem:FindEntity(searchData)
    local entitys = self.world.EntitySystem:GetEntitys()
    local result = {}
    entitys:RangeByCallObject(CallObject.New(self:ToFunc("OnFindEntityByIter"
        ,nil,{result=result,searchData=searchData})))
    return result
end

function SearchSystem:OnFindEntityByIter(args,iter)
    local result = args.result
    local searchData = args.searchData
    local range = searchData.rangeData
    local match = searchData.matchPattern
    local finderEntity = self.world.EntitySystem:GetEntity(searchData.entityUid)
    local curEntity = iter.value
    if not finderEntity or not curEntity then
        return
    end
    if range then
        if range.type == SearchConfig.Range.Circle then
            local radius = range.radius
            local dis = ECSLUtil.GetEntityDis(finderEntity,curEntity)
            if dis <= radius then
                table.insert(result, curEntity)
            end
        end
        --TODO...
    end
    --TODO match...
end

return SearchSystem