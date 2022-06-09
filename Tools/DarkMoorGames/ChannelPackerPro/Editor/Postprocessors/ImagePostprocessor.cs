using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public abstract class ImagePostprocessor : ScriptableObject
    {
        protected ComputeShader shader;

        [SerializeField]
        bool enabled;

        public abstract string Kernel { get; }
        public bool Enabled
        {
            get
            {
                return enabled;
            }
        }

        public static ImagePostprocessor CreatePostprocessor(PostprocessorAttribute attribute, bool enable)
        {
            ImagePostprocessor postprocessor = (ImagePostprocessor)CreateInstance(attribute.Type);
            postprocessor.name = attribute.DisplayName;
            postprocessor.hideFlags = HideFlags.DontSave;
            postprocessor.enabled = enable;
            return postprocessor;
        }
        public abstract ComputeShader GetComputeShader();
        public abstract void OnUpdateShaderProperties();
    }
}
