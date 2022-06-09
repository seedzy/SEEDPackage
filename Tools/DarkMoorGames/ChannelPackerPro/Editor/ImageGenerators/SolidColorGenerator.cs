using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(SolidColorGenerator), "Generate/Misc/Solid Color", "Solid Color")]
    public sealed class SolidColorGenerator : ImageGenerator
    {
        [SerializeField]
        Color color = new Color(1f, 1f, 1f, 1f);
        public override string Kernel
        {
            get
            {
                return "GenerateImageSolidColor";
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
            shader.SetVector(ShaderPropertyCache.Color1ID, color);
        }
    }
}