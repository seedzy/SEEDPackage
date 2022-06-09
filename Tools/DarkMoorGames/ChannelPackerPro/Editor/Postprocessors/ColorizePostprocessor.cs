using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(ColorizePostprocessor), "Colorize", "Colorize")]
    public sealed class ColorizePostprocessor : ImagePostprocessor
    {
        [SerializeField]
        Color color = new Color(1f, 0f, 0f, 1f);

        public override string Kernel
        {
            get
            {
                return "PostprocessColorize";
            }
        }
        public override ComputeShader GetComputeShader()
        {
            if (shader == null)
            {
                UtilityData data = ChannelPackUtility.GetData();
                shader = data.ImagePostprocessorShader;
            }
            return shader;
        }
        public override void OnUpdateShaderProperties()
        {
            shader.SetVector(ShaderPropertyCache.Color1ID, color);
        }
    }
}
