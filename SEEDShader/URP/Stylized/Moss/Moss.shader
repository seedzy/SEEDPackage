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
        
        _Smoothness("Smoothness", range(0, 1)) = 0.5
        
        _TransIntensity("TransIntensity", range(0,1)) = 1
        _TransExponent("TransExponent", float) = 1
        _NormalDistortion("NormalDistortion", range(0,1)) = 0.5
        _Wetness("Wetness", range(0, 1)) = 1
        
        
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
            //Unity Variant
            #pragma multi_compile_fog
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            
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
            float _LayerAmount;
            float _LayerSpacing;
            float _AO;
            float _PerceptualRoughness;
            half4 _WindStrength;
            half4 _WindDirectionWithSpeed;
            float4 _BaseColor;
            float _DepthBlendFade;
            float _Smoothness;
            float _Wetness;

            float _TransIntensity;
            float _TransExponent;
            float _NormalDistortion;

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

            float SimpleTransmission(float3 normal, float3 viewDirWS, float3 lightDirWS,float normalDistortion, float transIntensity, float transExponent)
            {
                float3 fakeNormal = -lerp(normal, lightDirWS, normalDistortion);
                return pow(saturate(dot(fakeNormal, viewDirWS)), transExponent) * transIntensity;
            }

            half4 frag (g2f i) : COLOR
            {
                //这里取反一下，世界空间uv流动和纹理空间不太一样。。。。
                float2 windUV = - i.positionWS.xz * _WindNoise_ST.xy + _WindDirectionWithSpeed.xy * _WindDirectionWithSpeed.z * _Time.y;
   
                half2 WindNoise = (_WindNoise.Sample(sampler_WindNoise, windUV).xy - lerp((half2)0.5, (half2)0, saturate(_WindStrength.xy))) * _WindStrength.zw * i.layerHei01;

                // sample the texture
                float4 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv.xy); 
                half hei = _HeightMap.Sample(sampler_HeightMap, i.uv.zw + WindNoise * 0.01 * _WindDirectionWithSpeed.xy);
                //half hei = _HeightMap.Sample(sampler_HeightMap, i.uv.zw + half2(WindNoise.x, 0) * _WindStrength * 0.01);
                clip(hei - i.layerHei01);
                Light light = GetMainLight(TransformWorldToShadowCoord(i.positionWS), i.positionWS, float4(0,0,0,0));
 
                half ao = lerp(1, hei * hei, _AO);

                albedo *= _BaseColor;

                //////////////Common
                float3 normalWS = normalize(i.normalWS);
                float3 viewDirWS = normalize(GetWorldSpaceViewDir(i.positionWS));
                float3 H = normalize(light.direction + viewDirWS);
                float HdotV = saturate(dot(H, viewDirWS));
                float NdotH = saturate(dot(normalWS, H));
                float NdotV = saturate(dot(normalWS, viewDirWS));
                float NdotL = saturate(dot(normalWS, light.direction));
                float roughness = PerceptualRoughnessToRoughness(1- _Smoothness);

                ////////////PBRTest
                SurfaceInput surfaceInput;
                half4 mixData = half4(1,1,1,1);
                

                surfaceInput.albedo       = albedo;
                surfaceInput.smoothness   = mixData.r * _Smoothness;
                surfaceInput.metallic     = mixData.g * 0;
                surfaceInput.occlusion    = ao;
                surfaceInput.emissionMask = mixData.a;
                surfaceInput.normalTS     = 0;
                surfaceInput.IOR          = 1;
                
                InputData inputData;
                inputData.positionWS = i.positionWS;
                inputData.normalWS = normalWS;
                inputData.viewDirectionWS = normalize(GetWorldSpaceViewDir(i.positionWS));
                inputData.shadowCoord = TransformWorldToShadowCoord(i.positionWS);
                /////////////////////////////


                ////////////Specular brdf
                float  D = D_GGXNoPI(NdotH, roughness);
                //由于需要一种光从植被间穿过的感觉，因此这里并不需要正常G项中对于背光面的光线遮挡，同时要保留一项避免掠射角过爆，所以对G进行修改，
                //只保留一项GGX
                float  G = GeometrySchlickGGX(NdotV, roughness);
                float3 F = FresnelTerm_UE(NdotV, F0);
                float denominator = max(4 * NdotL * NdotV, REAL_MIN);
                float specularRadiance = D * G / max(4 * NdotV, REAL_MIN);
                //specularRadiance = D * F * G/ denominator;


                
                ////////Transmission
                float trans = SimpleTransmission(normalWS, viewDirWS, light.direction, _NormalDistortion, _TransIntensity, _TransExponent);
          
                //////////////Direct light radiance
                
                //这里的ao其实不是想表达是ao只是hei * hei(稀疏的地方透射越强)，因为已经算过了就直接ao了
                float lightRadiance = saturate(NdotL + ao * trans) * light.distanceAttenuation * light.shadowAttenuation;

                /////////////diffuse Light
                float3 diffuse = albedo;

                /////////////specular Light
                //完了完了，越来越随意了，这个是因为光线垂直时高光不好看
                float customRadiance = (1 - NdotL);
                float3 specular = lerp(albedo, specularRadiance.xxx + F, _Wetness * customRadiance);
                

                /////////////IndirectLight
                float3 indirectLight = SampleSH(normalWS) * albedo;

                /////////////AO,高光部分ao进一步加强
                diffuse *= ao;
                specular *= pow(ao, 4);
                indirectLight *= ao;

                //////////////test
                //diffuse = lightRadiance * albedo + SampleSH(normalWS) * albedo;
                diffuse = (diffuse + specular) * lightRadiance * light.color + indirectLight;
                //diffuse = (F + specularRadiance) * lightRadiance * 0.5;
                //diffuse = lightRadiance;
                //diffuse = specularRadiance;
                //diffuse = saturate(diffuse);

                


            #ifdef _DEPTHBLEND
                diffuse = DepthBlend(diffuse, i.screenUV, _DepthBlendFade);
            #endif

                float4 color = float4(diffuse.rgb, albedo.a);

                //Unity Fog
                color.rgb = MixFog(color.rgb, InitializeInputDataFog(float4(i.positionWS, 1.0), 0));
                
                return color;
            }
            ENDHLSL
        }
    }
}
