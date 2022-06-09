using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(GreyScalePostprocessor), "Grey Scale", "Grey Scale")]
    public class GreyScalePostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float amount = 1f;

        public override string Kernel
        {
            get
            {
                return "PostprocessGreyScale";
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
            shader.SetFloat(ShaderPropertyCache.ValueID, amount);
        }
    }
}
