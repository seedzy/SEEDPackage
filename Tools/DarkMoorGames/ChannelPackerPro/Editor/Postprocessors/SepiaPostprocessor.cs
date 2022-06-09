using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(SepiaPostprocessor), "Sepia", "Sepia")]
    public sealed class SepiaPostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float amount = 1f;

        public override string Kernel
        {
            get
            {
                return "PostprocessSepia";
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
