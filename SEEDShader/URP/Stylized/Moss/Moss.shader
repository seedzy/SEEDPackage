Shader "SEEDzy/URP/Stylized/Moss"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LayerAmount("_MossLayerAmount", float) = 17
        _LayerSpacing("_LayerSpacing", float) = 1
        _HeightMap("HeightMap", 2D) = "white" {}
        _AO("AO Pow", range(0,1)) = 0.2
        _PerceptualRoughness("_PerceptualRoughness", range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }
        LOD 100

        Pass
        {
            Tags{"LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma target 4.5
            #pragma vertex vert
            #pragma require geometry
            #pragma geometry geom
            #pragma fragment frag
            


            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/common.hlsl"
            #include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/BRDF.hlsl"

            float4 _MainTex_ST;
            float4 _HeightMap_ST;
            half _LayerAmount;
            half _LayerSpacing;
            half _AO;
            half _PerceptualRoughness;

            TEXTURE2D(_MainTex);        SAMPLER(sampler_MainTex);
            TEXTURE2D(_HeightMap);        SAMPLER(sampler_HeightMap);
            
            struct a2v
            {
                float4 positionOS : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normalOS : NORMAL;
            };

            struct v2g
            {
                float4 positionOS : TEXCOORD0;
                float4 uv         : TEXCOORD1;
                float3 normalOS   : TEXCOORD2;
            };

            struct g2f
            {
                float4 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
                half layer : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 positionWS : TEXCOORD3;
            };

            
            
            

            v2g vert (a2v i)
            {
                v2g o;
                o.positionOS = i.positionOS;
                o.normalOS = i.normalOS;
                o.uv.xy = TRANSFORM_TEX(i.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(i.texcoord, _HeightMap);
                return o;
            }

            [instance(1)]
            [maxvertexcount(65)]
            void geom(triangle v2g input[3],inout TriangleStream<g2f> triStream)
            {
                g2f o;
                // for(int i = 0;i < 3; i++)
                // {
                //     o.uv = input[i].uv;
                //     o.positionCS = TransformObjectToHClip(input[i].positionOS.xyz);
                //     o.layer = 0;
                //     triStream.Append(o);
                // }
                // triStream.RestartStrip();

                for(int i = 0;i< _LayerAmount; i++)
                {
                    for(int j = 0; j< 3; j++)
                    {
                        float3 positionOS = input[j].positionOS + normalize(input[j].normalOS) * _LayerSpacing / 100 * (i);
                        o.uv = input[j].uv;
                        o.positionCS = TransformObjectToHClip(positionOS);
                        o.layer = i;
                        o.normalWS = TransformObjectToWorldNormal(input[j].normalOS);
                        o.positionWS = TransformObjectToWorld(positionOS);
                        triStream.Append(o);
                    }
                    triStream.RestartStrip();
                }
            }

            half4 frag (g2f i) : COLOR
            {
                // sample the texture
                half4 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv.xy);
                half hei = _HeightMap.Sample(sampler_HeightMap, i.uv.zw);
                half layerHei = 1 / _LayerAmount * i.layer;
                clip(hei - layerHei);
                Light light = GetMainLight();
                
                half3 indirectDiff = SampleSH(i.normalWS) * albedo;
                    
                // #if defined(DYNAMICLIGHTMAP_ON)
                //     inputData.bakedGI = SAMPLE_GI(input.staticLightmapUV, input.dynamicLightmapUV, input.vertexSH, inputData.normalWS);
                // #else
                //     inputData.bakedGI = SAMPLE_GI(input.staticLightmapUV, input.vertexSH, inputData.normalWS);
                // #endif
                half3 viewDirWS = GetWorldSpaceViewDir(i.positionWS);
                half3 H = normalize(light.direction + viewDirWS);
                half HdotV = saturate(dot(H, viewDirWS)); 
                half NdotH = saturate(dot(i.normalWS, H));
                half NdotL = saturate(dot(i.normalWS, light.direction));
                half NdotV = saturate(dot(i.normalWS, viewDirWS));
                
                half3 directSpecular = DV_SmithJointGGX_HDRP(NdotH, NdotL, NdotV, _PerceptualRoughness * _PerceptualRoughness) * PI * Pow2(layerHei);

                half3 indirectLight = indirectDiff;

                half3 directDiff = albedo;

                half3 directLight= (directDiff + directSpecular) * lerp(1, Pow2(layerHei), _AO) * light.color * NdotL;

                half3 finCol = indirectLight + directLight;
                
                return half4(finCol, albedo.a);
            }
            ENDHLSL
        }
    }
}
