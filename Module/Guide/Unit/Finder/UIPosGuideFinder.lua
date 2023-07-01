UIPosGuideFinder = Class("UIPosGuideFinder",GuideFinder)

function UIPosGuideFinder:OnInit()
    self:Find(self.args.Type)
end

function UIPosGuideFinder:OnDelete()
    
end

function UIPosGuideFinder:Find(type)
    print("寻找UI位置",type)
    self:Finish({x=10,y=10})
end

return UIPosGuideFinder