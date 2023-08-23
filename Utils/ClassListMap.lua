ClassListMap = Class("ClassListMap",ListMap)

function ClassListMap:OnInit()
    
end

function ClassListMap:OnDelete()
    self:Range(self._DeleteClass,self)
end

function ClassListMap:_DeleteClass(iter)
    iter.value:Delete()
end

return ClassListMap