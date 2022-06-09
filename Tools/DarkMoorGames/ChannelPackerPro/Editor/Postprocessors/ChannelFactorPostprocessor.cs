using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(ChannelFactorPostprocessor), "Channel Factor", "Channel Factor")]
    public sealed class ChannelFactorPostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float redFactor = 1f;
        [SerializeField]
        float greenFactor = 1f;
        [SerializeField]
        float blueFactor = 1f;
        [SerializeField]
        float alphaFactor = 1f;

        public override string Kernel
        {
            get
            {
                return "PostprocessChannelFactor";
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
            shader.SetFloat(ShaderPropertyCache.RedFactorID, redFactor);
            shader.SetFloat(ShaderPropertyCache.GreenFactorID, greenFactor);
            shader.SetFloat(ShaderPropertyCache.BlueFactorID, blueFactor);
            shader.SetFloat(ShaderPropertyCache.AlphaFactorID, alphaFactor);
        }
    }
}
