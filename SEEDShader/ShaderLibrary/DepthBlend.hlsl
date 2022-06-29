#ifndef SEED_DEPTH_BLEND_INCLUDED
#define SEED_DEPTH_BLEND_INCLUDED

#ifdef _DEPTHBLEND
#define REQUIRE_SCREENUV
#endif

#ifdef _DEPTHBLEND
TEXTURE2D(_TerrainColorBuffer); SAMPLER(sampler_TerrainColorBuffer);
TEXTURE2D(_TerrainDepthBuffer); SAMPLER(sampler_TerrainDepthBuffer);
#endif

half4 DepthBlend(half4 color, float4 screenPos, float depthBlendFade)
{
    #ifdef _DEPTHBLEND
    float depth = screenPos.w;
    float4 terrainColorDepth = _TerrainColorBuffer.Sample(sampler_TerrainColorBuffer, screenPos.xy / screenPos.w);
    color.rgb = lerp(terrainColorDepth.rgb, color.rgb, saturate((terrainColorDepth.a * _ProjectionParams.z - depth)/ depthBlendFade));
    #endif
    return color;
}

#endif