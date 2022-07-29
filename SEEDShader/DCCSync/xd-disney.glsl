#define USE_MATERIAL_PROPERTIES
#define CUSTOM_ACES
import lib-env.glsl
import lib-utils.glsl
import lib-vectors.glsl
import lib-sampler.glsl
// import lib-sss.glsl
import lib-pbr.glsl
// import lib-emissive.glsl
// import lib-pom.glsl
import lib-defines.glsl
import lib-normal.glsl


//====================================Uniform=================================
//------------------------------------Albedo----------------------------------

//: param auto channel_transmissive
uniform SamplerSparse transmissive_tex;
//: param auto channel_anisotropyangle
uniform SamplerSparse anisotropyangle_tex;
//: param auto channel_anisotropylevel
uniform SamplerSparse anisotropylevel_tex;
//: param custom { "default": "", "label": "Detail Map", "usage": "texture" }
uniform sampler2D detailMapSampler;

//: param custom {
//:   "default": 1,
//:   "label": "Light Type",
//:   "widget": "combobox",
//:   "values": {
//:     "Fixed Direction Light": 0,
//:     "Custom Light": 1,
//:     "SP Default Light":2
//:   },
//:   "group": "Light Settings",
//:   "description": "<html><head/><body><p>Skin or Translucent/Generic. It needs to be activated in the Display Settings and a Scattering channel needs to be present for these parameters to have an effect.</p></body></html>"
//: }
uniform int LightType;

//: param custom { "default": 1.0, 
//: "label": "Light Color",
//: "widget": "color",
//: "group": "Light Settings" 
//: }
uniform vec4 lightColor;

//: param custom {
//: "default": [16.271, 21.382, -21.61],
//: "label": "Directional Light Rotation",
//: "min": -180, "max": 180 ,
//: "group": "Light Settings"
//: }
uniform vec3 customLightRot;

#ifdef USE_MATERIAL_PROPERTIES
  //: param auto channel_basecolor
  uniform SamplerSparse _MainTex_Sparse;
#else
  // param custom { "default": [1.0, 1.0, 1.0], 
  // "label": "Albedo Map",
  // "usage": "texture",
  // "group": "ALBEDO" 
  // }
  // uniform sampler2D _MainTex;

  // param custom { "default": [1.0, 1.0, 1.0, 0.0], 
  // "label": "Color",
  // "widget": "color",
  // "group": "ALBEDO"
  // }
  // uniform vec4 _BaseColor;
#endif

  //: param custom{
  //: "default": [1.0, 1.0, 0.0, 0.0],
  //: "label": "Albedo Map Tilling and Offset",
  //: "group": "ALBEDO/Advanced"
  //: }
  uniform vec4 _MainTex_ST;

//: param custom {
//: "default": 0.0,
//: "label": "Color Intensity",
//: "min": -10.0,
//: "max": 10.0,
//: "group": "ALBEDO"
//: }
uniform float _BaseColor_HDR;

//------------------------------------NORMAL And MASK----------------------------------

#ifdef USE_MATERIAL_PROPERTIES
  //: param auto channel_normal 
  uniform SamplerSparse _BumpMaskMap_Sparse;
#else
  // param custom { "default": [1.0, 1.0, 1.0], 
  // "label": "Normal(RG) Sheen(B) Clearcoat(A)",
  // "usage": "texture",
  // "group": "NORMAL And MASK"
  // }
  // uniform sampler2D _BumpMaskMap;
#endif

//: param custom{
//: "default": [1.0, 1.0, 0.0, 0.0],
//: "label": "Normal(RG) Sheen(B) Clearcoat(A)",
//: "group": "NORMAL And MASK/Advanced"
//: }
uniform vec4 _BumpMaskMap_ST;

//------------------------------------PBR MISC----------------------------------
#ifdef USE_MATERIAL_PROPERTIES
  //: param auto channel_metallic
  uniform SamplerSparse _MetalTexture_Sparse; 
  //: param auto channel_roughness 
  uniform SamplerSparse _RoughnessTexture_Sparse; 
  //: param auto channel_ambientocclusion    
  uniform SamplerSparse _AOTexture_Sparse; 
  //: param auto channel_emissive  
  uniform SamplerSparse _EmissionTexture_Sparse; 
#else
  // param custom { 
  // "default": [0.5, 0.5, 0.5, 0.5], 
  // "label": "PBR MAP：R:Metal G:Rough B:AO A:Emission",
  // "usage": "texture",
  // "group": "PBR MISC"
  // }
  // uniform sampler2D _MixTexture;
#endif

//: param custom{
//: "default": [1.0, 1.0, 0.0, 0.0],
//: "label": "PBR MAP：R:Metal G:Rough B:AO A:Emission Tilling and Offset",
//: "group": "PBR MISC/Advanced"
//: }
uniform vec4 _MixTexture_ST;

//: param custom {
//: "default": 0.0,
//: "label": "AO Intensity",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "PBR MISC"
//: }
uniform float _OcclusionIntensity;

//: param custom { "default": 0, 
//: "label": "AO Color",
//: "widget": "color",
//: "group": "PBR MISC" 
//: }
uniform vec4 _OcclusionColor;

//: param custom {
//: "default": 0.0,
//: "label": "Emission Intensity",
//: "min": 0.0,
//: "max": 20.0,
//: "group": "PBR MISC"
//: }

//------------------------------------SUBSURFACE----------------------------------
uniform float _EmissionIntensity;

//: param custom { 
//: "default": false,
//: "label": "Subsurface",
//: "group": "SUBSURFACE"
//: }
uniform bool _SUBSURFACEToggle;

//: param custom { "default": [1.0, 0.6, 0.6, 1.0], 
//: "label": "Subsurface Color",
//: "widget": "color",
//: "group": "SUBSURFACE" 
//: }
uniform vec4 _SubsurfaceCol;

//: param custom { 
//: "default": [0.0, 0.0, 0.0, 0.0], 
//: "label": "Subsurface LUT",
//: "usage": "texture",
//: "group": "SUBSURFACE"
//: }
uniform sampler2D _SubsurfaceLUT;

//: param custom { 
//: "default": [1.0, 1.0, 1.0, 1.0], 
//: "label": "Subsurface Translucency",
//: "usage": "texture",
//: "group": "SUBSURFACE"
//: }
uniform sampler2D _SubsurfaceMap;

//: param custom{
//: "default": [1.0, 1.0, 0.0, 0.0],
//: "label": "Subsurface Translucency Tilling and Offset",
//: "group": "SUBSURFACE/Advanced"
//: }
uniform vec4 _SubsurfaceMap_ST;
//: param custom {
//: "default": 5.0,
//: "label": "Translucency Power",
//: "min": 0.0,
//: "max": 10.0,
//: "group": "SUBSURFACE"
//: }
uniform float _TransPower;

//: param custom {
//: "default": 1.0,
//: "label": "Translucency Strengh",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "SUBSURFACE"
//: }
uniform float _TransStrength;

//: param custom { 
//: "default": false,
//: "label": "Anisotropic",
//: "group": "Anisotropic"
//: }
uniform bool _ANISOTROPICToggle;

//: param custom {
//: "default": 0.0,
//: "label": "Anisotropic",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "SUBSURFACE"
//: }
uniform float _Anisotropic;

//------------------------------------Anisotropic----------------------------------
//: param custom { 
//: "default": false,
//: "label": "AnisotropicKAJIYAKAY",
//: "group": "Anisotropic"
//: }
uniform bool _ANISOTROPIC_KAJIYAKAY_Toggle;

//: param custom { 
//: "default": 0.5, 
//: "label": "_MaskMap",
//: "usage": "texture",
//: "group": "Anisotropic"
//: }
uniform sampler2D _MaskMap;

//: param custom {
//: "default": 1.0,
//: "label": "anisotropicIntensity",
//: "min": 0.1,
//: "max": 10.0,
//: "group": "Anisotropic"
//: }
uniform float _AnisotropicIntensity;

//: param custom { "default": 1.0, 
//: "label": "anisotropicColor",
//: "widget": "color",
//: "group": "Anisotropic" 
//: }
uniform vec4 _AnisotropicColor;

//: param custom { "default": 1.0, 
//: "label": "anisotropicColor2",
//: "widget": "color",
//: "group": "Anisotropic" 
//: }
uniform vec4 _AnisotropicColor2;

//: param custom {
//: "default": 0.1,
//: "label": "Primary Specular Shift",
//: "min": -1.0,
//: "max": 1.0,
//: "group": "Anisotropic"
//: }
uniform float _SpecularShift;

//: param custom {
//: "default": 0.1,
//: "label": "Primary Specular Pos",
//: "min": -1.0,
//: "max": 1.0,
//: "group": "Anisotropic"
//: }
uniform float _SpecularPos;

//: param custom {
//: "default": 1.0,
//: "label": "Smoothness",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "Anisotropic"
//: }
uniform float _Smoothness;

//: param custom {
//: "default": 0.1,
//: "label": "Primary Specular Shift2",
//: "min": -1.0,
//: "max": 1.0,
//: "group": "Anisotropic"
//: }
uniform float _SpecularShift2;

//: param custom {
//: "default": 0.1,
//: "label": "Primary Specular Pos2",
//: "min": -1.0,
//: "max": 1.0,
//: "group": "Anisotropic"
//: }
uniform float _SpecularPos2;

//: param custom {
//: "default": 1.0,
//: "label": "Smoothness2",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "Anisotropic"
//: }
uniform float _Smoothness2;

//------------------------------------CLEARCOAT----------------------------------
//: param custom { 
//: "default": false,
//: "label": "Clear Coat",
//: "group": "CLEARCOAT"
//: }
uniform bool _CLEARCOATToggle;

//: param custom {
//: "default": 0.0,
//: "label": "Clearcoat Glossy",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "CLEARCOAT"
//: }
uniform float _ClearcoatGloss;

//: param custom {
//: "default": 0.0,
//: "label": "Clearcoat",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "CLEARCOAT"
//: }
uniform float _Clearcoat;

//------------------------------------SHEEN----------------------------------
//: param custom {
//: "default": 0.0,
//: "label": "Sheen(Cloth)",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "SHEEN"
//: }
uniform float _Sheen;

//: param custom {
//: "default": 0.5,
//: "label": "Sheen weight",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "SHEEN"
//: }
uniform float _SheenTint;

//------------------------------------DETAIL----------------------------------
//: param custom { 
//: "default": 0.5, 
//: "label": "Detail Normal Roughness Metallic Map",
//: "usage": "texture",
//: "group": "DETAIL"
//: }
uniform sampler2D _DetailBMRMap;

//: param custom{
//: "default": [1.0, 1.0, 0.0, 0.0],
//: "label": "Detail Normal Roughness Metallic Map Tilling and Offset",
//: "group": "DETAIL/Advanced"
//: }
uniform vec4 _DetailBMRMap_ST;

//: param custom {
//: "default": 1.0,
//: "label": "Detail Normal Intensity",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "DETAIL"
//: }
uniform float _DetailNormalIntensity;

//: param custom {
//: "default": 0.0,
//: "label": "Detail Metallic Intensityy",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "DETAIL"
//: }
uniform float _DetailMetallicIntensity;

//: param custom {
//: "default": 0.0,
//: "label": "Detail Roughness Intensity",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "DETAIL"
//: }
uniform float _DetailRoughnessIntensity;

//------------------------------------CUSTOM----------------------------------
//: param custom {
//: "default": 1.0,
//: "label": "Direct Light Intensity",
//: "min": 0.0,
//: "max": 3.0,
//: "group": "CUSTOM"
//: }
uniform float _DirectLightIntensity;

//: param custom {
//: "default": 1.0,
//: "label": "GI Intensity",
//: "min": 0.0,
//: "max": 3.0,
//: "group": "CUSTOM"
//: }
uniform float _GIIntensity;

//: param custom {
//: "default": 1.0,
//: "label": "Shadow Intensity",
//: "min": 0.0,
//: "max": 1.0,
//: "group": "CUSTOM"
//: }
uniform float _ShadowIntensity;

//------------------------------------FX/FX_ SPARKLE AND INVICIBLE----------------------------------
//: param custom {
//: "default": false,
//: "label": "Enable Sparkle and Invincible",
//: "group": "FX/FX_ SPARKLE AND INVICIBLE"
//: }
uniform bool _FXSparkInvincible_ON;

//: param custom { "default": 0.0, 
//: "label": "Spark FX",
//: "widget": "color",
//: "group": "FX/FX_ SPARKLE AND INVICIBLE" 
//: }
uniform vec4 _SparkleColor;

//: param custom {
//: "default": 0.0,
//: "label": "Spark FX Intensity",
//: "min": -10.0,
//: "max": 10.0,
//: "group": "FX/FX_ SPARKLE AND INVICIBLE"
//: }
uniform float _SparkleColor_HDR;

//: param custom {
//: "default": 10.0,
//: "label": "Spark Frequency",
//: "group": "FX/FX_ SPARKLE AND INVICIBLE"
//: }
uniform float _SparkleFrequency;

//: param custom { "default": 0.0, 
//: "label": "Invincible Color",
//: "widget": "color",
//: "group": "FX/FX_ SPARKLE AND INVICIBLE" 
//: }
uniform vec4 _InvincibleColor;

//: param custom {
//: "default": 0.0,
//: "label": "Invincible Color Intensity",
//: "min": -10.0,
//: "max": 10.0,
//: "group": "FX/FX_ SPARKLE AND INVICIBLE"
//: }
uniform float _InvincibleColor_HDR;

//: param custom {
//: "default": 4.5,
//: "label": "Invincible Scale",
//: "min": 0.0,
//: "max": 6.0,
//: "group": "FX/FX_ SPARKLE AND INVICIBLE"
//: }
uniform float _InvincibleScale;

//: param custom {
//: "default": 2.34,
//: "label": "Invincible Power",
//: "min": 0.0,
//: "max": 5.0,
//: "group": "FX/FX_ SPARKLE AND INVICIBLE"
//: }
uniform float _InvinciblePower;

//------------------------------------FX/FX_ DISSOLVE LINE----------------------------------
//: param custom {
//: "default": false,
//: "label": "Dissolve Toggle",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform bool _DissolveKey;

//: param custom { 
//: "default": 1.0, 
//: "label": "Dissolve Color",
//: "usage": "texture",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform sampler2D _DissolveTex;

//: param custom{
//: "default": [1.0, 1.0, 0.0, 0.0],
//: "label": "Dissolve Color Tilling and Offset",
//: "group": "FX/FX_ DISSOLVE LINE/Advanced"
//: }
uniform vec4 _DissolveTex_ST;

//: param custom { "default": [155.7486, 155.7486, 155.7486, 0.0], 
//: "label": "Dissolve Bright Line Color",
//: "widget": "color",
//: "group": "FX/FX_ DISSOLVE LINE" 
//: }
uniform vec4 _DissolveBrightLineColor;

//: param custom {
//: "default": 0.0,
//: "label": "Dissolve Bright Line Color Intensity",
//: "min": -10.0,
//: "max": 10.0,
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _DissolveBrightLineColor_HDR;


//: param custom { "default": [1011.953, 1011.953, 3067.984, 0.0], 
//: "label": "Dissolve Emissive Color",
//: "widget": "color",
//: "group": "FX/FX_ DISSOLVE LINE" 
//: }
uniform vec4 _DissolveEmissiveColor;

//: param custom {
//: "default": 0.0,
//: "label": "Dissolve Emissive Color Intensity",
//: "min": -10.0,
//: "max": 10.0,
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _DissolveEmissiveColor_HDR;

//: param custom {
//: "default": 5.0,
//: "label": "Mosaic X",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _Mosaic_X;

//: param custom {
//: "default": 2.0,
//: "label": "Mosaic Y",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _Mosaic_Y;

//: param custom {
//: "default": 1.17,
//: "label": "Scan Line",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _ScanLine;

//: param custom {
//: "default": 15.0,
//: "label": "Grid X",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _Grid_X;

//: param custom {
//: "default": 15.0,
//: "label": "Grid Y",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _Grid_Y;

//: param custom {
//: "default": 15.0,
//: "label": "Noise Scale",
//: "group": "FX/FX_ DISSOLVE LINE"
//: }
uniform float _SmallNoise;

//: param custom { 
//: "default": true,
//: "label": "Custom ACES",
//: "group": "ACES"
//: }
uniform bool _CustomACES;

//: param custom {
//: "default": 0.588,
//: "label": "A",
//: "group": "ACES"
//: }
uniform float T3_a;
//: param custom {
//: "default": 0.34,
//: "label": "B",
//: "group": "ACES"
//: }
uniform float T3_b;
//: param custom {
//: "default": 0.261,
//: "label": "C",
//: "group": "ACES"
//: }
uniform float T3_c;
//: param custom {
//: "default": 0.462,
//: "label": "D",
//: "group": "ACES"
//: }
uniform float T3_d;
//: param custom {
//: "default": 0.1,
//: "label": "E",
//: "group": "ACES"
//: }
uniform float T3_e;
//: param custom {
//: "default": 0.55,
//: "label": "F",
//: "group": "ACES"
//: }
uniform float T3_f;
//: param custom {
//: "default": 2.3,
//: "label": "whiteLevel",
//: "group": "ACES"
//: }
uniform float T3_whiteLevel;

//------------------------------Marcos-----------------------------------
#define CUSTOM_HALF_MAX        65504.0 // (2 - 2^-10) * 2^15
#define CUSTOM_HALF_MAX_MINUS1 65472.0 // (2 - 2^-9) * 2^15
#define CUSTOM_EPSILON         1.0e-4
#define PI              3.14159265358979323846
#define CUSTOM_PI              3.14159265358979323846
#define CUSTOM_TWO_PI          6.28318530717958647693
#define CUSTOM_FOUR_PI         12.5663706143591729538
#define CUSTOM_INV_PI          0.31830988618379067154
#define CUSTOM_INV_TWO_PI      0.15915494309189533577
#define CUSTOM_INV_FOUR_PI     0.07957747154594766788
#define CUSTOM_HALF_PI         1.57079632679489661923
#define CUSTOM_INV_HALF_PI     0.63661977236758134308
#define CUSTOM_LOG2_E          1.44269504088896340736
#define CUSTOM_GOLDEN_RATIO    1.618034
#define CUSTOM_GAMMA2LINEAR    2.2
#define CUSTOM_LINEAR2GAMMA    0.45454545454

#define FLT_INF                asfloat(0x7F800000)
#define FLT_EPS                5.960464478e-8  // 2^-24, machine epsilon: 1 + EPS = 1 (float of the ULP for 1.0f)
#define FLT_MIN                1.175494351e-38 // Minimum normalized positive floating-point number
#define FLT_MAX                3.402823466e+38 // Maximum representable floating-point number
#define HALF_EPS               4.8828125e-4    // 2^-11, machine epsilon: 1 + EPS = 1 (float of the ULP for 1.0f)
#define HALF_MIN               6.103515625e-5  // 2^-14, the same value for 10, 11 and 16-bit: https://www.khronos.org/opengl/wiki/Small_Float_Formats
#define HALF_MAX               65504.0
#define UINT_MAX               0xFFFFFFFFu

#define half float
#define half2 vec2
#define half3 vec3
#define half4 vec4
#define real float
#define real2 vec2
#define real3 vec3
#define real4 vec4
#define float2 vec2
#define float3 vec3
#define float4 vec4
#define SafeNormalize normalize
#define Normalize normalize
#define lerp mix
#define _WorldSpaceCameraPos camera_pos
#define inline
#define FLT_0 float(0.0)
#define FLT_1 float(1.0)
#define VEC2_0 vec2(0.0, 0.0)
#define VEC2_1 vec2(1.0, 1.0)
#define VEC3_0 vec3(0.0, 0.0, 0.0)
#define VEC3_1 vec3(1.0, 1.0, 1.0)
#define VEC4_0 vec4(0.0, 0.0, 0.0, 0.0)
#define VEC4_1 vec4(1.0, 1.0, 1.0, 1.0)
#define kDieletricSpec half4(0.04, 0.04, 0.04, 1.0 - 0.04) // standard dielectric reflectivity coef at incident angle (= 4%)


#define DelaySolution
// #define UNITY_GAMMA_LINEAR


// #define TEMPLATE_3_FLT(FunctionName, Parameter1, Parameter2, Parameter3, FunctionBody) \
//     float  FunctionName(float  Parameter1, float  Parameter2, float  Parameter3) { FunctionBody; } \
//     float2 FunctionName(float2 Parameter1, float2 Parameter2, float2 Parameter3) { FunctionBody; } \
//     float3 FunctionName(float3 Parameter1, float3 Parameter2, float3 Parameter3) { FunctionBody; } \
//     float4 FunctionName(float4 Parameter1, float4 Parameter2, float4 Parameter3) { FunctionBody; }

// #define TEMPLATE_3_REAL TEMPLATE_3_FLT

#define CONST_LIGHT_POS vec3(10.0, 10.0, 10.0)

struct Quaternion
{
  float w, x, y, z;
};

struct EulerAngles {
  float roll, pitch, yaw;
};

struct InputData{
  vec3  positionWS;
  vec3   normalWS;
  vec3   viewDirectionWS;
  vec4  shadowCoord;
  float    fogCoord;
  vec3   vertexLighting;
  vec3   bakedGI;
#if defined(LIGHTMAP_ON) && (defined(_XRP_SHADOWMASK) || defined(_XRP_COMPOSITE_SHADOWMASK))
	vec4   bakedAtten;
#endif
};

struct AnistroData {
  float null;
  #ifdef _ANISOTROPIC_ON
    #ifdef _UseDisneyAnistropic
      vec3 tangentWS;
      vec3 biTangentWS;
      float anisotropic;
  #elif defined (_UseKajiyaAnistropic)
      vec3 T1;
      vec3 T2;
      float perceptualRoughness;
      float perceptualRoughness2;
      vec3 anisotropicColor;
      vec3 anisotropicColor2;
      float anisotropicIntensity;
      float anisotropicMask;
    #endif
  #endif
};

struct ClearcoatData {
    vec3 normal;
    float clearcoat;
    float clearcoatGloss;
};

struct SubsurfaceData {
    float translucency;
    float transPower;
    vec3 color;
};

struct DBRDFData
{
    //vec3 diffuse;
    vec3 specular;
    float gi_grazingTerm;
    float perceptualRoughness;
    float roughness;
    float roughness2;

    vec3 albedo;
    float metallic;
    float sheen;
    float sheenTint;

    vec3 L;
    vec3 N;
    vec3 V;
    vec3 H;
    float NdotL;
    float NdotV;
    float NdotH;
    float LdotH;
    float LdotV;

    vec3 Fs;
    float FH;
};

struct Light{
  vec3   direction;
  vec3   color;
  float    distanceAttenuation;
  float    shadowAttenuation;
};

struct VRayMtlInitParams {
	vec3  Vw;
	vec3  geomNormal;
	vec3  diffuseColor;
	float diffuseAmount;
	float roughness;
	vec3  selfIllum;
	vec3  reflColor;
	float reflAmount;
	float reflGloss;
	bool  traceReflections;
	float metalness;
	float aniso;
	float anisoRotation;
	int   anisoAxis;
	vec3  opacity;
	vec3  refractionColor;
	float refractionAmount;
	float refrGloss;
	bool  traceRefractions;
	float refractionIOR;
	bool  useFresnel;
	float fresnelIOR;
	bool  lockFresnelIOR;
	bool  doubleSided;
	bool  useRoughness;
	float gtrGamma;
	int   brdfType;
	bool approxEnv;
};

struct VRayMtlContext {
	vec3  geomNormal;
	float gloss1;
	float gloss2;
	float reflGloss;
	vec3  e;
	vec3  diff;
	float fresnel;
	vec3  reflNoFresnel;
	vec3  refl;
	vec3  refr;
	vec3  illum;
	vec3  opacity;
	float rtermA;
	float rtermB;
	float gtrGamma;
	float blueNoise; // blue noise value based on fragment
	mat3  nm;
	mat3  inm;
};

//===================================Functions=======================================
//------------------------------------Utilities--------------------------------------
//gamma 2 linear
float gamma2Linear(float col){
  return pow(col, CUSTOM_GAMMA2LINEAR);
}
void gamma2Linear(inout vec4 col){
  col.r = pow(col.r, CUSTOM_GAMMA2LINEAR);
  col.g = pow(col.g, CUSTOM_GAMMA2LINEAR);
  col.b = pow(col.b, CUSTOM_GAMMA2LINEAR);
}
void gamma2Linear(inout vec3 col){
  col.r = pow(col.r, CUSTOM_GAMMA2LINEAR);
  col.g = pow(col.g, CUSTOM_GAMMA2LINEAR);
  col.b = pow(col.b, CUSTOM_GAMMA2LINEAR);
}

void linear2Gamma(inout vec4 col){
  col.r = pow(col.r, CUSTOM_LINEAR2GAMMA);
  col.g = pow(col.g, CUSTOM_LINEAR2GAMMA);
  col.b = pow(col.b, CUSTOM_LINEAR2GAMMA);
}

void linear2Gamma(inout vec3 col){
  col.r = pow(col.r, CUSTOM_LINEAR2GAMMA);
  col.g = pow(col.g, CUSTOM_LINEAR2GAMMA);
  col.b = pow(col.b, CUSTOM_LINEAR2GAMMA);
}

vec4 texture_2D(sampler2D map, vec2 texcoords){
  vec4 texColor = texture(map, texcoords);
#ifdef UNITY_GAMMA_LINEAR
  gamma2Linear(texColor);
  return texColor;
#else
  return sRGB2linear(texColor);
#endif
}

/// Sample texture and blend with default color where no data exists.
vec3 textureWithDefault(SamplerSparse sampler, SparseCoord coord, vec3 defaultColor) {
	vec4 sampledColor = textureSparse(sampler, coord);
	return sampledColor.rgb + (1.0 - sampledColor.a) * defaultColor;
}

/// Sample texture and blend with default value, treating green as alpha.
float textureWithDefault(SamplerSparse sampler, SparseCoord coord, float defaultValue) {
	vec4 sampledValue = textureSparse(sampler, coord);
	return sampledValue.r + (1.0 - sampledValue.g) * defaultValue;
}


// struct Angles{
//   Quaternion quaternion,
//   EulerAngles eulerAngles;
// }

float sqr(float x) { return x * x; }

float Atan2(float y, float x, int infNum)
{
  int i;
  float z = y / x, sum = 0.0f,temp;
  float del = z / infNum;
  
  for (i = 0; i < infNum;i++)
  {
    z = i * del;
    temp = 1 / (z*z + 1) * del;
    sum += temp;
  }
      
  if (x>0)
  {
    return sum;
  }
  else if (y >= 0 && x < 0)
  {
    return sum + CUSTOM_PI;
  }
  else if (y < 0 && x < 0)
  {
    return sum - CUSTOM_PI;
  }
  else if (y > 0 && x == 0)
  {
    return CUSTOM_PI / 2;
  }
  else if (y < 0 && x == 0)
  {
    return -1 * CUSTOM_PI / 2;
  }
  else
  {
    return 0;
  }
}

int ceil(float num) {
  int inum = int(num);
  if (num == float(inum)) {
      return inum;
  }
  return inum + 1;
}

/// <summary>Returns the reciprocal a float value.</summary>
float rcp(float x) { return 1.0 / x; }

Quaternion ToQuaternion(float yaw, float pitch, float roll) // yaw (Z), pitch (Y), roll (X)
{
  // Abbreviations for the various angular functions
  float cy = cos(yaw * 0.5);
  float sy = sin(yaw * 0.5);
  float cp = cos(pitch * 0.5);
  float sp = sin(pitch * 0.5);
  float cr = cos(roll * 0.5);
  float sr = sin(roll * 0.5);

  Quaternion q;
  q.w = cy * cp * cr + sy * sp * sr;
  q.x = cy * cp * sr - sy * sp * cr;
  q.y = sy * cp * sr + cy * sp * cr;
  q.z = sy * cp * cr - cy * sp * sr;

  return q;
}

EulerAngles ToEulerAngles(Quaternion q) {
  EulerAngles angles;

  // roll (x-axis rotation)
  float sinr_cosp = 2 * (q.w * q.x + q.y * q.z);
  float cosr_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
  angles.roll = Atan2(sinr_cosp, cosr_cosp, 5);

  // pitch (y-axis rotation)
  float sinp = 2 * (q.w * q.y - q.z * q.x);
  if (abs(sinp) >= 1)
      angles.pitch = M_PI / 2* sign(sinp); // use 90 degrees if out of range
  else
      angles.pitch = asin(sinp);

  // yaw (z-axis rotation)
  float siny_cosp = 2 * (q.w * q.z + q.x * q.y);
  float cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z);
  angles.yaw = Atan2(siny_cosp, cosy_cosp, 5);

  return angles;
}

vec3 ang2Rad(vec3 angle){
  return angle / 180.0 * CUSTOM_PI;
}

vec3 rad2Ang(vec3 radian){
  return radian / CUSTOM_PI * 180.0;
}

vec3 rot(vec3 dir, vec3 theta){
  mat3 Rx, Ry, Rz;
  theta = ang2Rad(theta);
  Rx[0] = vec3(1.0, 0.0, 0.0);
  Rx[1] = vec3(0.0, cos(theta.x), sin(theta.x));
  Rx[2] = vec3(0.0, -sin(theta.x), cos(theta.x));

  Ry[0] = vec3(-cos(theta.y), 0.0, -sin(theta.y));
  Ry[1] = vec3(0.0, 1.0, 0.0);
  Ry[2] = vec3(sin(theta.y), 0.0, -cos(theta.y));

  Rz[0] = vec3(cos(theta.z),  sin(theta.z), 0.0);
  Rz[1] = vec3(-sin(theta.z), cos(theta.z), 0.0);
  Rz[2] = vec3(0.0, 0.0, 1.0);

  return Rx * Ry * Rz * dir;
}

DBRDFData initDBRDFData(){
  DBRDFData brdfData;
  brdfData.specular = vec3(0.0, 0.0, 0.0);
  brdfData.gi_grazingTerm = 0.0;
  brdfData.perceptualRoughness = 0.0;
  brdfData.roughness = 0.0;
  brdfData.roughness2 = 0.0;
  brdfData.albedo = vec3(0.0, 0.0, 0.0);
  brdfData.metallic = 0.0;
  brdfData.sheen = 0.0;
  brdfData.sheenTint = 0.0;
  brdfData.L = vec3(0.0, 0.0, 0.0);
  brdfData.V = vec3(0.0, 0.0, 0.0);
  brdfData.N = vec3(0.0, 0.0, 0.0);
  brdfData.H = vec3(0.0, 0.0, 0.0);
  brdfData.NdotL = 0.0;
  brdfData.NdotV = 0.0;
  brdfData.NdotH = 0.0;
  brdfData.LdotH = 0.0;
  brdfData.LdotV = 0.0;
  brdfData.Fs = vec3(0.0, 0.0, 0.0);
  brdfData.FH = 0.0;
  return brdfData;
}

AnistroData initAnistroData(){
  AnistroData anistroData;
  #ifdef _ANISOTROPIC_ON
    anistroData.tangentWS = VEC3_0;
    anistroData.biTangentWS = VEC3_0;
    anistroData.anisotropic = FLT_0;
  #elif defined (_UseKajiyaAnistropic)
    anistroData.T1 = VEC3_0;
    anistroData.T2 = VEC3_0;
    anistroData.perceptualRoughness = FLT_0;
    anistroData.perceptualRoughness2 = FLT_0;
    anistroData.anisotropicColor = VEC3_0;
    anistroData.anisotropicColor2 = VEC3_0;
    anistroData.anisotropicIntensity = FLT_0;
    anistroData.anisotropicMask = FLT_0;
  #endif
  return anistroData;
}

ClearcoatData initClearcoatData(){
  ClearcoatData clearcoatData;
  clearcoatData.normal = VEC3_0;
  clearcoatData.clearcoat = FLT_0;
  clearcoatData.clearcoatGloss = FLT_0;
  return clearcoatData;
}

SubsurfaceData initSubsurfaceData(){
  SubsurfaceData subsurfaceData;
  subsurfaceData.translucency = FLT_0;
  subsurfaceData.transPower = FLT_0;
  subsurfaceData.color = VEC3_0;
  return subsurfaceData;
}

void setupInitParams(inout VRayMtlInitParams initParams, SparseCoord texCoord) {
	// Fetch material parameters
	vec3 baseColor = textureWithDefault(_MainTex_Sparse, texCoord, vec3(0.5));
	float roughness = textureWithDefault(_RoughnessTexture_Sparse, texCoord, 0.0);
	float metallic = textureWithDefault(_MetalTexture_Sparse, texCoord, 0.0);
	vec3 refractionColor = textureWithDefault(transmissive_tex, texCoord, vec3(0.0));
    // vec3 selfIllumColor = textureWithDefault(emissive_tex, texCoord, vec3(0.0));
    vec3 selfIllumColor = vec3(0.0);
    float anisotropy = textureWithDefault(anisotropylevel_tex, texCoord, 0.0);
    float anisotropyAngle = textureWithDefault(anisotropyangle_tex, texCoord, 0.0);

    initParams.diffuseColor = baseColor;
    initParams.roughness = roughness;
    initParams.selfIllum = selfIllumColor;
    initParams.reflColor = vec3(1.0);
    initParams.reflGloss = roughness;
    initParams.refractionColor = refractionColor;
    initParams.metalness = metallic;
    initParams.aniso = anisotropy;
    initParams.anisoRotation = anisotropyAngle;
    initParams.useRoughness = true;
}

float saturate(float n){
  return clamp(n, 0.0, 1.0);
}
vec2 saturate(vec2 n){
  return vec2(clamp(n.x, 0.0, 1.0), clamp(n.y, 0.0, 1.0));
}
vec3 saturate(vec3 n){
  return vec3(clamp(n.x, 0.0, 1.0), clamp(n.y, 0.0, 1.0), clamp(n.z, 0.0, 1.0));
}
vec4 saturate(vec4 n){
  return vec4(clamp(n.x, 0.0, 1.0), clamp(n.y, 0.0, 1.0), clamp(n.z, 0.0, 1.0), clamp(n.w, 0.0, 1.0));
}
// // [start, end] -> [0, 1] : (x - start) / (end - start) = x * rcpLength - (start * rcpLength)
// TEMPLATE_3_REAL(Remap01, x, rcpLength, startTimesRcpLength, return saturate(x * rcpLength - startTimesRcpLength))

// // [start, end] -> [1, 0] : (end - x) / (end - start) = (end * rcpLength) - x * rcpLength
// TEMPLATE_3_REAL(Remap10, x, rcpLength, endTimesRcpLength, return saturate(endTimesRcpLength - x * rcpLength))

real PerceptualSmoothnessToPerceptualRoughness(real perceptualSmoothness)
{
    return (1.0 - perceptualSmoothness);
}
real PerceptualRoughnessToRoughness(real perceptualRoughness)
{
    return perceptualRoughness * perceptualRoughness;
}
// smoothstep that assumes that 'x' lies within the [0, 1] interval.
real Smoothstep01(real x)
{
    return x * x * (3 - (2 * x));
}

real Smootherstep01(real x)
{
  return x * x * x * (x * (x * 6 - 15) + 10);
}

// real Smootherstep(real a, real b, real t)
// {
//     real r = rcp(b - a);
//     real x = Remap01(t, r, a * r);
//     return Smootherstep01(x);
// }

float3 NLerp(float3 A, float3 B, float t)
{
    return normalize(lerp(A, B, t));
}
float Length2(float3 v)
{
    return dot(v, v);
}
real Pow4(real x)
{
    return (x * x) * (x * x);
}

vec3 hdrColor(vec3 color, float intensity){
  float factor = pow(2.0, intensity);
  return vec3(color.r * factor, color.g * factor, color.b * factor);  
}

float vrayRand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float vraySqr(float x) {
	return x * x;
}

float pow35(float x) {
	return x * x * x * sqrt(x);
}

void vrayComputeTangentVectors(vec3 n, out vec3 u, out vec3 v) {
	// It doesn't matter what these vectors are, the result vectors just need to be perpendicular to the normal and to each other
	u = cross(n, vec3(0.643782, 0.98432, 0.324632));
	if (length(u) < 1e-6)
		u = cross(n, vec3(0.432902, 0.43223, 0.908953));
	u = normalize(u);
	v = normalize(cross(n, u));
}

void vrayMakeNormalMatrix(in vec3 n, out mat3 m) {
	vrayComputeTangentVectors(n, m[0], m[1]);
	m[2] = n;
}

float vrayGetFresnelCoeff(float fresnelIOR, vec3 e, vec3 n, vec3 refractDir) {
	if (abs(fresnelIOR - 1.0) < 1e-6)
		return 0.0;

	float cosIn = -dot(e, n);
	float cosR  = -dot(refractDir, n);

	if (cosIn > 1.0 - 1e-12 || cosR > 1.0 - 1e-12) { // View direction is perpendicular to the surface
		float f = (fresnelIOR - 1.0) / (fresnelIOR + 1.0);
		return f * f;
	}

	float ks  = (cosR / cosIn) * fresnelIOR;
	float fs2 = (ks - 1.0) / (ks + 1.0);
	float Fs  = fs2 * fs2;

	float kp  = (cosIn / cosR) * fresnelIOR;
	float fp2 = (kp - 1.0) / (kp + 1.0);
	float Fp  = fp2 * fp2;

	return 0.5 * (Fs + Fp);
}


/// Generate a random vec2, u in (0, 1), v in (B, B+1) where B is a fragment-dependent random blue noise value.
/// The returned value is suitable to be used for sampling a specular BRDF. V is
/// offset using blue noise, so it can be above 1, but that should be OK because
/// it is expected to be used as the argument to a trigonometric function.
vec2 uvRand(VRayMtlContext ctx, int sampleIdx) {
	// plastic constant
	// gives slightly better result than golden ratio
	float plast = 1.324717957244746;
	float invPlast = 1.0/plast;
	return vec2(
			fract(float(sampleIdx + 1) * invPlast),
			float(sampleIdx) / float(nbSamples) + ctx.blueNoise
			);
}

// Functions from lib-pbr we need to sample the environment properly {{{

// /// Compute the inverse of the solid angle of the differential pixel in the
// /// cube map pointed at by Wn
// /// @param Wn World-space direction
// float distortion(vec3 Wn) {
// 	float sinT = sqrt(1.0-Wn.y*Wn.y);
// 	return sinT;
// }

/// Get the LOD for sampling the environment
/// @param Wn World-space normal
/// @param p Probability of this direction (from sampleBRDF)
/// @param numSamples Total number of samples
float computeLOD(vec3 Wn, float p, int numSamples) {
	if (numSamples < 2) {
		return 0.0;
	} else {
		return max(0.0, maxLod - 1.5 - 0.5 * log2(1.0 + float(numSamples) * p * distortion(Wn)));
	}
}

// }}} End functions from lib-pbr


//---------------------------------------------Lighting----------------------------------------------------

vec3 SetL(vec3 position){
  vec3 light_pos = vec3(0.0, 0.0, 1.0);
  if(LightType == 0){
    light_pos = CONST_LIGHT_POS;
    return normalize(light_pos - position);
  }else if(LightType == 1){
    return normalize(rot(light_pos, customLightRot));
  }else{
    light_pos = vec3(10 * cos(environment_rotation * 2.0 * CUSTOM_PI) , 10.0 , 10.0 * sin(environment_rotation * 2.0 * CUSTOM_PI));
    return normalize(light_pos - position);
  }
}

float GetD (float nh, float roughness){
    float a2 = roughness * roughness;
    float d = (nh * a2 - nh) * nh + 1.0f; // 2 mad
    return CUSTOM_INV_PI * a2 / (d * d);                                             
}
vec3 GetF (vec3 specColor, vec3 diffColor, float roughness, float metallic, float vh){
    vec3 F0 = mix(specColor, diffColor, metallic);
    vec3 F = F0 + (1 - F0) * pow(1 - vh, 5);
    return F;                                             
}
float GetG(float roughness, float nv, float nl){
    float a =((roughness + 1) / 2) * ((roughness + 1) / 2);
    float k = a * 0.5;
    float G1 = nv / (nv * (1 - k) + k);
    float G2 = nl / (nl * (1 - k) + k);
    float G = G1 * G2;
    return G;
}
vec3 fresnelShchlivk(float nv, vec3 F0, float roughness){
    return F0 + (max(vec3(1 - roughness, 1 - roughness, 1 - roughness), F0) - F0) * pow(1 - nv, 5);
}
vec3 FresnelMix (vec3 F0, vec3 F90, float nv){
    float t = pow((1 - nv),5);   // ala Schlick interpoliation
    return mix (F0, F90, t);
}


Light GetMainLight(vec3 position){
  Light light;
  light.direction = SetL(position);
  // unity_LightData.z is 1 when not culled by the culling mask, otherwise 0.
  // light.distanceAttenuation = unity_LightData.z;
  light.distanceAttenuation = 1.0;
#if defined(LIGHTMAP_ON) || defined(_MIXED_LIGHTING_SUBTRACTIVE)
  // unity_ProbesOcclusion.x is the mixed light probe occlusion data
  light.distanceAttenuation *= unity_ProbesOcclusion.x;
#endif
  light.shadowAttenuation = 1.0;
  light.color = lightColor.rgb;

  return light;
}

#if defined(DelaySolution)
Light GetMainLight(float4 shadowCoord, vec3 position){
  Light light = GetMainLight(position);
  light.shadowAttenuation = 1.0;
  return light;
}
#else
Light GetMainLight(float4 shadowCoord, vec3 position){
  Light light = GetMainLight(position);
  Light.shadowAttenuation = MainLightRealtimeShadow(shadowCoord);
  return light;
}
#endif

half OneMinusReflectivityMetallic(half metallic)
{
    // We'll need oneMinusReflectivity, so
    //   1-reflectivity = 1-lerp(dielectricSpec, 1, metallic) = lerp(1-dielectricSpec, 0, metallic)
    // store (1-dielectricSpec) in kDieletricSpec.a, then
    //   1-reflectivity = lerp(alpha, 0, metallic) = alpha + metallic*(0 - alpha) =
    //                  = alpha - metallic * alpha
    half oneMinusDielectricSpec = kDieletricSpec.a;
    return oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
}

vec3 vrayGetGTR1MicroNormal(float uc, float vc, float sharpness) {
	float sharpness2  = min(sharpness * sharpness, 0.999);
	float thetaCosSqr = (1.0 - pow(sharpness2, 1.0 - uc)) / (1.0 - sharpness2);
	float thetaCos    = sqrt(thetaCosSqr);
	float thetaSin    = sqrt(max(1.0 - thetaCosSqr, 0.0));

	float phi = 2.0 * PI * vc;
	return vec3(cos(phi) * thetaSin, sin(phi) * thetaSin, thetaCos);
}

// Specific implementation when gamma == 2. See section B.2 Physically-Based Shading at Disney from SIGGRAPH 2012
vec3 vrayGetGTR2MicroNormal(float uc, float vc, float sharpness) {
    //vrayDebug(sharpness);
	float thetaCosSqr = (1.0 - uc) / (1.0 + (sharpness * sharpness - 1.0) * uc);
	float thetaCos    = sqrt(thetaCosSqr);
	float thetaSin    = sqrt(max(1.0 - thetaCosSqr, 0.0));

	float phi = 2.0 * PI * vc;
	return vec3(cos(phi) * thetaSin, sin(phi) * thetaSin, thetaCos);
}

// // General implementation  when gamma != 1 and != 2. See section B.2 Physically-Based Shading at Disney from SIGGRAPH 2012
vec3 vrayGetGTRMicroNormal(float uc, float vc, float sharpness, float gtrGamma) {
	float sharpness2  = min(sharpness * sharpness, 0.999);
	float thetaCosSqr = (1.0 - pow(pow(sharpness2, 1.0 - gtrGamma) * (1.0 - uc) + uc, 1.0 / (1.0 - gtrGamma))) / (1.0 - sharpness2);
	float thetaCos    = sqrt(thetaCosSqr);
	float thetaSin    = sqrt(max(1.0 - thetaCosSqr, 0.0));

	float phi = 2.0 * PI * vc;
	return vec3(cos(phi) * thetaSin, sin(phi) * thetaSin, thetaCos);
}
vec3 vrayGetGGXMicroNormal(float uc, float vc, float sharpness, float gtrGamma) {
	if (abs(gtrGamma - 1.0) < 1e-3)
		return vrayGetGTR1MicroNormal(uc, vc, sharpness);
	else if (abs(gtrGamma - 2.0) < 1e-3)
		return vrayGetGTR2MicroNormal(uc, vc, sharpness);
	else // if (gtrLowerLimit <= gtrGamma && gtrGamma <= gtrUpperLimit)
		return vrayGetGTRMicroNormal(uc, vc, sharpness, gtrGamma);
}
float vrayGetGTR1MicrofacetDistribution(float mz, float sharpness) {
	float cosThetaM = mz; // dotf(microNormal, normal);
	if (cosThetaM <= 1e-3)
		return 0.0;

	float cosThetaM2 = vraySqr(cosThetaM);
	float tanThetaM2 = (1.0 / cosThetaM2) - 1.0;
	float sharpness2 = vraySqr(sharpness);
	float div        = PI * log(sharpness2) * cosThetaM2 * (sharpness2 + tanThetaM2);
	// when div<(sharpness2-1.0f)*1e-6f no division by zero will occur (the dividend and the divisor are always negative);
	// div can get 0 in rare situation when the sharpness read from texture mapped in reflection glossines is 0
	// and cosThetaM is 1 (and consequently tanThetaM2 is 0);
	float res = (div < (sharpness2 - 1.0) * 1e-6) ? (sharpness2 - 1.0) / div : 0.0;

	return res;
}

float vrayGetGTR2MicrofacetDistribution(float mz, float sharpness) {
	float cosThetaM = mz; // dotf(microNormal, normal);
	if (cosThetaM <= 1e-3f)
		return 0.0f;

	float cosThetaM2 = vraySqr(cosThetaM);
	float tanThetaM2 = (1.0 / cosThetaM2) - 1.0;
	float sharpness2 = vraySqr(sharpness);
	float div        = PI * vraySqr(cosThetaM2 * (sharpness2 + tanThetaM2));
	// when div>sharpness2*1e-6f no division by zero will occur (the dividend and the divisor are always positive);
	// div canget0 in rare situation when the sharpness read from texture mapped in reflection glossines is 0
	// and cosThetaM is 1 (and consequently tanThetaM2 is 0);
	float res = (div > sharpness2 * 1e-6) ? sharpness2 / div : 0.0;

	return res;
}

float vrayGetGTRMicrofacetDistribution(float mz, float sharpness, float gtrGamma) {
	float cosThetaM = mz; // dotf(microNormal, normal);
	if (cosThetaM <= 1e-3)
		return 0.0;

	float cosThetaM2 = vraySqr(cosThetaM);
	float tanThetaM2 = (1.0 / cosThetaM2) - 1.0;
	float sharpness2 = vraySqr(sharpness);
	float divisor    = PI * (1.0 - pow(sharpness2, 1.0 - gtrGamma)) * pow(cosThetaM2 * (sharpness2 + tanThetaM2), gtrGamma);
	float dividend   = (gtrGamma - 1.0) * (sharpness2 - 1.0);
	// when fabsf(divisor)>fabsf(dividend)*1e-6f no division by zero will occur
	// (the dividend and the divisor are always either both positive or both negative);
	// divisor canget0 in rare situation when the sharpness read from texture mapped in reflection glossines is 0
	// and cosThetaM is 1 (and consequently tanThetaM2 is 0);
	float res = (abs(divisor) > abs(dividend) * 1e-6) ? dividend / divisor : 0.0;

	return res;
}

float vrayGetGGXMicrofacetDistribution(float cosNH, float sharpness, float gtrGamma) {
	if (abs(gtrGamma - 1.0) < 1e-3)
		return vrayGetGTR1MicrofacetDistribution(cosNH, sharpness);
	else if (abs(gtrGamma - 2.0) < 1e-3)
		return vrayGetGTR2MicrofacetDistribution(cosNH, sharpness);
	else // if (gtrLowerLimit <= gtrGamma && gtrGamma <= gtrUpperLimit)
		return vrayGetGTRMicrofacetDistribution(cosNH, sharpness, gtrGamma);
}

float vrayGetGTRMonodirectionalShadowing0(float cotThetaV) {
	return 2.0 / (1.0 + sqrt(1.0 + 1.0 / (cotThetaV * cotThetaV)));
}

float vrayGetGTRMonodirectionalShadowing1(float sharpness, float cotThetaV) {
	float cotThetaV2 = vraySqr(cotThetaV);
	float sharpness2 = min(0.999, vraySqr(sharpness));
	float a          = sqrt(cotThetaV2 + sharpness2);
	float b          = sqrt(cotThetaV2 + 1.0);
	return cotThetaV * log(sharpness2) / (a - b + cotThetaV * log(sharpness2 * (cotThetaV + b) / (cotThetaV + a)));
}

float vrayGetGTRMonodirectionalShadowing2(float sharpness, float cotThetaV) {
	return 2.0 / (1.0 + sqrt(1.0 + vraySqr(sharpness / cotThetaV)));
}

float vrayGetGTRMonodirectionalShadowing3(float sharpness, float cotThetaV) {
	float cotThetaV2 = vraySqr(cotThetaV);
	float sharpness2 = min(0.999, vraySqr(sharpness));
	float a          = sqrt(cotThetaV2 + sharpness2);
	float b          = sharpness2 + 1.0;
	return 4.0 * cotThetaV * a * b / (2.0 * cotThetaV * b * (cotThetaV + a) + sharpness2 * (3.0 * sharpness2 + 1.0));
}

float vrayGetGTRMonodirectionalShadowing4(float sharpness, float cotThetaV) {
	float cotThetaV2 = cotThetaV * cotThetaV;
	float sharpness2 = min(0.999, vraySqr(sharpness));
	float sharpness4 = sharpness2 * sharpness2;
	float a          = 8.0 * (sharpness4 + sharpness2 + 1.0);
	float b          = sqrt(cotThetaV2 + sharpness2);
	float b3         = b * (cotThetaV2 + sharpness2);
	return 2.0 * cotThetaV * a * b3 / (a * cotThetaV * (b3 + cotThetaV * cotThetaV2) + 3.0 * sharpness2 * (4.0 * cotThetaV2 * (2.0 * sharpness4 + sharpness2 + 1.0) + sharpness2 * (5.0 * sharpness4 + 2.0 * sharpness2 + 1.0)));
}

float vrayGetGTRMonodirectionalShadowingSpline(float gtrGamma, float sharpness, float cotThetaV) {
	const int numKnots = 5;

	float knots[numKnots];
	knots[0] = vrayGetGTRMonodirectionalShadowing0(cotThetaV);
	knots[1] = vrayGetGTRMonodirectionalShadowing1(sharpness, cotThetaV);
	knots[2] = vrayGetGTRMonodirectionalShadowing2(sharpness, cotThetaV);
	knots[3] = vrayGetGTRMonodirectionalShadowing3(sharpness, cotThetaV);
	knots[4] = vrayGetGTRMonodirectionalShadowing4(sharpness, cotThetaV);

	float m[numKnots];
	float c[numKnots];
	for (int i = 1; i < numKnots - 1; i++) {
		m[i]     = 4.0;
		c[i - 1] = 6.0 * (knots[i + 1] - 2.0 * knots[i] + knots[i - 1]);
	}

	// solve tridiagonal
	for (int i = 1; i < numKnots - 2; i++) {
		float x = 1.0 / m[i];
		m[i + 1] -= x;
		c[i] -= x * c[i - 1];
	}

	m[numKnots - 2] = c[numKnots - 3] / m[numKnots - 2];

	for (int i = numKnots - 4; i >= 0; i--) {
		m[i + 1] = (c[i] - m[i + 2]) / m[i + 1];
	}

	m[0]            = 0.0;
	m[numKnots - 1] = 0.0;

	// contstruct polynomials
	vec4 polys[numKnots - 1];
	for (int i = 0; i < numKnots - 1; i++) {
		polys[i].x = (m[i + 1] - m[i]) / 6.0;
		polys[i].y = 0.5 * m[i];
		polys[i].z = (knots[i + 1] - knots[i]) - (2.0 * m[i] + m[i + 1]) / 6.0;
		polys[i].w = knots[i];
	}

	// eval
	float gamma = clamp(gtrGamma, 0.0, 4.0);
	int   idx   = int(floor(gtrGamma));
	float x     = gtrGamma - float(idx);
	float v     = ((polys[idx].x * x + polys[idx].y) * x + polys[idx].z) * x + polys[idx].w;
	return v;
}

float vrayGetGGXMonodirectionalShadowing(vec3 dir, vec3 hw, vec3 normal, float sharpness, float gtrGamma) {
	float cosThetaV = dot(dir, normal);

	if (cosThetaV <= 1e-3)
		return 0.0;

	if (dot(dir, hw) * cosThetaV <= 0.0) // Note: technically this is a division, but since we are only interested in the sign, we can do multiplication
		return 0.0;

	// when direction is collinear to the normal there is no shadowing
	// moreover if this case is not handled a division by zero will happen on the next line
	if (cosThetaV >= 1.0 - 1e-6)
		return 1.0;

	float cotThetaV = cosThetaV / sqrt(1.0 - vraySqr(cosThetaV));

	float res = 0.0;

	// when gamma is any of the integer values 0, 1, 2, 3, 4 apply analytical solution
	if (gtrGamma <= 0.01)
		res = vrayGetGTRMonodirectionalShadowing0(cotThetaV);
	else if (abs(gtrGamma - 1.0) <= 1e-2)
		res = vrayGetGTRMonodirectionalShadowing1(sharpness, cotThetaV);
	else if (abs(gtrGamma - 2.0) <= 1e-2)
		res = vrayGetGTRMonodirectionalShadowing2(sharpness, cotThetaV);
	else if (abs(gtrGamma - 3.0) <= 1e-2)
		res = vrayGetGTRMonodirectionalShadowing3(sharpness, cotThetaV);
	else if (gtrGamma >= 4.0 - 1e-2)
		res = vrayGetGTRMonodirectionalShadowing4(sharpness, cotThetaV);
	else {
		// gamma is not an integer. interpolate
		res = vrayGetGTRMonodirectionalShadowingSpline(gtrGamma, sharpness, cotThetaV);
	}

	return clamp(res, 0.0, 1.0);
}

float vrayGetGGXBidirectionalShadowingMasking(vec3 view, vec3 dir, vec3 hw, vec3 normal, float sharpness, float gtrGamma) {
	return vrayGetGGXMonodirectionalShadowing(view, hw, normal, sharpness, gtrGamma) * vrayGetGGXMonodirectionalShadowing(dir, hw, normal, sharpness, gtrGamma);
}

float vrayGetGGXContribution(vec3 view, vec3 dir, vec3 hw, vec3 hl, float sharpness, float gtrGamma, vec3 normal, out float partialProb, out float D) {
	float cosIN = abs(dot(view, normal));
	float cosON = abs(dot(dir, normal));

	if (cosIN <= 1e-6 || cosON <= 1e-6)
		return 0.0;

	float partialBrdf = 0.0;

	float hn    = hl.z;
	D           = vrayGetGGXMicrofacetDistribution(hn, sharpness, gtrGamma);
	partialBrdf = 0.25 * vrayGetGGXBidirectionalShadowingMasking(view, dir, hw, normal, sharpness, gtrGamma) / cosIN; // division by cosON is omitted because we would have to multiply by the same below;

	if (hn > 0.0) {
		partialProb = hn;

		float ho = dot(hw, dir);
		partialProb *= ho > 0.0 ? 0.25 / ho : 0.0;
	}

	// reduce some multiplications in the final version
	// partialBrdf *= cosON; - omitted

	return partialBrdf;
}
vec3 vrayGetGGXDir(float u, float v, float sharpness, float gtrGamma, vec3 view, mat3 nm, out float prob, out float brdfDivByProb) {
	vec3 microNormalLocal = vrayGetGGXMicroNormal(u, v, sharpness, gtrGamma);
    //vrayDebug(microNormalLocal * 0.5 + vec3(0.5));
	if (microNormalLocal.z < 0.0)
		return nm[2];

	vec3 microNormal = nm * microNormalLocal;

	// Compute and keep the length of the half-vector in local space; needed for anisotropy correction
	float L2 = dot(microNormal, microNormal);
	float L  = sqrt(L2);
	microNormal /= L;

	vec3 dir = reflect(-view, microNormal);

	float Dval        = 0.0;
	float partialProb = 0.0;
	float partialBrdf = vrayGetGGXContribution(view, dir, microNormal, microNormalLocal, sharpness, gtrGamma, nm[2], partialProb, Dval);
	partialProb *= L * L2;                                                 // take anisotropy in consideration
	prob          = (Dval >= 1e-6) ? partialProb * Dval : 1e18; // compute full probability
	// note: in the full VRayMtl prob is multiplied by 2PI, but in this shader
	// it's used exclusively to sample tne environment map, and we would have
	// to divide by 2PI in that computation.
	brdfDivByProb = (partialProb >= 1e-6) ? partialBrdf / partialProb : 0.0;
	return dir;
}

vec3 vraySampleBRDF(VRayMtlInitParams params, VRayMtlContext ctx, int sampleIdx, out float rayProb, out float brdfContrib) {
	vec3  geomNormal = params.geomNormal;
	vec2  uv = uvRand(ctx, sampleIdx);
	float u = uv.x;
	float v = uv.y;

	vec3  dir     = vec3(0.0);
	rayProb = 1.0;
	brdfContrib = 1.0;

  dir = vrayGetGGXDir(u, v, ctx.gloss2, ctx.gtrGamma, -ctx.e, ctx.nm, rayProb, brdfContrib);

	if (dot(dir, geomNormal) < 0.0f) {
		brdfContrib = 0.0;
	}
	return dir;
}

VRayMtlContext initVRayMtlContext(VRayMtlInitParams initParams) {
	float reflGloss        = initParams.reflGloss;
	vec3  Vw               = initParams.Vw;
	vec3  geomNormal       = initParams.geomNormal;
	vec3  selfIllum        = initParams.selfIllum;
	vec3  diffuseColor     = initParams.diffuseColor;
	float diffuseAmount    = initParams.diffuseAmount;
	vec3  reflColor        = initParams.reflColor;
	float reflAmount       = initParams.reflAmount;
	bool  traceReflections = initParams.traceReflections;
	float metalness        = initParams.metalness;
	float aniso            = initParams.aniso;
	float anisoRotation    = initParams.anisoRotation;
	int   anisoAxis        = initParams.anisoAxis;
	vec3  opacity          = initParams.opacity;
	float roughness        = initParams.roughness;
	vec3  refractionColor  = initParams.refractionColor;
	float refractionAmount = initParams.refractionAmount;
	bool  traceRefractions = initParams.traceRefractions;
	float refractionIOR    = initParams.refractionIOR;
	bool  useFresnel       = initParams.useFresnel;
	float fresnelIOR       = initParams.fresnelIOR;
	bool  lockFresnelIOR   = initParams.lockFresnelIOR;
	bool  doubleSided      = initParams.doubleSided;
	bool  useRoughness     = initParams.useRoughness;
	float gtrGamma         = initParams.gtrGamma;
	int   brdfType         = initParams.brdfType;

	VRayMtlContext result;
	if (initParams.lockFresnelIOR)
		fresnelIOR = initParams.refractionIOR;

	result.e = -normalize(Vw);
	if (useRoughness)
		reflGloss = 1.0 - reflGloss; // Invert glossiness (turn it into roughness)

	result.reflGloss = reflGloss;
	result.opacity   = opacity;
	result.diff      = diffuseColor * diffuseAmount * result.opacity;
	result.illum     = selfIllum * result.opacity;
	// roughness
	float sqrRough = roughness * roughness;
	result.rtermA  = 1.0 - 0.5 * (sqrRough / (sqrRough + 0.33));
	result.rtermB  = 0.45 * (sqrRough / (sqrRough + 0.09));

	if (doubleSided && dot(geomNormal, result.e) > 0.0)
		geomNormal = -geomNormal;

	vec3 reflectDir   = reflect(result.e, geomNormal);
	result.geomNormal = geomNormal;

	// check for internal reflection
	bool  internalReflection;
	vec3  refractDir;
	bool  outToIn = (dot(geomNormal, result.e) < 0.0);
	float ior     = (outToIn ? 1.0 / refractionIOR : refractionIOR);
	vec3  normal  = (outToIn ? geomNormal : -geomNormal);

	float cost    = -dot(result.e, normal);
	float sintSqr = 1.0 - ior * ior * (1.0 - cost * cost);
	if (sintSqr > 1e-6) {
		internalReflection = false;
		refractDir         = ior * result.e + (ior * cost - sqrt(sintSqr)) * normal;
	} else {
		internalReflection = true;
		refractDir         = reflectDir;
	}
	result.fresnel = 1.0;
	if (useFresnel && !internalReflection)
		result.fresnel = clamp(vrayGetFresnelCoeff(fresnelIOR, result.e, normal, refractDir), 0.0, 1.0);
	//vrayDebug(result.fresnel);

	result.reflNoFresnel = reflColor * reflAmount * result.opacity;
	result.refl          = result.reflNoFresnel * result.fresnel;

	// Reflection calculation including metalness. Taken from VRayMtl's original implementation.
	vec3 metalColor = result.diff * result.fresnel * metalness;

	vec3 dielectricReflectionTransparency = traceReflections ? (1.0 - result.refl) : vec3(1.0);
	vec3 reflectionTransparency           = (1.0 - metalness) * dielectricReflectionTransparency;
	if (traceRefractions) {
		result.refr = refractionColor * refractionAmount * result.opacity * reflectionTransparency;
	} else {
		result.refr = vec3(0.0);
	}
	result.diff *= reflectionTransparency - result.refr;

	result.refl = mix(metalColor, result.refl, result.fresnel);
	if (result.fresnel > 1e-6) {
		result.refl /= result.fresnel;
	}

	result.gloss1 = max(0.0, 1.0 / pow35(max(1.0 - reflGloss, 1e-4)) - 1.0); // [0, 1] -> [0, inf)
	result.gloss2 = max(1.0 - reflGloss, 1e-4);
	result.gloss2 *= result.gloss2;
	result.gtrGamma = gtrGamma;
	result.blueNoise = getBlueNoiseThresholdTemporal();

	// Set up the normal/inverse normal matrices for BRDFs that support anisotropy
	vec3 anisoDirection = vec3(0.0, 0.0, 1.0);
	if (anisoAxis == 0)
		anisoDirection = vec3(1.0, 0.0, 0.0);
	else if (anisoAxis == 1)
		anisoDirection = vec3(0.0, 1.0, 0.0);
	float anisoAbs = abs(aniso);
	if (anisoAbs < 1e-12 || anisoAbs >= 1.0 - 1e-6) {
		vrayMakeNormalMatrix(geomNormal, result.nm);
		result.inm = transpose(result.nm); // inverse = transpose for orthogonal matrix
	} else if (!internalReflection) {
		vec3 base0, base1;
		base0        = normalize(cross(geomNormal, anisoDirection));
		base1        = normalize(cross(base0, geomNormal));
		float anisor = anisoRotation * 6.2831853;
		if (abs(anisor) > 1e-6) {
			float cs = cos(anisor);
			float sn = sin(anisor);
			vec3  nu = base0 * cs - base1 * sn;
			vec3  nv = base0 * sn + base1 * cs;
			base0    = nu;
			base1    = nv;
		}

		if (length(cross(base0, base1)) < 1e-6)
			vrayComputeTangentVectors(geomNormal, base0, base1);
		if (aniso > 0.0) {
			float a = 1.0 / (1.0 - aniso);
			base0 *= a;
			base1 /= a;
		} else {
			float a = 1.0 / (1.0 + aniso);
			base0 /= a;
			base1 *= a;
		}
		result.nm[0] = base0;
		result.nm[1] = base1;
		result.nm[2] = geomNormal;
		result.inm   = inverse(result.nm);
	}

	return result;
}

#if defined(DelaySolution)
//vrayComputeIndirectReflectionContribution
half3 GlossyEnvironmentReflection(VRayMtlInitParams params, VRayMtlContext ctx)
{
	vec3 res = vec3(0.0);

	// if (!params.traceReflections)
	// 	return res;

	float invNumSamples = 1.0f / float(nbSamples);
	vec3 envSum = vec3(0.0);
	for (int i = 0; i < nbSamples; ++i) {
		float brdfContrib = 0.0f;
		float rayProb     = 0.0f;
		vec3  dir         = vraySampleBRDF(params, ctx, i, rayProb, brdfContrib);
		if (brdfContrib < 1e-6f)
			continue;
		float lod = computeLOD(dir, rayProb, nbSamples);
		envSum += envSampleLOD(dir, lod) * brdfContrib;
	}
	res += envSum * invNumSamples;

	return res;
}
#else
half3 GlossyEnvironmentReflection(half3 reflectVector, half perceptualRoughness, half occlusion)
{
#if !defined(_ENVIRONMENTREFLECTIONS_OFF)
    half mip = PerceptualRoughnessToMipmapLevel(perceptualRoughness);
    half4 encodedIrradiance = texture_2D(unity_SpecCube0, reflectVector);

#if !defined(UNITY_USE_NATIVE_HDR)
    half3 irradiance = DecodeHDREnvironment(encodedIrradiance, unity_SpecCube0_HDR);
#else
    half3 irradiance = encodedIrradiance.rbg;
#endif
    return irradiance * occlusion;
#endif // GLOSSY_REFLECTIONS
    return _GlossyEnvironmentColor.rgb * occlusion;
}
#endif
//----------------------------------------------DisneyLighting----------------------------------------------
float SchlickFresnel(float u)
{
    float m = clamp(1 - u, 0, 1);
    float m2 = m * m;
    return m2 * m2 * m; // pow(m,5)
}

float GTR1(float NdotH, float a)
{
    if (a >= 1) return 1 / CUSTOM_PI;
    float a2 = a * a;
    float t = 1 + (a2 - 1) * NdotH * NdotH;
    return (a2 - 1) / (CUSTOM_PI * log(a2) * t);
}

float GTR2(float NdotH, float a)
{
    float a2 = a * a;
    float t = 1 + (a2 - 1) * NdotH * NdotH;
    return (HALF_MIN + a2) / (CUSTOM_PI * t * t);
}

float GTR2_aniso(float NdotH, float HdotX, float HdotY, float ax, float ay)
{
    return 1 / (CUSTOM_PI * ax * ay * sqr(sqr(HdotX / ax) + sqr(HdotY / ay) + NdotH * NdotH));
}

float smithG_GGX(float NdotV, float alphaG)
{
    float a = alphaG * alphaG;
    float b = NdotV * NdotV;
    return 1 / (NdotV + sqrt(a + b - a * b));
}

float smithG_GGX_aniso(float NdotV, float VdotX, float VdotY, float ax, float ay)
{
    return 1 / (NdotV + sqrt(sqr(VdotX * ax) + sqr(VdotY * ay) + sqr(NdotV)));
}

vec3 mon2lin(vec3 x)
{
    return vec3(pow(x[0], 2.2), pow(x[1], 2.2), pow(x[2], 2.2));
}

float RoughnessToBlinnPhongSpecularExponent(float roughness)
{
    return clamp(2 * rcp(roughness * roughness) - 2, FLT_EPS, rcp(FLT_EPS));//FLT_EPS  5.960464478e-8  // 2^-24, machine epsilon: 1 + EPS = 1 (float of the ULP for 1.0f)
}
//http://web.engr.oregonstate.edu/~mjb/cs519/Projects/Papers/HairRendering.pdf
vec3 ShiftTangentX(vec3 T, vec3 N, float shift)
{
    return normalize(T + N * shift);
}

// Note: this is Blinn-Phong, the original paper uses Phong.
float KajiyaKay(vec3 T, vec3 H, float specularExponent)
{
    float TdotH = dot(T, H);
    // float sinTHSq = saturate(1.0 - TdotH * TdotH);

    // float dirAttn = saturate(TdotH + 1.0); // Evgenii: this seems like a hack? Do we really need this?

    // float n    = specularExponent;
    // float norm = (n + 2) * rcp(2 * CUSTOM_PI);

    // return dirAttn * norm * PositivePow(sinTHSq, 0.5 * n);
    float sinTH = sqrt(1.0 - TdotH*TdotH);
    float dirAtten = smoothstep(-1, 0, dot(T, H));

    return dirAtten * pow(sinTH, specularExponent);
}

vec3 DirectSpecular(AnistroData anistroData, DBRDFData brdfData) {
    vec3 L = brdfData.L;
    vec3 V = brdfData.V;
    vec3 H = brdfData.H;
    float NdotH = brdfData.NdotH;
    float NdotL = brdfData.NdotL;
    float NdotV = brdfData.NdotV;
    float roughness = brdfData.roughness;
    vec3 Fs = brdfData.Fs;

    #ifdef _ANISOTROPIC_ON
        #ifdef _UseDisneyAnistropic
            float aspect = sqrt(1 - anistroData.anisotropic * .9);
            float ax = max(.001, sqr(roughness) / aspect);
            float ay = max(.001, sqr(roughness) * aspect);
            float Ds = GTR2_aniso(NdotH, dot(H, anistroData.tangentWS), dot(H, anistroData.biTangentWS), ax, ay);
            float Gs = smithG_GGX_aniso(NdotL, dot(L, anistroData.tangentWS), dot(L, anistroData.biTangentWS), ax, ay);
            Gs *= smithG_GGX_aniso(NdotV, dot(V, anistroData.tangentWS), dot(V, anistroData.biTangentWS), ax, ay);
            Ds = min(Ds, 1e+2);
            Gs = min(Gs, 1e+2);
            return Gs * Fs * Ds;
        #elif defined (_UseKajiyaAnistropic)
            // float LdotV = dot(L,V);
            // float invLenLV = rsqrt(max(2.0 * LdotV + 2.0, FLT_EPS));
            // vec3 H2 = (L + V) * invLenLV;//
            // float roughness1 = RoughnessToBlinnPhongSpecularExponent(roughness);
            float perceptualRoughness = PerceptualSmoothnessToPerceptualRoughness(anistroData.perceptualRoughness);
            float roughness1 = PerceptualRoughnessToRoughness(perceptualRoughness);
            float pbRoughness1 = RoughnessToBlinnPhongSpecularExponent(roughness1);

            float perceptualRoughness2 = PerceptualSmoothnessToPerceptualRoughness(anistroData.perceptualRoughness2);
            float roughness2 = PerceptualRoughnessToRoughness(perceptualRoughness2);
            float pbRoughness2 = RoughnessToBlinnPhongSpecularExponent(roughness2);

            vec3 spec1 = KajiyaKay(anistroData.T1, H, pbRoughness1 * roughness)* anistroData.anisotropicColor*10;
            vec3 spec2 = KajiyaKay(anistroData.T2, H, pbRoughness2 * roughness)* anistroData.anisotropicColor2*5;
            // spec1 =  min(spec1, 1e+2);
            // spec2 =  min(spec2, 1e+2);

            float Ds = mix(GTR2(NdotH, roughness), 1, anistroData.anisotropicMask);
            // float Gs = mix(smithG_GGX(NdotL, roughness) * smithG_GGX(NdotV, roughness), spec1 + spec2, anistroData.anisotropicMask);
            // return GTR2(NdotH, roughness);
            Ds = min(Ds, 1e+2);
            // Gs = min(Gs, 1e+2);
            return (spec1 + spec2)*anistroData.anisotropicIntensity * Fs * Ds ;
        #endif
    #else
        float Ds = GTR2(NdotH, roughness);
        float Gs = smithG_GGX(NdotL, roughness) * smithG_GGX(NdotV, roughness);
        Ds = min(Ds, 1e+2);
        Gs = min(Gs, 1e+2);
        return Gs * Fs * Ds;
    #endif
}

float DirectClearcoat(ClearcoatData clearcoatData, DBRDFData brdfData) {
    vec3 H = brdfData.H;
    vec3 L = brdfData.L;
    vec3 V = brdfData.V;
    float FH = brdfData.FH;

    #ifdef _CLEARCOAT_ON
        float ccNdotH = dot(clearcoatData.normal, H);
        float ccNdotL = dot(clearcoatData.normal, L);
        float ccNdotV = dot(clearcoatData.normal, V);

        float Dr = GTR1(ccNdotH, mix(.1, .001, clearcoatData.clearcoatGloss));
        float Fr = mix(kDieletricSpec.x, 1.0, FH);
        float Gr = smithG_GGX(ccNdotL, .25) * smithG_GGX(ccNdotV, .25);

        Dr = min(Dr, 1e+2);
        Gr = min(Gr, 1e+2);
        return .25 * clearcoatData.clearcoat * Gr * Fr * Dr;
    #else
        return 0;
    #endif
}

vec3 DirectDiffuseAndSSS(SubsurfaceData sssData, DBRDFData brdfData, Light light) {
  vec3 albedo = brdfData.albedo;
  float NdotL = brdfData.NdotL;
  float NdotV = brdfData.NdotV;
  float LdotH = brdfData.LdotH;
  float roughness = brdfData.roughness;

  float FL = SchlickFresnel(NdotL), FV = SchlickFresnel(NdotV);
  float Fd90 = 0.5 + 2 * LdotH * LdotH * roughness;

  #ifdef _SUBSURFACE_ON
      vec3 color = albedo * texture_2D(_SubsurfaceLUT, half2(dot(brdfData.N, brdfData.L) * 0.5 + 0.5)).rgb;
      float transDot = saturate(dot(-brdfData.L, brdfData.V));
      transDot = exp2((transDot - 1) * sssData.transPower);
      color += sssData.color * transDot * (1.0 - NdotL) * sssData.translucency;
      color *= light.color * light.shadowAttenuation * light.distanceAttenuation;
      return color;
  #else
      float Fd = mix(1.0, Fd90, FL) * mix(1.0, Fd90, FV);
      return Fd * albedo * light.color * light.shadowAttenuation * light.distanceAttenuation * NdotL;
  #endif
}

vec3 DirectSheen(DBRDFData brdfData) {
    vec3 albedo = brdfData.albedo;
    float LdotH = brdfData.LdotH;
    float sheen = brdfData.sheen;
    float sheenTint = brdfData.sheenTint;
    float FH = brdfData.FH;

    float Cdlum = .3 * albedo.x + .6 * albedo.y + .1 * albedo.z; // luminance approx.
    Cdlum = max(Cdlum,0.0001);
    vec3 Ctint = Cdlum > 0 ? albedo / Cdlum : vec3(1, 1, 1); // SafeNormalize lum. to isolate hue+sat
    vec3 Csheen = mix(vec3(1, 1, 1), Ctint, sheenTint);

    vec3 Fsheen = FH * sheen * Csheen;
    return Fsheen;
}

half3 DisneyDirectBRDF(DBRDFData brdfData,
    ClearcoatData clearcoatData,
    AnistroData anistroData,
    SubsurfaceData subData,
    Light light)
{
    half3 L = brdfData.L = light.direction;
    half3 N = brdfData.N;
    half3 V = brdfData.V;
    // float NdotL = brdfData.NdotL = max(saturate(dot(N, L)),0.0001);
    // float NdotV = brdfData.NdotV = max(saturate(dot(N, V)),0.0001);
    float NdotL = brdfData.NdotL = min(max(dot(N, L),0.0001), 1.0);
    float NdotV = brdfData.NdotV = min(max(dot(N, V),0.0001), 1.0);
    //if (NdotL < 0 || NdotV < 0) return float3(0, 0, 0);


    half3 H = brdfData.H = SafeNormalize(L + V);
    brdfData.NdotH = dot(N, H);
    float LdotH = brdfData.LdotH = dot(L, H);
    brdfData.LdotV = dot(L, V);

    float FH = brdfData.FH = SchlickFresnel(LdotH);
    brdfData.Fs = lerp(brdfData.specular, float3(1, 1, 1), FH);
    half3 diffuse_shade = DirectDiffuseAndSSS(subData, brdfData, light) * (1 - brdfData.metallic);
    half3 specular_val = DirectSpecular(anistroData, brdfData);
    half clearcoatSpecular_val = DirectClearcoat(clearcoatData, brdfData);
    half3 Fsheen = DirectSheen(brdfData) * (1 - brdfData.metallic);

    half3 o = Fsheen + PI * (specular_val + clearcoatSpecular_val);
    o *= light.color * light.shadowAttenuation * light.distanceAttenuation * NdotL;
    o += diffuse_shade;
    return o;
}

//BRDFData Initialize
inline void DisneyInitializeBRDFData(half3 albedo, half metallic, half smoothness, half alpha, half sheen, half sheenTint, out DBRDFData outBRDFData)
{
    outBRDFData = initDBRDFData();
    half oneMinusReflectivity = OneMinusReflectivityMetallic(metallic);
    half reflectivity = 1.0 - oneMinusReflectivity;

    outBRDFData.albedo = albedo;
    //outBRDFData.diffuse = albedo * oneMinusReflectivity;
    outBRDFData.specular = lerp(kDieletricSpec.rgb, albedo, metallic);
    outBRDFData.metallic = metallic;
    outBRDFData.sheen = sheen;
    outBRDFData.sheenTint = sheenTint;

    outBRDFData.gi_grazingTerm = saturate(smoothness + reflectivity);
    outBRDFData.perceptualRoughness = PerceptualSmoothnessToPerceptualRoughness(smoothness);
    outBRDFData.roughness = max(PerceptualRoughnessToRoughness(outBRDFData.perceptualRoughness), HALF_MIN);
    outBRDFData.roughness2 = outBRDFData.roughness * outBRDFData.roughness;

#ifdef _ALPHAPREMULTIPLY_ON
    outBRDFData.albedo *= alpha;
    //outBRDFData.diffuse *= alpha;
#endif
}

half3 DisneyGlobalIllumination(VRayMtlInitParams params, VRayMtlContext ctx, DBRDFData brdfData, half3 bakedGI, half occlusion, half3 occlusionCol, ClearcoatData clearcoatData)
{
  half3 V = brdfData.V;
  half3 N = brdfData.N;
  half sheenTint = brdfData.sheenTint;

  half3 indirectDiffuse = lerp(occlusionCol, bakedGI, occlusion);//Art dark part of diffuse
  //SPECULAR1
  half3 reflectVector = reflect(-V, N);
  // half3 indirectSpecular = GlossyEnvironmentReflection(reflectVector, brdfData.perceptualRoughness, occlusion);
  half3 indirectSpecular = GlossyEnvironmentReflection(params, ctx);
  float surfaceReduction = 1.0 / (brdfData.roughness2 + 1.0);
  half fresnelTerm = Pow4(1.0 - clamp(dot(N, V), 0.0, 1.0));
  half3 c = surfaceReduction * indirectSpecular * lerp(brdfData.specular, vec3(brdfData.gi_grazingTerm), vec3(fresnelTerm));
  #ifdef LIGHTMAP_ON
    c *= 0.5;
    return c + brdfData.albedo * (1 - brdfData.metallic) * indirectDiffuse;
  #endif

  //DIFFUSE
  half3 Cdlin = brdfData.albedo;
  half Cdlum = .3 * Cdlin.x + .6 * Cdlin.y + .1 * Cdlin.z; // luminance approx.
  Cdlum = max(Cdlum,0.0001);
  half3 Ctint = Cdlum > 0 ? Cdlin / Cdlum : float3(1, 1, 1); // normalize lum. to isolate hue+sat
  half3 Csheen = lerp(float3(1.0, 1.0, 1.0), Ctint, vec3(sheenTint, sheenTint, sheenTint));
  half FH = SchlickFresnel(dot(V, N)); // because of L=N
  half3 Fsheen = FH * brdfData.sheen * Csheen;
  c += (brdfData.albedo + Fsheen) * (1 - brdfData.metallic) * indirectDiffuse;

  #ifdef _CLEARCOAT_ON
    half3 cc_reflectVector = reflect(-V, clearcoatData.normal);
    half3 cc_indirectSpecular = GlossyEnvironmentReflection(cc_reflectVector, 1 - clearcoatData.clearcoatGloss, occlusion);
    half3 cc_specular = kDieletricSpec.rgb;
    half3 cc_grazingTerm = saturate(2.0 - kDieletricSpec.a);
    half cc_fresnelTerm = Pow4(1.0 - saturate(dot(clearcoatData.normal, V)));
    c += 1 * cc_indirectSpecular * lerp(cc_specular, cc_grazingTerm, vec3(cc_fresnelTerm, cc_fresnelTerm, cc_fresnelTerm)) * clearcoatData.clearcoat;// *reflectionIntensity;
  #endif
  return c;
}

half4 DisneyBRDF(InputData inputData,
    half3 albedo,
    half metallic,
    half roughness,
    half3 emission,
    half alpha,
    half occlusion = 1,
    half3 occlusionCol = half3(1.0,1.0,1.0),
    half sheen = 0,
    half sheenTint = 0,
    AnistroData anistroData = initAnistroData(),
    ClearcoatData clearcoatData = initClearcoatData(),
    SubsurfaceData subData = initSubsurfaceData(),
    half ShadowIntensity = 1,
    half DirectLightIntensity = 1,
    half GIIntensity = 1,    
    vec3 position,
    VRayMtlInitParams params, 
    VRayMtlContext ctx)
{
  DBRDFData brdfData;
  DisneyInitializeBRDFData(albedo, metallic, 1.0 - roughness, alpha, sheen, sheenTint, brdfData);
  brdfData.V = inputData.viewDirectionWS;
  brdfData.N = inputData.normalWS;

  Light mainLight = GetMainLight(inputData.shadowCoord, position);
  #ifdef DelaySolution
    mainLight.shadowAttenuation = FLT_1;
  #else
    mainLight.shadowAttenuation = lerp(1.0, mainLight.shadowAttenuation, ShadowIntensity);
    MixRealtimeAndBakedGI(mainLight, brdfData.N, inputData.bakedGI, half4(0.0, 0.0, 0.0, 0.0));
  #endif

  half3 giColor = VEC3_0;
  giColor = DisneyGlobalIllumination(params, ctx,brdfData, inputData.bakedGI, occlusion, occlusionCol, clearcoatData) * _GIIntensity;
  float3 directBRDFColor = VEC3_0;
  #ifdef LIGHTMAP_ON 
      return half4(giColor + emission, 1);
  #else
      directBRDFColor = DisneyDirectBRDF(brdfData, clearcoatData, anistroData, subData, mainLight);
      #ifdef _ADDITIONAL_LIGHTS
          uint pixelLightCount = GetAdditionalLightsCount();
          for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
          {
              Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
              directBRDFColor += DisneyDirectBRDF(brdfData, clearcoatData, anistroData, subData, light);
          }
      #endif
  #endif
  half3 finalColor = half3(0.0, 0.0, 0.0);
  finalColor += directBRDFColor * DirectLightIntensity;

  float3 vertexColor = VEC3_0;
  #ifdef _ADDITIONAL_LIGHTS_VERTEX
      vertexColor = inputData.vertexLighting * brdfData.albedo * (1 - metallic);
  #endif

  finalColor += giColor + vertexColor;

  //custom shadow color
  //half NL = dot(SafeNormalize(inputData.normalWS), SafeNormalize(mainLight.direction));
  //half nolmask = saturate(NL);
  //half addShadowAtten = 1 - smoothstep(_NoLMinBrightShadow, _NoLMaxBrightShadow, nolmask);
  //mainLight.shadowAttenuation = saturate(addShadowAtten + mainLight.shadowAttenuation);
  //finalColor = lerp(finalColor, finalColor * _SubtractiveShadowColor.rgb * _BrightShadow, (1.0 - mainLight.shadowAttenuation) * _EnableCustomShadow);
  //custom end

  finalColor += emission;

  return half4(finalColor, alpha);
}

//-----------------------------------------------DisneyLitPass----------------------------------------------
// Unpack from normal map
vec3 UnpackNormalRGB(vec4 packedNormal, float scale = 1.0)
{
    vec3 normal;
    normal.xyz = packedNormal.rgb * 2.0 - 1.0;
    normal.xy *= scale;
    return normal;
}

vec3 UnpackNormalScale(vec4 packedNormal, float bumpScale){
  return UnpackNormalRGB(packedNormal, bumpScale);
}
#ifdef USE_MATERIAL_PROPERTIES
  vec3 SampleNormal(SparseCoord uv, SamplerSparse  bumpMap, float scale = 1.0){
    vec4 n = textureSparse(bumpMap, uv);
    return UnpackNormalScale(n, scale);
  } 
#else
  vec3 SampleNormal(vec2 uv, sampler2D bumpMap, float scale = 1.0){
    vec4 n = texture_2D(bumpMap, uv);
    return UnpackNormalScale(n, scale);
  }
#endif

#ifdef USE_MATERIAL_PROPERTIES
  void InitMetalRoughAOEmiss(SparseCoord uv, vec3 Albedo, out float Metallic, out float Roughness, out float AO, out vec3 Emission) {
    Metallic = getMetallic(_MetalTexture_Sparse, uv);
    Roughness = getRoughness(_RoughnessTexture_Sparse, uv);
    vec4 AOSampler = textureSparse(_AOTexture_Sparse, uv);
    AO = AOSampler.r;
    vec4 EmissionSampler = textureSparse(_EmissionTexture_Sparse, uv);
    Emission = EmissionSampler.r * _EmissionIntensity * Albedo;
    // Emission = Albedo * getEmissive(_EmissionTexture_Sparse, uv) * _EmissionIntensity;
  }
#else
  void InitMetalRoughAOEmiss(vec2 uv, vec3 Albedo, out float Metallic, out float Roughness, out float AO, out vec3 Emission) {
    vec4 pbrMap_var = texture_2D(_MixTexture, uv * _MainTex_ST/*_MixTexture_ST*/.xy + _MainTex_ST/*_MixTexture_ST*/.zw);
    Metallic = pbrMap_var.r;
    Roughness = pbrMap_var.g;
    AO = pbrMap_var.b;
    Emission = Albedo * pbrMap_var.a * _EmissionIntensity;
  }
#endif

#ifdef USE_MATERIAL_PROPERTIES
  //if normal map is no SafeNormalize, when x^2+y^2>1, then give default value(0,0,1)
  void InitNormalMask(SparseCoord uv, out vec3 NormalTS, out float SheenMask, out float ClearCoatMask) {
    vec4 normalMask_var = textureSparse(_BumpMaskMap_Sparse, uv);
    vec2 normal_xy = normalMask_var.rg * 2.0 - 1.0;
    float z2 = max(0.99 - dot(normal_xy, normal_xy), 0.0);
    NormalTS = mix(vec3(0.0, 0.0, 1.0), vec3(normal_xy, sqrt(z2)), ceil(z2));
    #ifdef LIGHTMAP_ON 
      NormalTS = SampleNormal(uv, _BumpMaskMap_Sparse, 4);
    #endif
    SheenMask = normalMask_var.b;
    ClearCoatMask = normalMask_var.a;
  }
#else
  //if normal map is no SafeNormalize, when x^2+y^2>1, then give default value(0,0,1)
  void InitNormalMask(vec2 uv, out vec3 NormalTS, out float SheenMask, out float ClearCoatMask) {
    vec4 normalMask_var = texture_2D(_BumpMaskMap, uv * _MainTex_ST.xy + _MainTex_ST.zw);
    vec2 normal_xy = normalMask_var.rg * 2.0 - 1.0;
    float z2 = max(0.99 - dot(normal_xy, normal_xy), 0.0);
    NormalTS = mix(vec3(0.0, 0.0, 1.0), vec3(normal_xy, sqrt(z2)), ceil(z2));
    #ifdef LIGHTMAP_ON 
      NormalTS = SampleNormal(uv, _BumpMaskMap, 4);
    #endif
    SheenMask = normalMask_var.b;
    ClearCoatMask = normalMask_var.a;
  }
#endif

void InitSubsurface(vec2 uv, vec3 Albedo, out SubsurfaceData sssData) {
	sssData = SubsurfaceData(0.0, 0.0, vec3(0.0, 0.0, 0.0));
#ifdef _SUBSURFACE_ON
	half4 subtranslucency_var = SAMPLE_TEXTURE2D(_SubsurfaceMap, sampler_SubsurfaceMap, uv * _MainTex_ST.xy + _MainTex_ST.zw);
	sssData.translucency = subtranslucency_var.r * _TransStrength;
	sssData.transPower = _TransPower;
	sssData.color = _SubsurfaceCol.rgb * Albedo;
#else
	sssData.translucency = 1.0;
	sssData.color = vec3(1.0, 1.0, 1.0);
#endif
}

void FX_Invincible(float NdotV, inout half3 Emission) {
	#ifdef _FX_ON
	if (_FXSparkInvincible_ON == 1) {
		Emission += (saturate(sin(_TimeParameters.x * _SparkleFrequency) * 0.5) * _SparkleColor.rgb +
			_InvincibleColor.rgb * _InvincibleScale * pow(saturate(1.0 - NdotV), _InvinciblePower)).rgb;
	}
	#endif
}

void FX_Dissolve(float4 uv, float NdotV, inout half Alpha, inout half3 Emission) {
#ifdef _FX_DISSOLVE_LINE
	float dissolveMask = pow(clamp(1.0 - 10.0 * (0.98 - uv.w - _ScanLine), 0.0, 1.0), 20);
	float dissolve_gridVar = texture_2D(_DissolveTex, uv.zw * float2(_Grid_X, _Grid_Y)).a;
	float noiseTime = _TimeParameters.x * 0.05;

	//Too many Multi-sample DissolveMap for effect. Effect not so precise, should be repaired.
	float dissolve_var = texture_2D(_DissolveTex, uv.zw * _DissolveTex_ST.xy + _DissolveTex_ST.zw).b;

	float2 dissolve_timeVar_uv = 0.5 + dot(float2(uv.w * 0.2, noiseTime + uv.z * 0.2) - 0.5, float2(cos(0.25 * 6.283185), -sin(0.25 * 6.283185)));
	float4 dissolve_timeVar = texture_2D(_DissolveTex, dissolve_timeVar_uv);

	float dissolve_timeVar1 = texture_2D(_DissolveTex, noiseTime * 0.2 + uv.zw * 2).g;

	float2 dissolve_timeVar2_uv = 0.5 + _SmallNoise * dot(float2(uv.w + 0.5, noiseTime + uv.z - 0.5), float2(cos(0.25 * 6.283185), -sin(0.25 * 6.283185)));
	float dissolve_timeVar2 = texture_2D(_DissolveTex, dissolve_timeVar2_uv).g;

	float dissolveFactor = dissolveMask *
		(dissolve_timeVar.r * dissolve_gridVar +
			dissolve_timeVar2 * dissolve_timeVar1 * dissolve_var);

	float dissolve_mosaicVar = texture_2D(_DissolveTex, uv.zw * float2(_Mosaic_X, _Mosaic_Y)).g;

	Emission += lerp(_DissolveEmissiveColor.rgb, _DissolveBrightLineColor.rgb, dissolveFactor) *
		clamp(
			dissolveMask * pow(1 - pow(abs(1.0 - NdotV), 1.5 + 0.5 * sin(_TimeParameters.x)), 3.0) *
			voronoi(uv.xy * 2 + _TimeParameters.x, _TimeParameters.x) * dissolve_mosaicVar * dissolve_var +
			dissolveFactor
			, 0.0, 1.0);

	float clampResult15_g3 = clamp((1.0 - uv.w - _ScanLine) * 10.0, 0.0, 1.0);

	Alpha *= clamp(clampResult15_g3 / ((1.0 - clampResult15_g3) * dissolve_timeVar.g + 0.03), 0.0, 1.0);
  #ifdef _ALPHATEST_ON
    clip(Alpha - _AlphaClipThreshold);
  #endif

#endif
}

void InitAnistropic(float2 uv, half3 normalWS, half3 WorldSpaceTangent, half3 WorldSpaceBiTangent, out AnistroData anistroData) {
	anistroData = initAnistroData();
#ifdef _ANISOTROPIC_ON 
  #ifdef _UseDisneyAnistropic
    anistroData.tangentWS = SafeNormalize(WorldSpaceTangent);
    anistroData.biTangentWS = SafeNormalize(WorldSpaceBiTangent);
    anistroData.anisotropic = _Anisotropic;
  #elif defined(_UseKajiyaAnistropic)
    half4 MaskMapSample = SAMPLE_TEXTURE2D(_MaskMap, sampler_MaskMap, uv.xy);
    half specularShift;
    // normalWS = TransformTangentToWorld(MaskMapSample.xyz,half3x3(WorldSpaceTangent, WorldSpaceBiTangent, normalWS));
    // specularShift = (specularShift * _SpecularShift) + _SpecularPos;
    specularShift = (MaskMapSample * 2 - 1)  * _SpecularShift + _SpecularPos ;

    anistroData.T1 = ShiftTangentX(WorldSpaceBiTangent, normalWS, specularShift);
    anistroData.perceptualRoughness = 1-_Smoothness;

    half specularShift2;
    specularShift2 = (specularShift2 * _SpecularShift2) + _SpecularPos2;
    specularShift2 = (MaskMapSample * 2 - 1) * _SpecularShift2 + _SpecularPos2;

    anistroData.T2 = ShiftTangentX(WorldSpaceBiTangent, normalWS, specularShift2);
    anistroData.perceptualRoughness2 = 1-_Smoothness2;

    anistroData.anisotropicColor = _AnisotropicColor.xyz;
    anistroData.anisotropicColor2 = _AnisotropicColor2.xyz;
    anistroData.anisotropicIntensity = _AnisotropicIntensity;
    anistroData.anisotropicMask = MaskMapSample.r;
    anistroData.anisotropicMask = 1;
  #endif
#endif
}

void InitClearcoat(half3 WorldSpaceNormal, half ClearCoat, out ClearcoatData clearcoatData) {
	clearcoatData = initClearcoatData();
	clearcoatData.normal = WorldSpaceNormal;
	clearcoatData.clearcoat = ClearCoat;
	clearcoatData.clearcoatGloss = _ClearcoatGloss;
}
//Detail normal_metal_roughness map
void InitDetailNormalMetalRough(float2 uv, float SheenMask, inout half3 Normal, inout half Metallic, inout half Roughness) {
  #ifdef _DetailBump_Metallic_Roughness_ON
    half4 detail_nbrVar = SAMPLE_TEXTURE2D(_DetailBMRMap, sampler_DetailBMRMap, uv * _DetailBMRMap_ST.xy + _DetailBMRMap_ST.zw);
    half2 detail_nxy = detail_nbrVar.rg * 2.0 - 1.0;
    half3 detail_normal = half3(detail_nxy, sqrt(1 - dot(detail_nxy, detail_nxy)));
    Normal = BlendNormalRNM(Normal, lerp(half3(0, 0, 1), detail_normal, _DetailNormalIntensity * SheenMask));
    Metallic = saturate(overlayLerpBlend(Metallic, detail_nbrVar.b, _DetailMetallicIntensity * SheenMask));
    Roughness = saturate(overlayLerpBlend(Roughness, detail_nbrVar.a, _DetailRoughnessIntensity * SheenMask));
  #endif
}

//--------------------------------------------------ACES-----------------------------------------------------
//float T3_whiteClip;
float3 T3NeutralCurve(float3 x, float T3_a, float T3_b, float T3_c, float T3_d, float T3_e, float T3_f){
  return ((x * (T3_a * x + T3_c * T3_b) + T3_d * T3_e) / (x * (T3_a * x + T3_b) + T3_d * T3_f)) - T3_e / T3_f;
}

#ifdef CUSTOM_ACES
  real3 TonemapT3ACES(real3 x)
  {
    if(!_CustomACES) return x;
    // Tonemap
    float T3_whiteClip = 1.0;


    real3 whiteScale = VEC3_1 / T3NeutralCurve(vec3(T3_whiteLevel), T3_a, T3_b, T3_c, T3_d, T3_e, T3_f);
    x = T3NeutralCurve(x * whiteScale, T3_a, T3_b, T3_c, T3_d, T3_e, T3_f);
    x *= whiteScale;

    // Post-curve white point adjustment
    x /= vec3(T3_whiteClip);

    return x;
  }
#else 
  real3 TonemapT3ACES(real3 x){
    return x;
  }
#endif


//-------------------------------------------------input-----------------------------------------------------
struct InputData
{
    float3  positionWS;
    half3   normalWS;
    half3   viewDirectionWS;
    float4  shadowCoord;
    half    fogCoord;
    half3   vertexLighting;
    half3   bakedGI;
#if defined(LIGHTMAP_ON) && (defined(_XRP_SHADOWMASK) || defined(_XRP_COMPOSITE_SHADOWMASK))
	half4   bakedAtten;
#endif
};
//-----------------------------------------------------------------------------------------------------------
void shade(V2F inputs)
{
  // Normal with bump/normal map applied
	vec3 bumpNormal = computeWSNormal(inputs.sparse_coord, inputs.tangent, inputs.bitangent, inputs.normal);

	// Init VRayMtl
	VRayMtlInitParams initParams;

	// setup geometric data
	// for 2D put view vector along normal (see lib-vectors)
	initParams.Vw = is2DView ? bumpNormal : getEyeVec(inputs.position);
	initParams.geomNormal = bumpNormal;
	initParams.approxEnv = false;

	// setup common parameters
	initParams.diffuseAmount = 1.0;
	initParams.reflAmount = 1.0;
	initParams.traceReflections = true;
	initParams.aniso = 0.0;
	initParams.anisoRotation = 0.0;
	initParams.anisoAxis = 2;
	initParams.refractionAmount = 1.0;
	initParams.refractionIOR = 1.6;
	initParams.refrGloss = 1.0;
	initParams.traceRefractions = true;
	initParams.useFresnel = true;
	initParams.fresnelIOR = 1.6;
	initParams.lockFresnelIOR = true;
	initParams.doubleSided = false;
	initParams.useRoughness = false;
	initParams.gtrGamma = 2.0;
	initParams.brdfType = 3;
	initParams.opacity = vec3(1.0);

  // flavour-specific setup
	setupInitParams(initParams, inputs.sparse_coord);

  // Init context and sample material
	VRayMtlContext ctx = initVRayMtlContext(initParams);

  LocalVectors vectors = computeLocalFrame(inputs);
  vec3 V = normalize(vectors.eye);
  vec3 N = normalize(vectors.normal);

  vec3 L = SetL(inputs.position);
  vec3 H = normalize(L + vectors.eye);

  float NdV = dot(N, V);
  float NdL = max(0.0, dot(N, L));
  float NdH = max(0.0, dot(N, H));
  float VdH = max(0.0, dot(V, H));
  vec3 reflectDir = reflect(-vectors.eye, vectors.normal);

  // float roughness = getRoughness(roughness_tex, inputs.sparse_coord);
  // roughness = roughness * roughness;
  // float squareRoughness = roughness * roughness;
  // float smoothness = 1 - roughness;

  InputData inputData;
	inputData.positionWS = inputs.position;
	inputData.viewDirectionWS = SafeNormalize(_WorldSpaceCameraPos.xyz - inputData.positionWS);
  #ifdef DelaySolution
	  inputData.shadowCoord = VEC4_0;
    inputData.vertexLighting = VEC3_0;
  #else
    inputData.shadowCoord = inputs.shadowCoord;
	  inputData.vertexLighting = inputs.fogFactorAndVertexLight.yzw;
  #endif

  #ifdef USE_MATERIAL_PROPERTIES
    float4 mainTex_var = textureSparse(_MainTex_Sparse, inputs.sparse_coord) ;
  #else
    float4 mainTex_var = texture_2D(_MainTex, inputs.tex_coord * _MainTex_ST.xy + _MainTex_ST.zw) * _BaseColor;
  #endif

  float4 _BumpMaskMap_var = textureSparse(_BumpMaskMap_Sparse, inputs.sparse_coord);
	half3 Albedo = mainTex_var.rgb;
	half Alpha = mainTex_var.a;
	#ifdef _ALPHATEST_ON
		clip(Alpha - _AlphaClipThreshold);
	#endif
  half3 WorldSpaceNormal = vectors.normal;
  #ifdef _Simplify
		half3 WorldSpaceTangent = half3(1.0, 0.0, 0.0);
		half3 WorldSpaceBiTangent = half3(0.0, 1.0, 0.0);
		half Metallic = _MixSimMetal;
		half Roughness = _MixSimRough;
		half AO = 1;
		half3 Emission = Albedo * _EmissionIntensity;
		half Sheen = 0.0;
		half ClearCoat = 0.0;
		half subThickness = 1.0;
		half4 subsurfaceCol = half4(1.0, 1.0, 1.0, 1.0);
		inputData.normalWS = WorldSpaceNormal;
	#else
    half Metallic, Roughness, AO;
    half3 Emission;
    #ifdef USE_MATERIAL_PROPERTIES
      InitMetalRoughAOEmiss(inputs.sparse_coord, Albedo, Metallic, Roughness, AO, Emission);
    #else
      InitMetalRoughAOEmiss(inputs.tex_coord.xy, Albedo, Metallic, Roughness, AO, Emission);
    #endif //ifdef USE_MATERIAL_PROPERTIES

    half3 Normal;
    half SheenMask, ClearCoatMask;
    #ifdef USE_MATERIAL_PROPERTIES
      InitNormalMask(inputs.sparse_coord, Normal, SheenMask, ClearCoatMask);
    #else
      InitNormalMask(inputs.tex_coord.xy, Normal, SheenMask, ClearCoatMask);
    #endif //idef USE_MATERIAL_PROPERTIES
    half Sheen = _Sheen * SheenMask;
    half ClearCoat = _Clearcoat * ClearCoatMask;

    InitDetailNormalMetalRough(inputs.tex_coord.xy, SheenMask, Normal, Metallic, Roughness);
    
    half3 WorldSpaceTangent, WorldSpaceBiTangent;
    inputData.normalWS = WorldSpaceNormal;

    //Detail albedo map
    #ifdef _DetailAlbedo_ON 
      half4 detail_albedoVar = SAMPLE_TEXTURE2D(_DetailAlbedoTex, sampler_DetailAlbedoTex, inputs.tex_coord.xy * _DetailAlbedoTex_ST.xy + _DetailAlbedoTex_ST.zw);
      Albedo *= detail_albedoVar; 
      Alpha *= detail_albedoVar.a;
    #endif //ifdef _DetailAlbedo_ON

    #ifdef DelaySolution
    #else //ifdef DelaySolution
        /*---------------------FX------------------------------*/
        float NdotV = dot(WorldSpaceNormal, inputData.viewDirectionWS);
        //Character Invincible FX
        FX_Invincible(NdotV, Emission);
        //Dissolve FX
        FX_Dissolve(inputs.tex_coord, NdotV, Alpha, Emission);	
        /*--------------------End--------------------------------*/		
    #endif // ifdef DelaySolution
    //Glass Alpha
    #ifdef _Glass
      float frenel = _FresnelScale * pow(max(1.0 - NdotV, 0), _FresnelPower);
      Alpha = saturate(lerp(Alpha, _InnerAlpha+saturate(frenel), Alpha));
    #endif //ifdef _Glass
  #endif
  //Anistropic
	AnistroData anistroData;
	InitAnistropic(inputs.tex_coord.xy, inputData.normalWS, WorldSpaceTangent, WorldSpaceBiTangent, anistroData);

	//clearcoat
	ClearcoatData clearcoatData = initClearcoatData();
	InitClearcoat(WorldSpaceNormal, ClearCoat, clearcoatData);

	//subsurface
	SubsurfaceData sssData;
	InitSubsurface(inputs.tex_coord.xy, Albedo, sssData);


  #ifdef DelaySolution
    inputData.bakedGI = envIrradiance(vectors.normal);
  #else
    inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.lightmapUVOrVertexSH.xyz, inputData.normalWS);
  #endif
  half4 color = DisneyBRDF(
    inputData,
    Albedo,
    Metallic,
    Roughness,
    Emission,
    Alpha,
    1.0 - saturate((1.0 - AO) * _OcclusionIntensity),
    _OcclusionColor.rgb,
    Sheen, 
    _SheenTint,
    anistroData,
    clearcoatData,
    sssData,
    _ShadowIntensity,
    _DirectLightIntensity,
    _GIIntensity,
    inputs.position,
    initParams,
    ctx
    );


  // vec3 baseColor = getBaseColor(basecolor_tex, inputs.sparse_coord);
  // float metallic = getMetallic(metallic_tex, inputs.sparse_coord);
  // float occlusion = getAO(inputs.sparse_coord) * getShadowFactor();
  // vec3 F0 = mix(vec3(0.04), baseColor, metallic);
  // float D = GetD(NdH,roughness);
  // vec3 F = GetF(vec3(0.04),baseColor, roughness,metallic,VdH);
  // float G = GetG(roughness, NdV, NdL);
  // vec3 kd =(1 - F)*(1 - metallic);
  // vec3 diffColor = max(vec3(0.0), kd * NdL * baseColor);
  // vec3 specularTerm =(D * F * G) * 0.25 / (NdV * NdL);
  // vec3 specular = max(vec3(0.0), specularTerm  * NdL * M_PI);
  // vec3 envdif = envIrradiance(vectors.normal);
  // float lodS = roughness < 0.01 ? 0.0 : computeLOD(reflectDir, probabilityGGX(NdH, VdH, roughness));
  // vec3 env = envSampleLOD(vectors.normal, lodS);
  // float surfaceReduction = 1.0 / (squareRoughness + 1.0);
  // float oneMinusReflectivity = 1 - max( max(F0.r, F0.g), F0.b);
  // float grazingTerm = clamp((smoothness + (1 - oneMinusReflectivity)), 0, 1);

  // vec3 FInd = fresnelShchlivk(max(NdV, 0),F0,roughness);
  // vec3 kdInd = (1 - FInd) * (1 - metallic);
  // vec3 indirdiffuse = kdInd * envdif * baseColor;
  // vec3 indirspecular = env * surfaceReduction * FresnelMix(F0,vec3(grazingTerm),NdV);

  // vec3 detailColor = texture_2D(detailMapSampler, inputs.tex_coord).rgb;

  // vec3 Result = diffColor + specular + (indirdiffuse + indirspecular)*occlusion;

  // float t = getShadowFactor();
  // Multiply by light irradiance (estimation of texel irradiance)

  float SPocclusion = getAO(inputs.sparse_coord) * getShadowFactor();
  diffuseShadingOutput(TonemapT3ACES(color.rgb * SPocclusion));
}
