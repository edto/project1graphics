/**
 * Based on shader from:
 * http://gist.github.com/Rajigo/4d0bfca9a3d90f3eba1c6c7377cbd90c#file-myphongshader-shader
 * Modified by Eddy To for COMP30019 07-09-16
 *
 * Phong Lighting/Illumination surface shader for a terrain. Combined with
 * dynamic texturing for terrain based on height.
 */

Shader "PhongLighting"
{
	Properties
	{
		_MainTint ("Diffuse Tint", Color) = (0.97, 1.0, 0.77, 1.0)
		_SpecularColor ("Specular Color", Color) = (1.0, 0.93, 0.71, 1.0)
		_SpecPower ("Specular Power", Range(0,100)) = 35
		_ReflectionCoefficient ("Reflection Coefficient", Range(0,1)) = 0.55

		_04Colour ("04 Colour", Color) = (0.83, 0.96, 1.0, 1.0)
		_04Level ("04 Level", Float) = 600
		_03Colour ("03 Colour", Color) = (0.84, 0.80, 0.67, 1.0)
		_03Level ("03 Level", Float) = 550
		_02Colour ("02 Colour", Color) = (0.67, 0.76, 0.66, 1.0)
		_02Level ("02 Level", Float) = 500
		_01Colour ("01 Colour", Color) = (0.25, 0.43, 0.28, 1.0)
		_00Level ("01 Level", Float) = 450
		_00Colour ("00 Colour", Color) = (0.13, 0.34, 0.62, 1.0)
	}

	SubShader
	{
		CGPROGRAM
		#pragma surface surf Phong vertex:vert

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

    	float _04Level;
    	float4 _04Colour;
    	float _03Level;
    	float4 _03Colour;
    	float _02Level;
    	float4 _02Colour;
    	float _Level1;
    	float4 _01Colour;
    	float _Slope;
    	float _00Level;
    	float4 _00Colour;

		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecPower;
		float _ReflectionCoefficient;

		half4 LightingPhong(SurfaceOutput a, fixed3 lightDir, half3 viewDir, fixed atten)
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
			c.a = 1.0;
			return c;

		}

		/** Apply texturing based on height */
		void surf(Input IN, inout SurfaceOutput o)
		{
            if (IN.worldPos.y >= _04Level)
                o.Albedo = _04Colour;

            if (IN.worldPos.y <= _04Level)
                o.Albedo = lerp(_03Colour, _04Colour, (IN.worldPos.y - _03Level)
                				/(_04Level - _03Level));

            if (IN.worldPos.y <= _03Level)
                o.Albedo = lerp(_02Colour, _03Colour, (IN.worldPos.y - _02Level)
                				/(_03Level - _02Level));

            if (IN.worldPos.y <= _02Level)
                o.Albedo = lerp(_01Colour, _02Colour, (IN.worldPos.y - _00Level)
                				/(_02Level - _00Level));

            if (IN.worldPos.y <= _00Level)
                o.Albedo = _00Colour;
        }

		ENDCG
	}
	FallBack "Diffuse"
}