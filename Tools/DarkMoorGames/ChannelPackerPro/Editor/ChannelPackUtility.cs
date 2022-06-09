using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public static class ChannelPackUtility
    {
        public const int MAX_TEXTURE_SIZE = 8192;

        static UtilityData data;

        static RenderTexture GetTemporyRenderTexture(Image image)
        {
            UtilityData data = GetData();

            if (data.TemporyRenderTexture == null)
            {
                data.TemporyRenderTexture = new RenderTexture(image.Width, image.Height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear)
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
                data.TemporyRenderTexture.Create();
                data.TemporyRenderTexture.DiscardContents(false, true);
                return data.TemporyRenderTexture;
            }
            if (data.TemporyRenderTexture.width != image.Width || data.TemporyRenderTexture.height != image.Height)
            {
                Object.DestroyImmediate(data.TemporyRenderTexture);

                data.TemporyRenderTexture = new RenderTexture(image.Width, image.Height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear)
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
                data.TemporyRenderTexture.Create();
                data.TemporyRenderTexture.DiscardContents(false, true);
                return data.TemporyRenderTexture;
            }
            return data.TemporyRenderTexture;
        }
        static bool CanUsePackOptionModifers(PackOption option, bool hasImage)
        {
            if (option.inputImageIndex == 0)
                return true;
            if (option.inputImageIndex != 0 && hasImage)
                return true;
            return false;
        }
        static UtilityData FindUtillityData()
        {
            UtilityData[] all = Resources.FindObjectsOfTypeAll<UtilityData>();
            UtilityData found = null;
            if (all.Length > 0)
            {
                for (int i = 0; i < all.Length; i++)
                {
                    if (!EditorUtility.IsPersistent(all[i]))
                    {
                        found = all[i];
                        break;
                    }
                }
            }
            return found;
        }
        public static UtilityData GetData()
        {
            if (data == null)
            {
                data = FindUtillityData();
                if (data == null)
                    data = UtilityData.Create();
            }
            return data;
        }
        public static void Init()
        {
            GetData();
        }
        public static void Cleanup()
        {
            Object.DestroyImmediate(FindUtillityData());
            data = null;
            EditorUtility.UnloadUnusedAssetsImmediate();
        }
        public static void UpdateImagePreview(Image image)
        {
            UtilityData data = GetData();
            int threadX = Mathf.CeilToInt(image.Width / 8f);
            int threadY = Mathf.CeilToInt(image.Height / 8f);
            int kernel;

            switch (image.PreviewChannel)
            {
                case 0:
                    kernel = data.ChannelPreviewShader.FindKernel("PreviewRGBA");
                    break;
                case 1:
                    kernel = data.ChannelPreviewShader.FindKernel("PreviewRGB");
                    break;
                case 2:
                    kernel = data.ChannelPreviewShader.FindKernel("PreviewRed");
                    break;
                case 3:
                    kernel = data.ChannelPreviewShader.FindKernel("PreviewGreen");
                    break;
                case 4:
                    kernel = data.ChannelPreviewShader.FindKernel("PreviewBlue");
                    break;
                case 5:
                    kernel = data.ChannelPreviewShader.FindKernel("PreviewAlpha");
                    break;
                default:
                    kernel = 0;
                    break;
            }
            data.ChannelPreviewShader.SetBool(ShaderPropertyCache.LinearSpaceID, PlayerSettings.colorSpace == ColorSpace.Linear);
            data.ChannelPreviewShader.SetTexture(kernel, ShaderPropertyCache.InputID, image.GetSourceTexture());
            data.ChannelPreviewShader.SetTexture(kernel, ShaderPropertyCache.OutputID, image.PreviewRenderTexture);
            data.ChannelPreviewShader.Dispatch(kernel, threadX, threadY, 1);
        }
        public static string[] GetObjectNames<T>(List<T> objects) where T : Object
        {
            string[] names = new string[objects.Count];
            for (int i = 0; i < names.Length; i++)
                names[i] = objects[i].name;
            return names;
        }
        public static string[] GetObjectNames<T>(T ingore, List<T> objects) where T : Object
        {
            List<string> nameList = new List<string>(objects.Count);

            int count = objects.Count;
            for (int i = 0; i < count; i++)
            {
                if (ingore != objects[i])
                    nameList.Add(objects[i].name);
            }
            string[] names = nameList.ToArray();
            nameList.Clear();
            return names;
        }
        public static void GenerateImage(InputImage input, ImageGenerator generator)
        {
            int threadX = Mathf.CeilToInt(input.Width / 8f);
            int threadY = Mathf.CeilToInt(input.Height / 8f);

            ComputeShader shader = generator.GetComputeShader();
            int kernel = shader.FindKernel(generator.Kernel);

            generator.OnUpdateShaderProperties();

            shader.SetInt(ShaderPropertyCache.ImageWidthID, input.Width);
            shader.SetInt(ShaderPropertyCache.ImageHeightID, input.Height);

            shader.SetTexture(kernel, ShaderPropertyCache.OutputID, input.SourceRenderTexture);
            shader.Dispatch(kernel, threadX, threadY, 1);
        }
        public static void PackInputToOutput(PackOption option, OutputImage outputImage, InputImage input)
        {
            UtilityData data = GetData();

            bool hasInputImage = input;

            RenderTexture tmp = GetTemporyRenderTexture(outputImage);

            CopyTexture(outputImage.SourceRenderTexture, tmp);

            int threadX = Mathf.CeilToInt(outputImage.Width / 8f);
            int threadY = Mathf.CeilToInt(outputImage.Height / 8f);

            int kernel = data.ChannelPackShader.FindKernel(option.GetPackKernel(hasInputImage));
            bool useModifer = CanUsePackOptionModifers(option, hasInputImage);

            data.ChannelPackShader.SetFloat(ShaderPropertyCache.ValueID, useModifer ? option.value : 0f);
            data.ChannelPackShader.SetBool(ShaderPropertyCache.InvertID, useModifer && option.invertChannel);

            if (hasInputImage)
                data.ChannelPackShader.SetTexture(kernel, ShaderPropertyCache.InputID, input.GetSourceTexture());

            data.ChannelPackShader.SetTexture(kernel, ShaderPropertyCache.OriginalID, tmp);
            data.ChannelPackShader.SetTexture(kernel, ShaderPropertyCache.OutputID, outputImage.SourceRenderTexture);
            data.ChannelPackShader.Dispatch(kernel, threadX, threadY, 1);
        }
        public static string GetImageFilterModeName(Image image)
        {
            if (image == null)
                return "Bilinear";
            if (image.PreviewRenderTexture.filterMode == FilterMode.Bilinear)
                return "Bilinear";
            if (image.PreviewRenderTexture.filterMode == FilterMode.Point)
                return "Point";
            return string.Empty;
        }
        public static void PostprocessImage(Image image)
        {
            if (image.AnyPostprocessorEnabled())
            {
                int threadX = Mathf.CeilToInt(image.Width / 8f);
                int threadY = Mathf.CeilToInt(image.Height / 8f);

                RenderTexture tmp = GetTemporyRenderTexture(image);

                bool beganPostprocessing = false;
                for (int i = 0; i < image.ImagePostprocessors.Length; i++)
                {
                    ImagePostprocessor postprocessor = image.ImagePostprocessors[i];
                    if (postprocessor.Enabled)
                    {
                        if (!beganPostprocessing)
                        {
                            CopyTexture(image.SourceRenderTexture, tmp);
                            beganPostprocessing = true;
                        }

                        ComputeShader shader = postprocessor.GetComputeShader();
                        int kernel = shader.FindKernel(postprocessor.Kernel);

                        postprocessor.OnUpdateShaderProperties();

                        shader.SetInt(ShaderPropertyCache.ImageWidthID, image.Width);
                        shader.SetInt(ShaderPropertyCache.ImageHeightID, image.Height);

                        shader.SetTexture(kernel, ShaderPropertyCache.OriginalID, tmp);
                        shader.SetTexture(kernel, ShaderPropertyCache.OutputID, image.PostprocessedRenderTexture);

                        shader.Dispatch(kernel, threadX, threadY, 1);

                        if (i != image.ImagePostprocessors.Length - 1)
                            CopyTexture(image.PostprocessedRenderTexture, tmp);
                    }
                }
            }
        }
        public static byte[] GenerateOutput(OutputImage image, string extension)
        {
            Texture2D texture = new Texture2D(image.Width, image.Height, TextureFormat.RGBA32, false, false);

            RenderTexture current = RenderTexture.active;
            RenderTexture.active = image.GetSourceTexture();
            texture.ReadPixels(new Rect(0, 0, image.Width, image.Height), 0, 0);
            texture.Apply(false);
            RenderTexture.active = current;

            byte[] bytes = GetTextureEncoded(texture, extension);
            Object.DestroyImmediate(texture);
            return bytes;
        }
        public static bool SupportedExportFormat(string extension)
        {
            switch (extension)
            {
                case ".png":
                case ".jpeg":
                case ".jpg":
                case ".JPG":
                case ".tga":
                    return true;
            }
            return false;
        }
        public static bool SupportedLoadFormat(string extension)
        {
            switch (extension)
            {
                case ".png":
                case ".jpeg":
                case ".jpg":
                case ".JPG":
                case ".tga":
                case ".tif":
                case ".psd":
                    return true;
            }
            return false;
        }
        public static string GetSupportedExportFormatsLog()
        {
            return ".png, .jpg or .tga";
        }
        public static string GetSupportedLoadFormatsFilter()
        {
            return "png,jpg,tga,tif,psd";
        }
        public static string GetChannelFirstLetter(Channel channel)
        {
            string letter = "";
            switch (channel)
            {
                case Channel.Red:
                    letter = "R";
                    break;
                case Channel.Green:
                    letter = "G";
                    break;
                case Channel.Blue:
                    letter = "B";
                    break;
                case Channel.Alpha:
                    letter = "A";
                    break;
            }
            return letter;
        }
        public static Color GetChannelColor(Channel channel)
        {
            Color color = new Color(1f, 1f, 1f, 1f);
            switch (channel)
            {
                case Channel.Red:
                    color = new Color(1f, 0f, 0f, 1f);
                    break;
                case Channel.Green:
                    color = new Color(0f, 1f, 0f, 1f);
                    break;
                case Channel.Blue:
                    color = new Color(0f, 0.15f, 1f, 1f);
                    break;
                case Channel.Alpha:
                    color = new Color(1f, 1f, 1f, 1f);
                    break;
            }
            return color;
        }
        public static void CopyTexture(Texture source, Texture destination, bool useMaxTextureLimit = false)
        {
            if (useMaxTextureLimit)
            {
                int limit = QualitySettings.masterTextureLimit;
                QualitySettings.masterTextureLimit = 0;
                Graphics.CopyTexture(source, 0, 0, 0, 0, source.width, source.height, destination, 0, 0, 0, 0);
                QualitySettings.masterTextureLimit = limit;
            }
            else
            {
                Graphics.CopyTexture(source, 0, 0, 0, 0, source.width, source.height, destination, 0, 0, 0, 0);
            }
        }
        public static string GetActivePlatformName()
        {
            switch (EditorUserBuildSettings.activeBuildTarget)
            {
                case BuildTarget.StandaloneWindows:
                case BuildTarget.StandaloneWindows64:
                case BuildTarget.StandaloneOSX:
                case BuildTarget.StandaloneLinux64:
                    return "Standalone";
                case BuildTarget.Android:
                    return "Android";
                case BuildTarget.iOS:
                    return "iPhone";
                case BuildTarget.tvOS:
                    return "tvOS";
                case BuildTarget.PS4:
                    return "PS4";
                case BuildTarget.PS5:
                    return "PS5";
                case BuildTarget.WebGL:
                    return "WebGL";
                case BuildTarget.XboxOne:
                    return "XboxOne";
                case BuildTarget.Switch:
                    return "Nintendo Switch";
                case BuildTarget.WSAPlayer:
                    return "Windows Store Apps";
                default:
                    return "Default";
            }
        }
        static byte[] GetTextureEncoded(Texture2D texture, string extension)
        {
            switch (extension)
            {
                case ".png":
                    return texture.EncodeToPNG();
                case ".jpeg":
                case ".jpg":
                case ".JPG":
                    return texture.EncodeToJPG(GetData().Preferences.jpgQuality);
                case ".tga":
                    return texture.EncodeToTGA();
            }
            return null;
        }
    }
}
