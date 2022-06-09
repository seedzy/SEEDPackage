#ifndef TOON_SURFACE_DATA
#define TOON_SURFACE_DATA


struct  ToonSurfaceData
{
    half3   albedo;
    half    alpha;
    half    emission;
    half    occlusion;
    half4   vertexColor;
    //specularMask, shadowWeight, specularShape, areaMask
    half4   lightMap;
    half4   maskMap;
};

#endif