﻿Shader "Unlit/CursedScrollingWobbleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimeMulti ( "Time Multiplier", float) = 1.0
        //_Int ( "Int", Range(0,5) = 1.0
        _Color ("Color", Color) = (1,1,1,1)
        _ScrollPosition ("Scrolling Texture Position", float) = 1.0
        _ScrollSpeed ("Scrolling Speed", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            half _ScrollPosition;
            fixed _ScrollSpeed;

            // What level of precision for the float, half float or fixed
            half _TimeMulti;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                _ScrollPosition += _Time.y * _ScrollSpeed;
                v.uv.y += _ScrollPosition;

                o.vertex.y += sin(_Time.y * _TimeMulti + v.vertex.x + v.vertex.z);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv) * normalize(i.vertex);
                fixed4 col = tex2D(_MainTex, i.uv) * _Color * normalize(i.vertex);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
