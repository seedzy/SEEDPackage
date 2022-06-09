// Tue May 24 11:07:20 2022

cbuffer _Globals : register(b0)
{
  float4 __ZBufferParams : packoffset(c0);
  float __GrassTipLighting : packoffset(c1);
  float __GrassShininess : packoffset(c2);
  float __ElementViewEleDrawOn : packoffset(c3);
  float __ElementViewEleID : packoffset(c4);
  float __DepthBiasScaled : packoffset(c5);
  float __RootColorScale : packoffset(c6);
  float __RootColorOffset : packoffset(c7);
}

SamplerState samplers2D_0__s : register(s0);
SamplerState samplers2D_1__s : register(s1);
SamplerState samplers2D_2__s : register(s2);
Texture2D<float4> textures2D_0_ : register(t0);
Texture2D<float4> textures2D_1_ : register(t1);
Texture2D<float4> textures2D_2_ : register(t2);


//  declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD6,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD5,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1,
  out float4 o2 : SV_TARGET2)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = v2.xyz;
  r1.xyzw = v3.xyzw;
  r2.xyzw = v4.xyzw;
  r0.w = v5.x;
  r3.xyz = v6.xyw;
  r4.xyz = v7.xyz;
  r3.w = dot(r0.xyz, r0.xyz);
  r5.xyz = rsqrt(r3.www);
  r3.w = r0.w / __RootColorScale;
  r3.w = __RootColorOffset + r3.w;
  r3.w = max(0, r3.w);
  r3.w = min(1, r3.w);
  //root color lerp, root color from vertex(v7)
  //grass baseColor also from vertex(v4)
  r6.xyz = -r4.xyz;
  r2.xyz = r6.xyz + r2.xyz;
  r2.xyz = r3.www * r2.xyz;
  r2.xyz = r2.xyz + r4.xyz;

  //fire effect lerp
  //r4.xyz = -r2.xyz;
  //r4.xyz = float3(0.0700690001,0.0560160019,0.0378829986) + r4.xyz;
  //r4.xyz = r4.xyz * r2.www;
  //r2.xyz = r4.xyz + r2.xyz;
  r3.w = -0.600000024 + r0.w;
  r3.w = max(0, r3.w);
  r3.w = min(1, r3.w);
  r3.w = __GrassTipLighting * r3.w;
  r3.w = 1 + r3.w;
  r4.x = cmp(r3.z < 100);
  if (r4.x != 0) {
    r4.xy = r3.xy / r3.zz;
    r4.xy = r4.xy;
    r4.x = textures2D_0_.Sample(samplers2D_0__s, r4.xy).x;
    r4.x = r4.x;
    r4.x = r4.x;
    r4.x = __ZBufferParams.z * r4.x;
    r4.x = __ZBufferParams.w + r4.x;
    r4.x = 1 / r4.x;
    r4.y = -r3.z;
    r4.x = r4.x + r4.y;
    r4.y = -r4.x;
    r4.x = max(r4.x, r4.y);
    r4.x = __DepthBiasScaled * r4.x;
    r4.x = max(0, r4.x);
    r4.x = min(1, r4.x);
    r4.x = sqrt(r4.x);
    r4.x = r4.x;
  } else {
    r4.x = 1;
  }
  r3.xy = r3.xy / r3.zz;
  r3.xy = r3.xy;
  r4.yzw = textures2D_2_.Sample(samplers2D_2__s, r3.xy).xyz;
  r4.yzw = r4.yzw;
  r4.yzw = r4.yzw;
  r2.xyz = r3.www * r2.xyz;
  //r6.xyz = -r4.yzw;
  //r2.xyz = r6.xyz + r2.xyz;
  //r6.xyz = r4.xxx;
  //r6.xyz = r6.xyz;
  //r2.xyz = r6.xyz * r2.xyz;
  //r4.xyz = r2.xyz + r4.yzw;
  r4.xyz = r2.xyz;
  r2.xyz = textures2D_1_.Sample(samplers2D_1__s, r3.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = r2.xyz;
  r2.xyz = float3(2,2,2) * r2.xyz;
  r2.xyz = float3(-1,-1,-1) + r2.xyz;
  r5.xyz = r5.xyz;
  r5.xyz = r5.xyz;
  r0.xyz = r5.xyz * r0.xyz;
  r3.xyz = -r2.xyz;
  r0.xyz = r3.xyz + r0.xyz;
  r3.xyz = r6.xxx;
  r3.xyz = r3.xyz;
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  r2.x = dot(r0.xyz, r0.xyz);
  r2.xyz = rsqrt(r2.xxx);
  r2.xyz = r2.xyz;
  r2.xyz = r2.xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r2.x = -r2.w;
  r2.x = 1 + r2.x;
  r2.w = __GrassShininess * r2.x;
  r1.w = 128 * r1.w;
  r1.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r3.xyz = float3(0.5,0.5,0.5) + r1.xyz;
  r0.w = 127 * r0.w;
  r0.w = r0.w + r1.w;
  r0.w = r0.w;
  r0.w = (uint)r0.w;
  r0.w = r0.w;
  r0.w = r0.w;
  r0.w = (uint)r0.w;
  r0.w = r0.w;
  r4.w = 0.00392156886 * r0.w;
  r0.xyz = float3(0.5,0.5,0.5) * r0.xyz;
  r2.xyz = float3(0.5,0.5,0.5) + r0.xyz;
  r0.xyzw = __ElementViewEleDrawOn;
  r0.xyzw = r0.xyzw;
  r0.xyzw = cmp(r0.xyzw == float4(0,0,0,0));
  r0.xyzw = cmp((int4)r0.xyzw != int4(0,0,0,0));
  r0.xy = r0.zw ? r0.xy : 0;
  r0.x = r0.y ? r0.x : 0;
  r0.y = __ElementViewEleID * 0.00392156886;
  if (r0.x == 0) {
    r3.z = r0.y;
  } else {
    r3.z = r3.z;
  }
  r3.z = r3.z;
  r2.w = r2.w;
  r4.w = r4.w;
  r3.xy = r3.xy;
  r3.w = 0.0117647061;
  r2.xyz = r2.xyz;
  r2.w = r2.w;
  r4.xyz = r4.xyz;
  r4.w = r4.w;
  r3.xy = r3.xy;
  r3.z = r3.z;
  r3.w = r3.w;
  r2.xyzw = r2.xyzw;
  r4.xyzw = r4.xyzw;
  r3.xyzw = r3.xyzw;
  o0.xyzw = r2.xyzw;
  o1.xyzw = r4.xyzw;
  o2.xyzw = r3.xyzw;
  return;
}