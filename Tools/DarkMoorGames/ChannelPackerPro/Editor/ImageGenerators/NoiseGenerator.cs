using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(NoiseGenerator), "Generate/Noise/Generic Noise", "Noise")]
    public class NoiseGenerator : ImageGenerator
    {
        public override string Kernel
        {
            get
            {
                return "GenerateImageNoise";
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

        }
    }
}
