using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Postprocessor(typeof(NormalMapPostprocessor), "Normal Map", "Normal Map")]
    public sealed class NormalMapPostprocessor : ImagePostprocessor
    {
        [SerializeField]
        float strength = 5f;

        public override string Kernel
        {
            get
            {
                return "PostprocessNormalMap";
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
            shader.SetFloat(ShaderPropertyCache.StrengthID, strength);
        }
    }
}
