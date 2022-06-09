using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class InputImage : Image
    {
        ImageGenerator generator;

        public ImageGenerator Generator
        {
            get
            {
                return generator;
            }
        }

        protected override void OnCreate(Texture2D sourceTexture)
        {
            base.OnCreate(sourceTexture);
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            DestroyImmediate(generator);
            generator = null;
        }
        public void RebuildGenerator(GeneratorAttribute attribute)
        {
            if (!generator || generator.GetType() != attribute.Type)
            {
                BuildGenerator(attribute);
            }
        }
        void BuildGenerator(GeneratorAttribute attribute)
        {
            DestroyImmediate(generator);
            generator = ImageGenerator.CreateImageGenerator(attribute);
            name = generator.name;
        }
    }
}
