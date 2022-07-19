#ifndef SEED_LIT_FORWARD_INCLUDED
#define SEED_LIT_FORWARD_INCLUDED

#include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/SEED_Lighting.hlsl"
#include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/DepthBlend.hlsl"

struct a2v
{
    float4 positionOS : POSITION;
    float3 normalOS   : NORMAL;
    float2 texcoord   : TEXCOORD0;
#ifdef _NORMALMAP
    float4 tangent    : TANGENT;
#endif
    float2 staticLightmapUV   : TEXCOORD1;
    float2 dynamicLightmapUV  : TEXCOORD2;
};

struct v2f
{
    float2 uv         : TEXCOORD0;
    float4 positionCS : SV_POSITION;
    float3 positionWS : TEXCOORD1;
    half3  normalWS   : TEXCOORD2;
    half3  viewDirWS  : TEXCOORD3;
    DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 4);
#ifdef _NORMALMAP
    float4 tangentWS : TEXCOORD5;
#endif
#ifdef REQUIRE_SCREENUV
    float4 screenUV   : TEXCOORD6;
#endif
#ifdef _WRITECOLORDEPTH
    float depth       : TEXCOORD7;
#endif
#ifdef DYNAMICLIGHTMAP_ON
    float2  dynamicLightmapUV : TEXCOORD9; // Dynamic lightmap UVs
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
    o.shadowCoord             = TransformWorldToShadowCoord(i.positionWS);;
    o.fogCoord                = InitializeInputDataFog(float4(i.positionWS, 1.0), 0);
    o.vertexLighting          = zero.rgb;
    #if defined(DYNAMICLIGHTMAP_ON)
    o.bakedGI = SAMPLE_GI(i.staticLightmapUV, i.dynamicLightmapUV, i.vertexSH, i.normalWS);
    #else
    o.bakedGI = SAMPLE_GI(i.staticLightmapUV, i.vertexSH, i.normalWS);
    #endif
    o.normalizedScreenSpaceUV = zero.rg;
    o.shadowMask              = SAMPLE_SHADOWMASK(i.staticLightmapUV);;
    
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
    OUTPUT_SH(o.normalWS.xyz, o.vertexSH);
    OUTPUT_LIGHTMAP_UV(i.staticLightmapUV, unity_LightmapST, o.staticLightmapUV);
#ifdef DYNAMICLIGHTMAP_ON
    o.dynamicLightmapUV = i.dynamicLightmapUV.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif
#ifdef REQUIRE_SCREENUV
    o.screenUV = ComputeScreenPos(o.positionCS);
#endif
#ifdef _WRITECOLORDEPTH
    o.depth = -(TransformWorldToView(o.positionWS).z * _ProjectionParams.w);
#endif
    return o;
}

half4 frag (v2f i) : COLOR
{
    SurfaceInput surfaceInput;
    InitLitSurfaceData(i.uv, surfaceInput);
    
    InputData inputData;
    InitInputData(i, inputData, surfaceInput.normalTS);
    
    // sample the texture
    half4 col = DisneyDiffuseSpecularLutPBR(inputData, surfaceInput);
#ifdef _WRITECOLORDEPTH
    col.a = i.depth;
#endif

#ifdef _DEPTHBLEND
    col.rgb = DepthBlend(col.rgb, i.screenUV, _DepthBlendFade);
#endif

    col.rgb = MixFog(col.rgb, inputData.fogCoord);
    
    return col;
}


#endif