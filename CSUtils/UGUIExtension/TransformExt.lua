TransformExt = StaticClass("TransformExt")

function TransformExt.Reset(transform)
    transform.localPosition = CS.UnityEngine.Vector3.zero
    transform.localEulerAngles = CS.UnityEngine.Vector3.zero
    transform.localScale = CS.UnityEngine.Vector3.one
end

return TransformExt