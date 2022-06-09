using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(ColorToAlphaPostprocessor), "Color To Alpha", "Color To Alpha")]
    public class ColorToAlphaPostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float min = 0f;
        [SerializeField]
        float max = 0.5f;
        [SerializeField]
        Color color = new Color(1f, 1f, 1f, 1f);

        public override string Kernel
        {
            get
            {
                return "PostprocessColorToAlpha";
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
            shader.SetFloat(ShaderPropertyCache.MinID, min);
            shader.SetFloat(ShaderPropertyCache.MaxID, max);
            shader.SetVector(ShaderPropertyCache.Color1ID, color);
        }
    }
}
