#ifndef SEED_LIT_META_PASS_INCLUDED
#define SEED_LIT_META_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UniversalMetaPass.hlsl"

half4 UniversalFragmentMetaLit(Varyings input) : SV_Target
{
    SurfaceInput surfaceData;
    InitLitSurfaceData(input.uv, surfaceData);

    BRDFData brdfData;
    InitializeBRDFData(surfaceData.albedo, surfaceData.metallic, float4(0,0,0,0), surfaceData.smoothness, surfaceData.albedo.a, brdfData);

    MetaInput metaInput;
    metaInput.Albedo = brdfData.diffuse + brdfData.specular * brdfData.roughness * 0.5;
    metaInput.Emission = float4(0,0,0,0);
    return UniversalFragmentMeta(input, metaInput);
}
#endif