using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(BorderGenerator), "Generate/Misc/Border", "Border")]
    public sealed class BorderGenerator : ImageGenerator
    {
        [SerializeField]
        Color color1 = new Color(1f, 1f, 1f, 1f);
        [SerializeField]
        Color color2 = new Color(0f, 0f, 0f, 1f);
        [SerializeField, Tooltip("Thickness in pixels")]
        int thickness = 4;

        public override string Kernel
        {
            get
            {
                return "GenerateImageBorder";
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
            shader.SetVector(ShaderPropertyCache.Color1ID, color1);
            shader.SetVector(ShaderPropertyCache.Color2ID, color2);
            shader.SetInt(ShaderPropertyCache.ThicknessID, thickness);
        }
    }
}
