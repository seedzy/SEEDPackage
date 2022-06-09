using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(CloudNoiseGenerator), "Generate/Noise/Clouds", "Clouds")]
    public sealed class CloudNoiseGenerator : ImageGenerator
    {
        [SerializeField]
        float scale = 10f;
        [SerializeField]
        int octaves = 4;
        [SerializeField]
        float offsetX = 0f;
        [SerializeField]
        float offsetY = 0f;

        public override string Kernel
        {
            get
            {
                return "GenerateImageClouds";
            }
        }
        public override ComputeShader GetComputeShader()
        {
            if (shader == null)
            {
                UtilityData data = ChannelPackUtility.GetData();
                shader = data.ImageGeneratorShader;
            }
            return shader;
        }
        public override void OnUpdateShaderProperties()
        {
            shader.SetFloat(ShaderPropertyCache.ScaleID, scale);
            shader.SetInt(ShaderPropertyCache.IntValueID, octaves);
            shader.SetFloat(ShaderPropertyCache.OffsetXID, offsetX);
            shader.SetFloat(ShaderPropertyCache.OffsetYID, offsetY);
        }
    }
}
