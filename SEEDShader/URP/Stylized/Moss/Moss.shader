Shader "SEEDzy/URP/Stylized/Moss"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("BaseColor", color) = (1,1,1,1)
        _LayerAmount("_MossLayerAmount", float) = 17
        _LayerSpacing("_LayerSpacing", float) = 1
        _HeightMap("HeightMap", 2D) = "white" {}
        _AO("AO Pow", range(0,1)) = 0.2
        _PerceptualRoughness("_PerceptualRoughness", range(0,1)) = 0.5
        _WindNoise("WindNoise", 2D) = "White" {}
        _WindStrength("_WindStrength", Vector) = (0,0,0,0)
        _WindDirectionWithSpeed("_WindDirectionWithSpeed", Vector) = (1,1,1,1)
        [Toggle(_DEPTHBLEND)]_DepthBlendOn("DepthBlendOn", float) = 0
        _DepthBlendFade("_DepthBlendFade", range(0,1)) = 0.4
        
        
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
            #pragma shader_feature_local _DEPTHBLEND
            
            #pragma vertex vert
            #pragma require geometry
            #pragma geometry geom
            #pragma fragment frag
            


            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/SEED_Lighting.hlsl"
            #include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/DepthBlend.hlsl"
            #include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/common.hlsl"
            #include "Assets/SEEDPackage/SEEDShader/ShaderLibrary/BRDF.hlsl"

            float4 _MainTex_ST;
            float4 _HeightMap_ST;
            float4 _WindNoise_ST;
            half _LayerAmount;
            half _LayerSpacing;
            half _AO;
            half _PerceptualRoughness;
            half4 _WindStrength;
            half4 _WindDirectionWithSpeed;
            half3 _BaseColor;
            half _DepthBlendFade;

            TEXTURE2D(_MainTex);        SAMPLER(sampler_MainTex);
            TEXTURE2D(_HeightMap);        SAMPLER(sampler_HeightMap);
            TEXTURE2D(_WindNoise);        SAMPLER(sampler_WindNoise);
            
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
                float3 normalWSUpOS : TEXCOORD3;
            };

            struct g2f
            {
                float4 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
                half layerHei01 : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 positionWS : TEXCOORD3;
            #ifdef REQUIRE_SCREENUV
                float4 screenUV   : TEXCOORD4;
            #endif
            };

            
            
            

            v2g vert (a2v i)
            {
                v2g o;
                o.positionOS = i.positionOS;
                o.normalOS = i.normalOS;
                o.uv.xy = TRANSFORM_TEX(i.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(i.texcoord, _HeightMap);
                o.normalWSUpOS = TransformWorldToObjectNormal(float3(0, 1, 0));
                return o;
            }

            //????
            [instance(1)]
            [maxvertexcount(51)]
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
                        o.uv = input[j].uv;
                        o.layerHei01 = 1 / _LayerAmount * i;
                        //对方向做一个世界空间Up方向偏移，更加自然
                        float3 positionOS = input[j].positionOS + normalize(lerp(input[j].normalOS, input[j].normalWSUpOS, o.layerHei01)) * _LayerSpacing / 100 * (i);
                        o.positionCS = TransformObjectToHClip(positionOS);
                        o.normalWS = TransformObjectToWorldNormal(input[j].normalOS);
                        o.positionWS = TransformObjectToWorld(positionOS);
                    #ifdef REQUIRE_SCREENUV
                        o.screenUV = ComputeScreenPos(o.positionCS);
                    #endif
                        triStream.Append(o);
                    }
                    triStream.RestartStrip();
                }
            }

            half4 frag (g2f i) : COLOR
            {
                //这里取反一下，世界空间uv流动和纹理空间不太一样。。。。
                float2 windUV = - i.positionWS.xz * _WindNoise_ST.xy + _WindDirectionWithSpeed.xy * _WindDirectionWithSpeed.z * _Time.y;
   
                half2 WindNoise = (_WindNoise.Sample(sampler_WindNoise, windUV).xy - lerp((half2)0.5, (half2)0, saturate(_WindStrength.xy))) * _WindStrength.zw * i.layerHei01;

                // sample the texture
                half4 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv.xy); 
                half hei = _HeightMap.Sample(sampler_HeightMap, i.uv.zw + WindNoise * 0.01 * _WindDirectionWithSpeed.xy);
                //half hei = _HeightMap.Sample(sampler_HeightMap, i.uv.zw + half2(WindNoise.x, 0) * _WindStrength * 0.01);
                clip(hei - i.layerHei01);
                Light light = GetMainLight();
 
                half ao = lerp(1, hei * hei, _AO);

                half3 diffuse = albedo * _BaseColor * ao;
                
                //////////PBRTest
                SurfaceInput surfaceInput;
                half4 mixData = half4(1,1,1,1);
                

                surfaceInput.albedo       = albedo;
                surfaceInput.smoothness   = mixData.r * _Smoothness;
                surfaceInput.metallic     = mixData.g * 0;
                surfaceInput.occlusion    = ao;
                surfaceInput.emissionMask = mixData.a * _Emission * _EmissionColor;
                surfaceInput.normalTS     = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
                surfaceInput.IOR          = 1;
                
                InputData inputData;
                InitInputData(i, inputData, surfaceInput.normalTS);
                /////////////////////////////
                ///
                half4 finCol = half4(diffuse, albedo.a);

            #ifdef _DEPTHBLEND
                diffuse = DepthBlend(finCol, i.screenUV, _DepthBlendFade);
            #endif
                return half4(diffuse.rgb, albedo.a);
            }
            ENDHLSL
        }
    }
}
