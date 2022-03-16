Shader "Hidden/CRT" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader {

        Pass {
            CGPROGRAM
            #pragma vertex vp
            #pragma fragment fp

            #define PI 3.141592653589793238462f

            #include "UnityCG.cginc"

            struct VertexData {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vp(VertexData v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Curvature;
            float _VignetteWidth;

            fixed4 fp(v2f i) : SV_Target {
                float2 uv = i.uv * 2.0f - 1.0f;
                float2 offset = uv.yx / _Curvature;
                uv = uv + uv * offset * offset;
                uv = uv * 0.5f + 0.5f;

                fixed4 col = tex2D(_MainTex, uv);
                if (uv.x <= 0.0f || 1.0f <= uv.x || uv.y <= 0.0f || 1.0f <= uv.y)
                    col = 0;
                
                uv = uv * 2.0f - 1.0f;
                float2 vignette = _VignetteWidth / _ScreenParams.xy;
                vignette = smoothstep(0.0f, vignette, 1.0f - abs(uv));
                vignette = saturate(vignette);

                float crtLine = (sin(i.uv.y * _ScreenParams.y * 2.0f) + 1.0f) / 2.0f;
                crtLine += 0.5f;

                col *= crtLine;

                col = saturate(col);
                return col * vignette.x * vignette.y;
            }
            ENDCG
        }
    }
}