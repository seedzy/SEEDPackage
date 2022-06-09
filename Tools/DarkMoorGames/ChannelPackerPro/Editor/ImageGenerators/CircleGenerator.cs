using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(CircleGenerator), "Generate/Shapes/Circle", "Circle")]
    public class CircleGenerator : ImageGenerator
    {
        [SerializeField]
        int grid = 1;
        [SerializeField]
        float scale = 0.5f;
        [SerializeField]
        float hardness = 0.5f;
        [SerializeField]
        float offsetX = 0f;
        [SerializeField]
        float offsetY = 0f;
        [SerializeField]
        Color color = new Color(1f, 1f, 1f, 1f);

        public override string Kernel
        {
            get
            {
                return "GenerateImageCircle";
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
            shader.SetFloat(ShaderPropertyCache.OffsetXID, offsetX);
            shader.SetFloat(ShaderPropertyCache.OffsetYID, offsetY);
            shader.SetFloat(ShaderPropertyCache.HardnessID, hardness);
            shader.SetFloat(ShaderPropertyCache.ScaleID, scale);

            shader.SetInt(ShaderPropertyCache.IntValueID, grid);
            shader.SetVector(ShaderPropertyCache.Color1ID, color);
        }
    }
}
