using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public abstract class Image : ScriptableObject
    {
        public const int DEFAULT_PREVIEW_CHANNEL = 0;
        int previewChannel = DEFAULT_PREVIEW_CHANNEL;

        [SerializeField]
        ImagePostprocessor[] imagePostprocessors;

        public int PreviewChannel
        {
            get
            {
                return previewChannel;
            }
            set
            {
                previewChannel = value;
                ChannelPackUtility.UpdateImagePreview(this);
            }
        }
        public RenderTexture PreviewRenderTexture { get; private set; }
        public RenderTexture SourceRenderTexture { get; private set; }
        public RenderTexture PostprocessedRenderTexture { get; private set; }
        public ImagePostprocessor[] ImagePostprocessors
        {
            get
            {
                return imagePostprocessors;
            }
        }
        public int Width { get; private set; }
        public int Height { get; private set; }

        public static T CreateImage<T>(Texture2D sourceTexture) where T : Image
        {
            T image = CreateInstance<T>();
            image.OnCreate(sourceTexture);
            return image;
        }
        protected virtual void OnCreate(Texture2D sourceTexture)
        {
            int width = sourceTexture.width;
            int height = sourceTexture.height;

            name = sourceTexture.name;
            hideFlags = HideFlags.HideAndDontSave;

            Width = width;
            Height = height;

            RenderTexture previewRenderTexture = new RenderTexture(width, height, 0, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear)
            {
                hideFlags = HideFlags.HideAndDontSave,
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                antiAliasing = 1,
                enableRandomWrite = true,
                useMipMap = false,
                autoGenerateMips = false,
                dimension = UnityEngine.Rendering.TextureDimension.Tex2D
            };
            previewRenderTexture.Create();
            previewRenderTexture.DiscardContents(false, true);

            RenderTexture sourceRenderTexture = new RenderTexture(width, height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear)
            {
                hideFlags = HideFlags.HideAndDontSave,
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                antiAliasing = 1,
                enableRandomWrite = true,
                useMipMap = false,
                autoGenerateMips = false,
                dimension = UnityEngine.Rendering.TextureDimension.Tex2D
            };
            sourceRenderTexture.Create();
            sourceRenderTexture.DiscardContents(false, true);

            RenderTexture postprocessedRenderTexture = new RenderTexture(width, height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear)
            {
                hideFlags = HideFlags.HideAndDontSave,
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                antiAliasing = 1,
                enableRandomWrite = true,
                useMipMap = false,
                autoGenerateMips = false,
                dimension = UnityEngine.Rendering.TextureDimension.Tex2D
            };
            postprocessedRenderTexture.Create();
            postprocessedRenderTexture.DiscardContents(false, true);

            SourceRenderTexture = sourceRenderTexture;
            PreviewRenderTexture = previewRenderTexture;
            PostprocessedRenderTexture = postprocessedRenderTexture;

            ChannelPackUtility.CopyTexture(sourceTexture, sourceRenderTexture, true);
        }
        protected virtual void OnDestroy()
        {
            if (SourceRenderTexture)
            {
                SourceRenderTexture.Release();
                DestroyImmediate(SourceRenderTexture);
            }
            if (PreviewRenderTexture)
            {
                PreviewRenderTexture.Release();
                DestroyImmediate(PreviewRenderTexture);
            }
            if (PostprocessedRenderTexture)
            {
                PostprocessedRenderTexture.Release();
                DestroyImmediate(PostprocessedRenderTexture);
            }
            if (imagePostprocessors != null)
            {
                for (int i = 0; i < imagePostprocessors.Length; i++)
                    DestroyImmediate(imagePostprocessors[i]);
                imagePostprocessors = null;
            }

            SourceRenderTexture = null;
            PreviewRenderTexture = null;
            PostprocessedRenderTexture = null;
        }
        public RenderTexture GetSourceTexture()
        {
            if (AnyPostprocessorEnabled())
                return PostprocessedRenderTexture;
            return SourceRenderTexture;
        }
        public bool AnyPostprocessorEnabled()
        {
            if (imagePostprocessors == null)
                return false;
            for (int i = 0; i < imagePostprocessors.Length; i++)
            {
                if (imagePostprocessors[i].Enabled)
                    return true;
            }
            return false;
        }
    }
}
