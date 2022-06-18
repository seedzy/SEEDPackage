Shader "SEEDzy/URP/Fur"
{
    Properties
    {
        //基本颜色
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("FurColor", Color) = (1, 1, 1, 1)
        _RootColor ("FurRootColor", Color) = (0.5, 0.5, 0.5, 1)

        //光照相关参数
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Shininess ("Shininess", Range(0.01, 256.0)) = 8.0       
        _RimColor ("Rim Color", Color) = (0, 0, 0, 1)
        _RimPower ("Rim Power", Range(0.0, 8.0)) = 6.0

        //毛发参数
        _FurTex ("Fur Pattern", 2D) = "white" { }  
        _FurLength ("Fur Length", Range(0.0, 1)) = 0.5   
        _FurShadow ("Fur Shadow Intensity", Range(0.0, 1)) = 0.25
        
        _FurLayerUVOffset("_FurLayerUVOffset", vector) = (0, 0, 0, 0)
        
        [Header(Test)]
        //_LayerOffset("LayerOffset", range(0, 10)) = 0.1
        _FurOffset("_FurOffset", vector) = (0,0,0,0)

        
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" }
        
        Cull back
        ZWrite On
        //ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        CGINCLUDE
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
        #include "Lighting.cginc"   
        #include "UnityCG.cginc"

        #pragma target 3.0
        
        sampler2D _MainTex;
        half4 _MainTex_ST; 
        half4 _Color;
        half4 _RootColor;
        half4 _Specular;
        half _Shininess;

        sampler2D _FurTex;
        half4 _FurTex_ST;
        half _FurShadow;
        half _FurLength;
        float3 _FurOffset;

        half4 _RimColor;
        half _RimPower;
        half2 _FurLayerUVOffset;

        //float _LayerOffset;

        #define LAYEROFFSET 0.05 * layer


        struct a2v {
            float4 vertex : POSITION;//顶点位置
            float3 normal : NORMAL;//发现
            float4 texcoord : TEXCOORD0;//纹理坐标
            float4 tangent :TANGENT;
        };

        struct v2f
        {
            float4 pos: SV_POSITION;
            half4 uv: TEXCOORD0;
            float3 worldNormal: TEXCOORD1;
            float3 worldPos: TEXCOORD2;
            float3 tangentWS : TEXCOORD3;
            float3 bnormalWS : TEXCOORD4;
        };

        float2 hash2D2D(float2 s)
        {
            //magic numbers
            return frac(sin(s)*4.5453);
        }

        float4 tex2DStochastic(sampler2D tex, float2 UV)
        {
            //triangle vertices and blend weights
            //BW_vx[0...2].xyz = triangle verts
            //BW_vx[3].xy = blend weights (z is unused)
            float4x3 BW_vx;
         
            //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)
            float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
         
            //vertex IDs and barycentric coords
            float2 vxID = float2 (floor(skewUV));
            float3 barry = float3 (frac(skewUV), 0);
            barry.z = 1.0-barry.x-barry.y;
         
            BW_vx = ((barry.z>0) ? 
                float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
                float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
         
            //calculate derivatives to avoid triangular grid artifacts
            float2 dx = ddx(UV);
            float2 dy = ddy(UV);
         
            //blend samples with calculated weights
            return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + 
                    mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + 
                    mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z);
        }

        float3 TShift(float3 tangent,float3 normal,float bnormal)
        {
            return normalize(tangent + bnormal * normal);
        }

        float StrandSpecular(half3 T,half3 V,half3 L,half exponent)
        {
            float3 H = normalize(L+V);
            float dotTH = dot(T,H);
            float sinTH = sqrt(1- dotTH * dotTH);
            float dirAtten = smoothstep(-1,0,dotTH);    
            return dirAtten*pow(sinTH,exponent);
        }

        v2f vert_Uti0(a2v v,half layer)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv.xy = 0;
            o.worldNormal = 0;
            o.worldPos = 0;
            o.tangentWS = 0;
            o.bnormalWS = 0;
            return o;
        }

        half4 frag_Uti0(v2f i, half layer)
        {
            return half4(_RootColor.rgb, 1);
        }
        

        v2f vert_Uti(a2v v,half layer)
        {
            v2f o;
            float3 OffetVertex = v.vertex.xyz + v.normal * LAYEROFFSET * _FurLength;//顶点外扩
            OffetVertex += mul(unity_WorldToObject, _FurOffset * layer * 0.01);//顶点受力偏移

            o.pos = UnityObjectToClipPos(float4(OffetVertex, 1.0));
            o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
            o.uv.zw = TRANSFORM_TEX(v.texcoord, _FurTex) + _FurLayerUVOffset * LAYEROFFSET;
            o.worldNormal = UnityObjectToWorldNormal(v.normal);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            o.tangentWS = UnityObjectToWorldDir(v.tangent);
            o.bnormalWS = v.tangent.w * cross(o.worldNormal.xyz, o.tangentWS.xyz);
            return o;
        }

        half4 frag_Uti(v2f i, half layer)
        {
            half3 worldNormal = normalize(i.worldNormal);
            half3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
            half3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
            half3 worldHalf = normalize(worldView + worldLight);

            half3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color;
            half vdotn = 1 - saturate(dot(worldView, worldNormal));
            //fresnel模拟的边缘散射
            half3 rim = _RimColor.rgb *  _RimColor.a * saturate(pow(vdotn, _RimPower));

            //用layer层数来模拟明暗交界时毛较少的区域的透光
            half3 lightRadiance = saturate(dot(worldNormal, worldLight) + LAYEROFFSET);

            half3 noise = tex2DStochastic(_FurTex, i.uv.zw).rgb;
            //后半部分柔化偏移过远的layer
            half alpha = saturate(noise - (pow(LAYEROFFSET, 2) + LAYEROFFSET * 0)) * saturate(1 - pow(10 * length(mul(unity_WorldToObject, _FurOffset * layer * 0.01)), 2));
            
            half3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
            half3 diffuse = albedo;
            half3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, worldHalf)), _Shininess);
            half3 T = TShift(i.tangentWS, i.worldNormal, i.bnormalWS);
            half3 specularA = StrandSpecular(i.bnormalWS, worldView, worldLight, _Shininess) * alpha * 1.4;

            half3 directLight = lerp( _RootColor.rgb, _LightColor0.rgb * (diffuse + specularA * _Specular.rgb), lightRadiance );
            half3 color = ambient + directLight + rim;
            //ao
            color = lerp(_RootColor.rgb , color,saturate(pow( LAYEROFFSET,_FurShadow)));
            
            return half4(color, alpha);
        }




        
        v2f vert_layer0(a2v v)
        {
            return  vert_Uti0(v, 0);
        }
        v2f vert_layer1(a2v v)
        {
            return  vert_Uti(v, 1);
        }
        v2f vert_layer2(a2v v)
        {
            return  vert_Uti(v, 2);
        }
        v2f vert_layer3(a2v v)
        {
            return  vert_Uti(v, 3);
        }
        v2f vert_layer4(a2v v)
        {
            return  vert_Uti(v, 4);
        }
        v2f vert_layer5(a2v v)
        {
            return  vert_Uti(v, 5);
        }
        v2f vert_layer6(a2v v)
        {
            return  vert_Uti(v, 6);
        }
        v2f vert_layer7(a2v v)
        {
            return  vert_Uti(v, 7);
        }
        v2f vert_layer8(a2v v)
        {
            return  vert_Uti(v, 8);
        }
        v2f vert_layer9(a2v v)
        {
            return  vert_Uti(v, 9);
        }
        v2f vert_layer10(a2v v)
        {
            return  vert_Uti(v, 10);
        }
        v2f vert_layer11(a2v v)
        {
            return  vert_Uti(v, 11);
        }
        v2f vert_layer12(a2v v)
        {
            return  vert_Uti(v, 12);
        }
        v2f vert_layer13(a2v v)
        {
            return  vert_Uti(v, 13);
        }
        v2f vert_layer14(a2v v)
        {
            return  vert_Uti(v, 14);
        }
        v2f vert_layer15(a2v v)
        {
            return  vert_Uti(v, 15);
        }
        v2f vert_layer16(a2v v)
        {
            return  vert_Uti(v, 16);
        }
        v2f vert_layer17(a2v v)
        {
            return  vert_Uti(v, 17);
        }
        v2f vert_layer18(a2v v)
        {
            return  vert_Uti(v, 18);
        }
        v2f vert_layer19(a2v v)
        {
            return  vert_Uti(v, 19);
        }
        v2f vert_layer20(a2v v)
        {
            return  vert_Uti(v, 20);
        }

        half4 frag_layer0(v2f i) : COLOR
        {
            return  frag_Uti0(i, 0);
        }
        half4 frag_layer1(v2f i) : COLOR
        {
            return  frag_Uti(i, 1);
        }
        half4 frag_layer2(v2f i) : COLOR
        {
            return  frag_Uti(i, 2);
        }
        half4 frag_layer3(v2f i) : COLOR
        {
            return  frag_Uti(i, 3);
        }
        half4 frag_layer4(v2f i) : COLOR
        {
            return  frag_Uti(i, 4);
        }
        half4 frag_layer5(v2f i) : COLOR
        {
            return  frag_Uti(i, 5);
        }
        half4 frag_layer6(v2f i) : COLOR
        {
            return  frag_Uti(i, 6);
        }
        half4 frag_layer7(v2f i) : COLOR
        {
            return  frag_Uti(i, 7);
        }
        half4 frag_layer8(v2f i) : COLOR
        {
            return  frag_Uti(i, 8);
        }
        half4 frag_layer9(v2f i) : COLOR
        {
            return  frag_Uti(i, 9);
        }
        half4 frag_layer10(v2f i) : COLOR
        {
            return  frag_Uti(i, 10);
        }
        half4 frag_layer11(v2f i) : COLOR
        {
            return  frag_Uti(i, 11);
        }
        half4 frag_layer12(v2f i) : COLOR
        {
            return  frag_Uti(i, 12);
        }
        half4 frag_layer13(v2f i) : COLOR
        {
            return  frag_Uti(i, 13);
        }
        half4 frag_layer14(v2f i) : COLOR
        {
            return  frag_Uti(i, 14);
        }
        half4 frag_layer15(v2f i) : COLOR
        {
            return  frag_Uti(i, 15);
        }
        half4 frag_layer16(v2f i) : COLOR
        {
            return  frag_Uti(i, 16);
        }
        half4 frag_layer17(v2f i) : COLOR
        {
            return  frag_Uti(i, 17);
        }
        half4 frag_layer18(v2f i) : COLOR
        {
            return  frag_Uti(i, 18);
        }
        half4 frag_layer19(v2f i) : COLOR
        {
            return  frag_Uti(i, 19);
        }
        half4 frag_layer20(v2f i) : COLOR
        {
            return  frag_Uti(i, 20);
        }
        
        
        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer0
            #pragma fragment frag_layer0
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer1
            #pragma fragment frag_layer1
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer2
            #pragma fragment frag_layer2
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer3
            #pragma fragment frag_layer3
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer4
            #pragma fragment frag_layer4
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer5
            #pragma fragment frag_layer5
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer6
            #pragma fragment frag_layer6
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer7
            #pragma fragment frag_layer7
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer8
            #pragma fragment frag_layer8
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer9
            #pragma fragment frag_layer9
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer10
            #pragma fragment frag_layer10
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer11
            #pragma fragment frag_layer11
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer12
            #pragma fragment frag_layer12
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer13
            #pragma fragment frag_layer13
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer14
            #pragma fragment frag_layer14
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer15
            #pragma fragment frag_layer15
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer16
            #pragma fragment frag_layer16
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer17
            #pragma fragment frag_layer17
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer18
            #pragma fragment frag_layer18
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer19
            #pragma fragment frag_layer19
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_layer20
            #pragma fragment frag_layer20
            ENDCG
        }
        
        
    }
}
