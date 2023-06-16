SkinComponent = Class("SkinComponent",ECSLRenderComponent)

function SkinComponent:OnInit()
    self.assetLoader = AssetLoader.New()
end

function SkinComponent:OnDelete()
    self.assetLoader:Delete()
end

function SkinComponent:OnUpdate()
end

function SkinComponent:OnEnable()
end

function SkinComponent:SetSkin(skinData)
    --Test
    self.assetLoader:AddAsset("Player",CallObject.New(self:ToFunc("OnSkinLoaded")))
    self.assetLoader:LoadAsset()
end

function SkinComponent:OnSkinLoaded(res,path)
    local skin = UnityUtil.Instantiate(res)
    skin.transform:SetParent(self.entity.gameObject.transform)
    skin.transform.localPosition = CS.UnityEngine.Vector3.zero
end

return SkinComponent