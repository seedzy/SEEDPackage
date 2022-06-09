Shader "SEEDzy/URP/Debug/ShowDepthTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }
        LOD 100

        Pass
        {
            Tags{"LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            CBUFFER_END

            TEXTURE2D(_MainTex);        SAMPLER(sampler_MainTex);
            
            struct a2v
            {
                float4 positionOS : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
            };

            //
            TEXTURE2D_X_FLOAT(_TerrainColorBuffer);
            SAMPLER(sampler_TerrainColorBuffer);
            
            float4 SampleSceneDepth(float2 uv)
            {
                return SAMPLE_TEXTURE2D_X(_TerrainColorBuffer, sampler_TerrainColorBuffer, UnityStereoTransformScreenSpaceTex(uv));
            }
            

            v2f vert (a2v i)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(i.positionOS.xyz);
                o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
                return o;
            }

            half4 frag (v2f i) : COLOR
            {
                // sample the texture
                half4 col = Linear01Depth(SampleSceneDepth(float2(1 -i.uv.x, 1-i.uv.y)), _ZBufferParams);
                col = LinearEyeDepth(SampleSceneDepth(float2(1 -i.uv.x, 1-i.uv.y)), _ZBufferParams);
                return col;
            }
            ENDHLSL
        }
    }
}
