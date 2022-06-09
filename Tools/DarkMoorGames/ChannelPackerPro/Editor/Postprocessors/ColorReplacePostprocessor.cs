using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(ColorReplacePostprocessor), "Color Replace", "Color Replace")]
    public sealed class ColorReplacePostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float min = 0.0f;
        [SerializeField]
        float max = 0.5f;

        [SerializeField]
        Color sourceColor = new Color(1f, 1f, 1f, 1f);
        [SerializeField]
        Color targetColor = new Color(0f, 0f, 0f, 1f);

        public override string Kernel
        {
            get
            {
                return "PostprocessColorReplace";
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
            shader.SetVector(ShaderPropertyCache.Color1ID, sourceColor);
            shader.SetVector(ShaderPropertyCache.Color2ID, targetColor);
            shader.SetFloat(ShaderPropertyCache.MinID, min);
            shader.SetFloat(ShaderPropertyCache.MaxID, max);
        }
    }
}
