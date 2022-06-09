using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Generator(typeof(VoronoiGenerator), "Generate/Noise/Voronoi", "Voronoi")]
    public sealed class VoronoiGenerator : ImageGenerator
    {
        [SerializeField]
        VoronoiMethod method;
        [SerializeField]
        float scale = 10f;
        [SerializeField]
        float offsetX;
        [SerializeField]
        float offsetY;

        public override string Kernel
        {
            get
            {
                switch (method)
                {
                    case VoronoiMethod.Euclidien:
                        return "GenerateImageVoronoiEuclidien";
                    case VoronoiMethod.Manhattan:
                        return "GenerateImageVoronoiManhattan";
                }
                return string.Empty;
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
            shader.SetFloat(ShaderPropertyCache.ScaleID, scale);
            shader.SetFloat(ShaderPropertyCache.OffsetXID, offsetX);
            shader.SetFloat(ShaderPropertyCache.OffsetYID, offsetY);
        }
    }
}
