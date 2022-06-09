#ifndef TOON_SURFACE_LIT_PASS
#define TOON_SURFACE_LIT_PASS

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

#include "OutlineUtil.hlsl"
// #include "NiloZOffset.hlsl"
// #include "NiloInvLerpRemap.hlsl"

#include "ToonInputData.hlsl"
#include "ToonLighting.hlsl"

struct a2v
{
    float3 positionOS   : POSITION;
    half3 normalOS      : NORMAL;
    //half4 tangentOS     : TANGENT;
    half4 vertexColor   : COLOR;
    float2 uv           : TEXCOORD0;
//#ifdef _SMOOTHFROMTANGENT
    float3 smoothNormalOS : TANGENT;
//#else
//    float3 smoothNormalOS : TEXCOORD1;
//#endif
};

// all pass will share this Varyings struct (define data needed from our vertex shader to our fragment shader)
struct v2f
{
    float4 positionCS               : SV_POSITION;
    float2 uv                       : TEXCOORD0;
    half3 normalWS                  : TEXCOORD1;
    half4 fogFactorAndVertexLight   : TEXCOORD2;
    DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 3);
    half4 vertexColor               : TEXCOORD4;
    float4 positionWSWithNdotL      : TEXCOORD5; // xyz: positionWS, w: vertex NdotL
    float4 positionNDC              : TEXCOORD6; // xyz: positionWS, w: vertex NdotL
    float4 rimPositionSS            : TEXCOORD7; // xyz: positionWS, w: vertex NdotL
#ifdef _IS_FACE
    half3 faceForward               : TEXCOORD8;
    half3 faceLeft                  : TEXCOORD9;
#endif



};

//TODO:记得删
//#define ToonShaderIsOutline


///////////////////////////////////////////////////////////////////////////////////////
// vertex shared functions
///////////////////////////////////////////////////////////////////////////////////////

/// <summary>
/// 将顶点沿着表面法线方向扩张
/// </summary>
float3 TransformPositionWSToOutlinePositionWS(float3 positionWS, float positionVS_Z, float3 normalWS, half width, float vertColWeight)
{
    //you can replace it to your own method! Here we will write a simple world space method for tutorial reason, it is not the best method!
    //这里修正轮廓线宽度
    float outlineExpandAmount = width * GetOutlineCameraFovAndDistanceFixMultiplier(positionVS_Z) * vertColWeight;
    return positionWS + normalWS * outlineExpandAmount; 
}




void InitializeInputData(v2f input, out InputData inputData)
{
    inputData = (InputData)0;
 
    inputData.positionWS = input.positionWSWithNdotL.xyz;
    inputData.viewDirectionWS = SafeNormalize(_WorldSpaceCameraPos - input.positionWSWithNdotL.xyz);
    #if defined(_NORMALMAP) || defined(_DETAIL)
    float sgn = input.tangentWS.w;      // should be either +1 or -1
    float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
    inputData.normalWS = TransformTangentToWorld(normalTS, half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz));
    #else
    inputData.normalWS = input.normalWS;
    #endif

    inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);

#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
    //inputData.shadowCoord = input.shadowCoord;
#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
    inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
#else
    inputData.shadowCoord = float4(0, 0, 0, 0);
#endif

    inputData.fogCoord = input.fogFactorAndVertexLight.x;
    inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
    inputData.bakedGI = SAMPLE_GI(input.lightmapUV, input.vertexSH, inputData.normalWS);
    //inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
    inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUV);
}

// if "ToonShaderIsOutline" is not defined    = do regular MVP transform
// if "ToonShaderIsOutline" is defined        = do regular MVP transform + push vertex out a bit according to normal direction
v2f VertexShaderWork(a2v input)
{
    v2f output;

    // VertexPositionInputs contains position in multiple spaces (world, view, homogeneous clip space, ndc)
    // Unity compiler will strip all unused references (say you don't use view space).
    // Therefore there is more flexibility at no additional cost with this struct.
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);

    // Similar to VertexPositionInputs, VertexNormalInputs will contain normal, tangent and bitangent
    // in world space. If not used it will be stripped.
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, (half4)0);

    float3 positionWS = vertexInput.positionWS;

    half3 smoothNormalWS = TransformObjectToWorldNormal(input.smoothNormalOS);
//     外扩法线
#ifdef ToonShaderIsOutline
    positionWS = TransformPositionWSToOutlinePositionWS(vertexInput.positionWS, vertexInput.positionVS.z, smoothNormalWS, _OutlineWidth, input.vertexColor.w * 2);
#endif
    float3 rimPositionWS = TransformPositionWSToOutlinePositionWS(vertexInput.positionWS, vertexInput.positionVS.z, smoothNormalWS, _RimWidth, 1);
    // Computes fog factor per-vertex.
    half3 vertexLight = VertexLighting(vertexInput.positionWS, vertexNormalInput.normalWS);
    half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

    //float NdotL = dot(vertexNormalInput.normalWS, GetMainLight().direction) * 0.5 + 0.5;
    float NdotL = dot(vertexNormalInput.normalWS, GetMainLight().direction) * 0.5 + 0.5;

    // TRANSFORM_TEX is the same as the old shader library.
    output.uv = TRANSFORM_TEX(input.uv,_BaseMap);

    //问就是省
    output.positionWSWithNdotL = float4(positionWS, NdotL);

    // packing positionWS(xyz) & fog(w) into a vector4
    output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
    output.normalWS = vertexNormalInput.normalWS; //normlaized already by GetVertexNormalInputs(...)
    OUTPUT_SH(output.normalWS.xyz, output.vertexSH);

    output.positionCS = TransformWorldToHClip(positionWS);

    output.positionNDC = vertexInput.positionNDC;

    output.rimPositionSS = ComputeScreenPos(TransformWorldToHClip(rimPositionWS));

    output.vertexColor = input.vertexColor;

#ifdef _IS_FACE
    output.faceForward = TransformObjectToWorldDir(half3(0, 0, 1));
    output.faceLeft = TransformObjectToWorldDir(half3(-1, 0, 0));
#endif

    return output;
}

///////////////////////////////////////////////////////////////////////////////////////
// fragment shared functions (Step1: prepare data structs for lighting calculation)
///////////////////////////////////////////////////////////////////////////////////////
/// <summary>
/// 采样baseMap颜色
/// </summary>
// half4 GetFinalBaseColor(v2f input)
// {
//     return tex2D(_BaseMap, input.uv) * _BaseColor;
// }

/// <summary>
/// 采样EmissionMap颜色
/// </summary>
half3 GetFinalEmissionColor(v2f input)
{
    half3 result = 0;
    if(_UseEmission)
    {
        result = tex2D(_EmissionMap, input.uv).rgb * _EmissionMapChannelMask * _EmissionColor.rgb;
    }

    return result;
}

// half3 ApplyFog(half3 color, v2f input)
// {
//     half fogFactor = input.positionWSAndFogFactor.w;
//     // Mix the pixel color with fogColor. You can optionaly use MixFogColor to override the fogColor
//     // with a custom one.
//     color = MixFog(color, fogFactor);
//
//     return color;  
// }

// only the .shader file will call this function by 
// #pragma fragment ShadeFinalColor
half4 ShadeFinalColor(v2f input) : SV_TARGET
{

    ToonSurfaceData surfaceData;
    InitializeSurfaceData(input.uv, input.vertexColor, surfaceData);
    
    InputData inputData;
    InitializeInputData(input, inputData);

    half areaLayer = GetYSAreaLayer(surfaceData.lightMap.a);
    
#ifdef ToonShaderIsOutline
    half3 finColor = GetOutlineColor(areaLayer);
#else
    #ifdef _IS_FACE
        half3 finColor = ToonFaceShading(surfaceData, input.faceForward, input.faceLeft, input.uv);
    #else
        half2 rampV = half2(0,0);
        half4 specColorPower = (half4)0;
        InitializeYSData(areaLayer, rampV, specColorPower);
        half3 finColor = ToonSurfaceShading(surfaceData, inputData, input.positionWSWithNdotL.w, rampV, specColorPower);
    #endif
#endif
    
//SSRimLight,先暂时这样，有点怪，得改
    Light light = GetMainLight();
    
    float rimLight = RimLight(input.positionNDC.zw, input.rimPositionSS, _Threshold, saturate((input.positionWSWithNdotL.w - 0.5) * 2));

    //finColor = lerp(finColor, (light.color + finColor) * 0.5, rimLight);
    finColor = lerp(finColor, half3(1,1,1), rimLight);

    return half4(finColor, surfaceData.alpha);
}

//////////////////////////////////////////////////////////////////////////////////////////
// fragment shared functions (for ShadowCaster pass & DepthOnly pass to use only)
//////////////////////////////////////////////////////////////////////////////////////////
void BaseColorAlphaClipTest(v2f input)
{
    ToonSurfaceData surfaceData;
    InitializeSurfaceData(input.uv, input.vertexColor, surfaceData);
    AlphaTest(surfaceData.alpha);
}



#endif