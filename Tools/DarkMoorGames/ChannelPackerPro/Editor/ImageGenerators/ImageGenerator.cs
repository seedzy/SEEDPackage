using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public abstract class ImageGenerator : ScriptableObject
    {
        protected ComputeShader shader;
        public abstract string Kernel { get; }

        public static ImageGenerator CreateImageGenerator(GeneratorAttribute attribute)
        {
            ImageGenerator generator = (ImageGenerator)CreateInstance(attribute.Type);
            generator.hideFlags = HideFlags.DontSave;
            generator.name = attribute.DisplayName;
            return generator;
        }
        public abstract ComputeShader GetComputeShader();
        public abstract void OnUpdateShaderProperties();
    }
}
