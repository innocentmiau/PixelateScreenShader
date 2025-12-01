Shader "PixelateScreenShader/Pixelate"
{
    Properties
    {
        _PixelSize ("Pixel Size", Float) = 5.0
    }
    
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "Queue" = "Transparent"
        }
        
        ZWrite Off
        ZTest Always
        Cull Off
        Blend One Zero
        
        Pass
        {
            Name "Pixelate"
            
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
            
            SAMPLER(sampler_BlitTexture);
            
            float _PixelSize;
            
            half4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                
                float2 screenSize = _ScreenParams.xy;
                float2 pixelCount = screenSize / _PixelSize;
                float2 pixelCoord = input.texcoord * pixelCount;
                float2 snappedPixel = floor(pixelCoord);
                float2 pixelatedUV = (snappedPixel + 0.5) / pixelCount;
                
                half4 col = SAMPLE_TEXTURE2D_X(
                    _BlitTexture,
                    sampler_BlitTexture,
                    pixelatedUV
                );
                
                return col;
            }
            ENDHLSL
        }
    }
}