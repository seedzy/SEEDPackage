using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(CheckerBoardGenerator), "Generate/Patterns/Checker Board", "Checker Board")]
    public sealed class CheckerBoardGenerator : ImageGenerator
    {
        [SerializeField]
        int size = 2;

        [SerializeField]
        Color color1 = new Color(1f, 1f, 1f, 1f);
        [SerializeField]
        Color color2 = new Color(0f, 0f, 0f, 1f);

        public override string Kernel
        {
            get
            {
                return "GenerateImageCheckerBoard";
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
            shader.SetInt(ShaderPropertyCache.IntValueID, size);
            shader.SetVector(ShaderPropertyCache.Color1ID, color1);
            shader.SetVector(ShaderPropertyCache.Color2ID, color2);
        }
    }
}
