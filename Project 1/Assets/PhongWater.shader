/**
 * Based on shader from:
 * http://gist.github.com/Rajigo/4d0bfca9a3d90f3eba1c6c7377cbd90c#file-myphongshader-shader
 * Modified by Eddy To for COMP30019 07-09-16
 *
 * Phong Lighting/Illumination surface shader for a terrain. Combined with
 * dynamic texturing for terrain based on height.
 */

Shader "PhongWater"
 {
	Properties
	{
		_MainTint ("Diffuse Tint", Color) = (0.0, 0.18, 0.47, 1.0)
		_SpecularColor ("Specular Color", Color) = (0.57, 0.80, 1.0, 1.0)
		_SpecPower ("Specular Power", Range(0,100)) = 35
		_ReflectionCoefficient ("Reflection Coefficient", Range(0,1)) = 0.55

		_WaterLevel ("Water Height", Float) = 0
		_WaterColor ("Water Colour", Color) = (0.0, 0.11, 0.45, 1.0)
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent"}

		CGPROGRAM
		#pragma surface surf Phong alpha

		struct Input
		{
			float3 customColor;
			float3 worldPos;
		};

		void vert (inout appdata_full v, out Input o)
		{
    		UNITY_INITIALIZE_OUTPUT(Input,o);
        	o.customColor = abs(v.normal.y);
    	}

    	float _WaterLevel;
    	float4 _WaterColor;

		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecPower;
		float _ReflectionCoefficient;

		half4 LightingPhong (SurfaceOutput a, fixed3 lightDir, half3 viewDir, fixed
			atten)
		{
			float NdotL = dot(a.Normal, lightDir);

			/** Reflection vector */
			float3 reflectance = 2.0f * NdotL  * a.Normal - lightDir;

			/** Light colour and intensity */
			float3 c_l = _LightColor0.rgb * max(NdotL, 0);

			/** Material colour */
			fixed4 c_r = _MainTint / 3.14f;

			/** Specular light calculation */
			float c_p = _ReflectionCoefficient * (_SpecPower + 2) / (2 * 3.14f);
			float3 spec = c_p * c_l * pow(dot(normalize(reflectance),normalize(viewDir))
										  , _SpecPower) * _SpecularColor;

			/** Ambient and diffuse components */
			float3 ambient = c_r * c_l;
			float3 diffuse = c_r * c_l * NdotL;

			/** Combining components */
			fixed4 c;
			c.rgb = spec + ambient + diffuse;
			c.a = 0.5;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
                o.Albedo = _WaterColor;
                o.Alpha = _WaterColor.a;
        }

		ENDCG
	}
	FallBack "Diffuse"
}