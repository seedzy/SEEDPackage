#ifndef SEED_LIT_FORWARD_INCLUDED
#define SEED_LIT_FORWARD_INCLUDED

#include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/SEED_Lighting.hlsl"


struct a2v
{
    float4 positionOS : POSITION;
    float3 normalOS   : NORMAL;
    float2 texcoord   : TEXCOORD0;
#ifdef _NORMALMAP
    float4 tangent    : TANGENT;
#endif
};

struct v2f
{
    float2 uv         : TEXCOORD0;
    float4 positionCS : SV_POSITION;
    float3 positionWS : TEXCOORD1;
    half3  normalWS   : TEXCOORD2;
    half3  viewDirWS  : TEXCOORD3;
    DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 4);
#ifdef _NORMALMAP
    float4 tangentWS : TEXCOORD5;
#endif
};


void InitInputData(v2f i, out InputData o, half3 normalTS)
{
    o = (InputData)0;

    half4 zero = (half4)0;

    o.positionWS              = i.positionWS;
#ifdef _NORMALMAP
    float sgn = i.tangentWS.w;      // should be either +1 or -1
    float3 bitangent = sgn * cross(i.normalWS.xyz, i.tangentWS.xyz);
    o.normalWS = TransformTangentToWorld(normalTS, half3x3(i.tangentWS.xyz, bitangent.xyz, i.normalWS.xyz));
#else
    o.normalWS                = normalize(i.normalWS);
#endif
    o.viewDirectionWS         = normalize(i.viewDirWS);
    o.shadowCoord             = zero;
    o.fogCoord                = zero.r;
    o.vertexLighting          = zero.rgb;
    o.bakedGI                 = SAMPLE_GI(i.lightmapUV, i.vertexSH, i.normalWS);
    o.normalizedScreenSpaceUV = zero.rg;
    o.shadowMask              = zero;
    
}



v2f vert (a2v i)
{
    v2f o;
    o.positionCS = TransformObjectToHClip(i.positionOS.xyz);
    o.positionWS = TransformObjectToWorld(i.positionOS.xyz);
#ifdef _NORMALMAP
    o.tangentWS  = float4(TransformObjectToWorldDir(i.tangent.xyz), i.tangent.w * GetOddNegativeScale());
#endif
    o.normalWS   = TransformObjectToWorldNormal(i.normalOS);
    o.viewDirWS  = GetWorldSpaceViewDir(o.positionWS);
    o.uv = TRANSFORM_TEX(i.texcoord, _BaseMap);
    OUTPUT_LIGHTMAP_UV(input.lightmapUV, unity_LightmapST, output.lightmapUV);
    OUTPUT_SH(o.normalWS.xyz, o.vertexSH);
    return o;
}


half4 StylizedWaterShading(InputData inputData, SurfaceInput surfaceInput)
{
    Light light = GetMainLight();

    half3 lightDirectionWS = light.direction;

    half3 refractRay = refract(-inputData.viewDirectionWS, inputData.normalWS, 1 / surfaceInput.IOR);

    inputData.viewDirectionWS = -refractRay;
    
    BRDFInput brdfInput;
    InitBRDFInput(inputData, surfaceInput, lightDirectionWS, brdfInput);

    //directlight
    half3 ks = FresnelTerm_UE(brdfInput.HdotV, brdfInput.f0);
    half3 kd = (1 - ks) * (1 - surfaceInput.metallic);
    
    float diffuseTerm  = saturate(brdfInput.NdotL * 4 + 0.2);
    half3 spevularTerm = ks * DV_SmithJointGGX_HDRP(brdfInput.NdotH, brdfInput.NdotL, brdfInput.NdotV, brdfInput.roughness);

    half3 color = diffuseTerm + spevularTerm;

    half2 step = half2(0, 1);
    
    half ndotv = saturate(dot(inputData.normalWS, inputData.viewDirectionWS));

    

    float GGX = smoothstep(step.x, step.y, 1 - brdfInput.NdotV) * diffuseTerm;
    if(GGX > 0.99)
    {
        color = light.color;
    }
    else
    {
        color = _GradientMap.Sample(sampler_GradientMap, float2(GGX, 0.5));
    }
    

    //color *= light.color;
    //color *= light.color * saturate(dot(inputData.normalWS, lightDirectionWS));
    //URP包括Builtin都没除pi，为了保持亮度，这里先加回去
    //color *= PI;
    
    color += IndirectLight(inputData, surfaceInput, brdfInput) * 0.4;
    
    color += surfaceInput.emissionMask * surfaceInput.albedo.rgb;

    
    //return surfaceInput.albedo;
    return half4(saturate(color), surfaceInput.albedo.a);
}

half4 frag (v2f i) : COLOR
{
    SurfaceInput surfaceInput;
    InitLitSurfaceData(i.uv, surfaceInput);
    
    InputData inputData;
    InitInputData(i, inputData, surfaceInput.normalTS);
    
    // sample the texture
    half4 col = StylizedWaterShading(inputData, surfaceInput);
    return col;
}


#endif