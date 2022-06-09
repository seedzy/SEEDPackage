using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(BrightnessContrastPostprocessor), "Brightness and Contrast", "Brightness and Contrast")]
    public sealed class BrightnessContrastPostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float brightness;
        [SerializeField]
        float contrast;

        public override string Kernel
        {
            get
            {
                return "PostprocessBrightnessContrast";
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
            shader.SetFloat(ShaderPropertyCache.BrightnessID, brightness);
            shader.SetFloat(ShaderPropertyCache.ContrastID, contrast);
        }
    }
}

