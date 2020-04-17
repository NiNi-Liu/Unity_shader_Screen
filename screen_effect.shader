Shader "kenny_effect/screen_effect"
{
    Properties
    {
		[Header(Input)]
        _Color ("Screen tint", Color) = (1,1,1,1)
		[Space]
		_EmissonTex("EmissonTex", 2D) = "white" {}
		_EmissonMask("EmissonMask", 2D) = "white" {}
		_BumpMap("Bumpmap", 2D) = "bump" {}
		[Space(30)]
		[Header(Parameter)]
		[PowerSlider(3)]_EmissionStrength("Emission Pow", Range(0,10)) = 1
		_NormalStrength("Normal Pow", Range(0,2)) = 1
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _EmissonTex,_EmissonMask,_BumpMap;

        struct Input
        {
			float2 uv_EmissonTex;
			float2 uv_EmissonMask;
			float2 uv_BumpMap;
        };

        half _Glossiness;
        half _Metallic;
		fixed _EmissionStrength, _NormalStrength;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
			fixed4 e = tex2D(_EmissonTex, IN.uv_EmissonTex);
			fixed4 m = tex2D(_EmissonMask, IN.uv_EmissonMask);
			fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			n.xy *= _NormalStrength;
            o.Albedo = m * _Color;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
			//-------add----------------------------------
			o.Emission = e*m*_EmissionStrength;
			o.Normal = n;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
