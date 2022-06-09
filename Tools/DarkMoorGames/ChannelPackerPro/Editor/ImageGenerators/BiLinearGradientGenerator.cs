using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(BiLinearGradientGenerator), "Generate/Gradients/Bi-Linear Gradient", "Bi-Linear Gradient")]
    public sealed class BiLinearGradientGenerator : ImageGenerator
    {
        [SerializeField]
        float rotation = 0f;
        [SerializeField]
        float hardness = 0.5f;
        [SerializeField]
        Color start = new Color(1f, 1f, 1f, 1f);
        [SerializeField]
        Color end = new Color(0f, 0f, 0f, 1f);

        public override string Kernel
        {
            get
            {
                return "GenerateImageBiLinearGradient";
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
            shader.SetVector(ShaderPropertyCache.Color1ID, start);
            shader.SetVector(ShaderPropertyCache.Color2ID, end);
            shader.SetFloat(ShaderPropertyCache.HardnessID, hardness);
            shader.SetFloat(ShaderPropertyCache.RotationID, rotation);
        }
    }
}
