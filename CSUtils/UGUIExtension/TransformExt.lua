TransformExt = StaticClass("TransformExt")

function TransformExt.Reset(transfrom)
    transfrom.localPosition = CS.UnityEngine.Vector3.zero
    transfrom.localEulerAngles = CS.UnityEngine.Vector3.zero
    transfrom.localScale = CS.UnityEngine.Vector3.one
end

return TransformExt