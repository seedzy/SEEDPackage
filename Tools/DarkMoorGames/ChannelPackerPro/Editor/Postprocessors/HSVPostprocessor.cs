using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(HSVPostprocessor), "HSV", "HSV")]
    public sealed class HSVPostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float hue = 0f;
        [SerializeField]
        float saturation = 0f;
        [SerializeField]
        float value = 0f;

        public override string Kernel
        {
            get
            {
                return "PostprocessHSV";
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
            shader.SetFloat(ShaderPropertyCache.HueID, hue);
            shader.SetFloat(ShaderPropertyCache.SaturationID, saturation);
            shader.SetFloat(ShaderPropertyCache.ValueID, value);
        }
    }
}
