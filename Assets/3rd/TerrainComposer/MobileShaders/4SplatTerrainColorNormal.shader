 Shader "MobileTerrain/4SplatTerrainColorNormal" {
    Properties {
      _Color ("Color",Color) = (1,1,1,1)
      [NoScaleOffset] _Colormap ("Colormap", 2D) = "white" {}
      [NoScaleOffset] _Saturate ("Saturate",Range(0,1)) = 1
      [NoScaleOffset] _BumpMap ("Normal map", 2D) = "bump" {}
      _Strength ("Normal map strength",Range(0,1)) = 1
      
      [NoScaleOffset] _MainTex ("Splatmap 1-4", 2D) = "white" {}
      
      [NoScaleOffset] _Splat1 ("Splat Texture 1", 2D) = "white" {}
      [NoScaleOffset] _Splat2 ("Splat Texture 2", 2D) = "white" {}
      [NoScaleOffset] _Splat3 ("Splat Texture 3", 2D) = "white" {}
      [NoScaleOffset] _Splat4 ("Splat Texture 4", 2D) = "white" {}
      
      _Splat1Size ("Splat Texture 1 Tiling",float) = 50
      _Splat2Size ("Splat Texture 2 Tiling",float) = 50
      _Splat3Size ("Splat Texture 3 Tiling",float) = 50
      _Splat4Size ("Splat Texture 4 Tiling",float) = 50
      
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
      #pragma surface surf Lambert vertex:vert 
      // #pragma target 3.0
     
      sampler2D _MainTex;
      sampler2D _BumpMap;
      sampler2D _Colormap;
	  sampler2D _Splat1, _Splat2, _Splat3, _Splat4;
      
	  half _Splat1Size, _Splat2Size, _Splat3Size, _Splat4Size;
      half _Strength;
      half _Saturate;
      half3 _Color;
      
      struct Input {
        half2 uv_MainTex;
        half3 wNormal; 
      };
      
      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.wNormal = v.normal;
      }
      
      void surf (Input IN, inout SurfaceOutput o) {
      	half4 splatmap = tex2D (_MainTex, IN.uv_MainTex);
        o.Albedo = (tex2D (_Splat1,IN.uv_MainTex*_Splat1Size)*splatmap.r)+(tex2D (_Splat2,IN.uv_MainTex*_Splat2Size)*splatmap.g)+(tex2D (_Splat3,IN.uv_MainTex*_Splat3Size)*splatmap.b)+(tex2D (_Splat4,IN.uv_MainTex*_Splat4Size)*splatmap.a);
        
        half3 colormap = tex2D (_Colormap,IN.uv_MainTex);
        o.Albedo *= lerp(dot(colormap,half3(0.3,0.59,0.11)),colormap,_Saturate)*_Color*4;
        o.Normal = lerp(half3(IN.wNormal.x,IN.wNormal.z,IN.wNormal.y),UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex)),_Strength);
      }
      ENDCG
    } 
    // Fallback "Diffuse"
  }