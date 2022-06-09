using System.IO;
using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class PackingGroup : ScriptableObject
    {
        public int extensionIndex;

        int targetWidth;
        int targetHeight;

        InputImage[] inputImages;
        OutputImage outputImage;

        string[] sourceInputNames;

        PackOption packOption1;
        PackOption packOption2;
        PackOption packOption3;
        PackOption packOption4;

        public int TargetWidth
        {
            get
            {
                return targetWidth;
            }
            set
            {
                targetWidth = value;
            }
        }
        public int TargetHeight
        {
            get
            {
                return targetHeight;
            }
            set
            {
                targetHeight = value;
            }
        }

        public OutputImage OutputImage
        {
            get
            {
                return outputImage;
            }
            set
            {
                outputImage = value;
            }
        }
        public string[] SourceInputNames
        {
            get
            {
                return sourceInputNames;
            }
        }
        public InputImage[] InputImages
        {
            get
            {
                return inputImages;
            }
        }

        public PackOption PackOption1
        {
            get
            {
                return packOption1;
            }
        }
        public PackOption PackOption2
        {
            get
            {
                return packOption2;
            }
        }
        public PackOption PackOption3
        {
            get
            {
                return packOption3;
            }
        }
        public PackOption PackOption4
        {
            get
            {
                return packOption4;
            }
        }
        public string OutputName
        {
            get
            {
                return ChannelPackUtility.GetData().outputPrefix + name;
            }
        }
        public string OutputRichTextName
        {
            get
            {
                UtilityData data = ChannelPackUtility.GetData();
                return string.Format("<color={2}>{0}</color>{1}", data.outputPrefix, name, data.Preferences.prefixTextColorHtml);
            }
        }

        public static PackingGroup Create(string name)
        {
            PackingGroup group = CreateInstance<PackingGroup>();
            group.hideFlags = HideFlags.HideAndDontSave;
            group.name = name;

            group.inputImages = new InputImage[5];
            group.packOption1 = PackOption.CreateOption<PackOptionToRed>(Channel.Red, 1);
            group.packOption2 = PackOption.CreateOption<PackOptionToGreen>(Channel.Green, 2);
            group.packOption3 = PackOption.CreateOption<PackOptionToBlue>(Channel.Blue, 3);
            group.packOption4 = PackOption.CreateOption<PackOptionToAlpha>(Channel.Alpha, 4);

            group.sourceInputNames = new string[5] { "Value", "Image (1)", "Image (2)", "Image (3)", "Image (4)" };
            group.UpdateSourceInputNames();
            return group;
        }
        public static PackingGroup Create(PackingGroupData data)
        {
            PackingGroup group = CreateInstance<PackingGroup>();
            group.hideFlags = HideFlags.HideAndDontSave;
            group.name = data.Name;

            group.inputImages = new InputImage[5];
            group.packOption1 = PackOption.CreateOption<PackOptionToRed>(data.PackOption1);
            group.packOption2 = PackOption.CreateOption<PackOptionToGreen>(data.PackOption2);
            group.packOption3 = PackOption.CreateOption<PackOptionToBlue>(data.PackOption3);
            group.packOption4 = PackOption.CreateOption<PackOptionToAlpha>(data.PackOption4);

            group.sourceInputNames = new string[5] { "Value", "Image (1)", "Image (2)", "Image (3)", "Image (4)" };
            group.UpdateSourceInputNames();
            return group;
        }
        public void SetPackingGroupData(PackingGroupData data)
        {
            name = data.Name;

            packOption1.SetPackOptionData(data.PackOption1);
            packOption2.SetPackOptionData(data.PackOption2);
            packOption3.SetPackOptionData(data.PackOption3);
            packOption4.SetPackOptionData(data.PackOption4);

            UpdateSourceInputNames();

            PackInputToOutputAll(true);
        }
        void OnDestroy()
        {
            DestroyAllImages();

            DestroyImmediate(packOption1);
            DestroyImmediate(packOption2);
            DestroyImmediate(packOption3);
            DestroyImmediate(packOption4);
        }
        bool HasLoadedInputImage()
        {
            for (int i = 1; i < 5; i++)
            {
                if (inputImages[i])
                    return true;
            }
            return false;
        }
        int GetLoadedInputImageCount()
        {
            int count = 0;
            for (int i = 1; i < 5; i++)
            {
                if (inputImages[i])
                    count++;
            }
            return count;
        }
        void UpdateSourceInputNames()
        {
            for (int i = 1; i < 5; i++)
            {
                if (inputImages[i])
                    sourceInputNames[i] = inputImages[i].name + " (" + i + ")";
                else
                    sourceInputNames[i] = "Image (" + i + ")";
            }
        }
        public void DestroyInputImage(int index)
        {
            DestroyImmediate(inputImages[index]);
            inputImages[index] = null;

            UpdateSourceInputNames();

            if (!HasLoadedInputImage())
            {
                targetWidth = 0;
                targetHeight = 0;

                DestroyImmediate(outputImage);
                outputImage = null;
            }
            else
            {
                PackInputToOutputAll();
            }
        }
        public void DestroyAllImages()
        {
            for (int i = 1; i < 5; i++)
            {
                DestroyImmediate(inputImages[i]);
            }
            DestroyImmediate(outputImage);
            UpdateSourceInputNames();

            targetWidth = 0;
            targetHeight = 0;
        }
        public void UpdateSourceInputName(int index)
        {
            // 0 is always value
            if (index == 0)
                return;

            if (inputImages[index])
                sourceInputNames[index] = inputImages[index].name + " (" + index + ")";
            else
                sourceInputNames[index] = "Image (" + index + ")";
        }
        public void PackInputToOutput(PackOption option)
        {
            if (outputImage)
            {
                UtilityData data = ChannelPackUtility.GetData();
                if (data.Preferences.autoUpdate)
                {
                    ChannelPackUtility.PackInputToOutput(option, outputImage, inputImages[option.inputImageIndex]);
                    ChannelPackUtility.PostprocessImage(outputImage);
                    ChannelPackUtility.UpdateImagePreview(outputImage);
                }
            }
        }
        public void PackInputToOutputAll(bool forceUpdate = false)
        {
            if (outputImage)
            {
                UtilityData data = ChannelPackUtility.GetData();
                if (data.Preferences.autoUpdate || forceUpdate)
                {
                    ChannelPackUtility.PackInputToOutput(packOption1, outputImage, inputImages[packOption1.inputImageIndex]);
                    ChannelPackUtility.PackInputToOutput(packOption2, outputImage, inputImages[packOption2.inputImageIndex]);
                    ChannelPackUtility.PackInputToOutput(packOption3, outputImage, inputImages[packOption3.inputImageIndex]);
                    ChannelPackUtility.PackInputToOutput(packOption4, outputImage, inputImages[packOption4.inputImageIndex]);

                    ChannelPackUtility.PostprocessImage(outputImage);
                    ChannelPackUtility.UpdateImagePreview(outputImage);
                }
            }
        }
        public void FindAndTryPostprocessImage(Image image)
        {
            if (image == outputImage)
            {
                if (ChannelPackUtility.GetData().Preferences.autoUpdate)
                {
                    ChannelPackUtility.PostprocessImage(image);
                    ChannelPackUtility.UpdateImagePreview(image);
                }
            }
            else
            {
                for (int i = 1; i < 5; i++)
                {
                    if (inputImages[i] == image)
                    {
                        ChannelPackUtility.PostprocessImage(image);
                        ChannelPackUtility.UpdateImagePreview(image);
                        TryPackInputToOutput(inputImages[i]);
                        break;
                    }
                }
            }
        }
        public bool LoadImageFromPath(string path, int inputIndex)
        {
            if (path == string.Empty)
                return false;

            ChannelPackUtility.GetData().Preferences.lastLoadSaveDirectory = Path.GetDirectoryName(path);

            if (!path.StartsWith("Assets"))
            {
                string relative = FileUtil.GetProjectRelativePath(path);
                if (relative != string.Empty)
                {
                    path = relative;
                }
            }

            bool ValidImporter(AssetImporter importer, bool autoFix)
            {
                if (importer == null)
                    return false;
                if (importer.GetType() != typeof(TextureImporter))
                    return false;

                bool isValid = true;

                try
                {
                    AssetDatabase.StartAssetEditing();
                    TextureImporter textureImporter = (TextureImporter)importer;
                    TextureImporterPlatformSettings defaultSettings = textureImporter.GetDefaultPlatformTextureSettings();

                    TextureImporterPlatformSettings currentPlatformSettings = textureImporter.GetPlatformTextureSettings(ChannelPackUtility.GetActivePlatformName());
                    if (currentPlatformSettings.overridden)
                    {
                        textureImporter.ClearPlatformTextureSettings(ChannelPackUtility.GetActivePlatformName());
                        textureImporter.SaveAndReimport();
                    }

                    if (textureImporter.textureShape != TextureImporterShape.Texture2D)
                        isValid = false;
                    if (textureImporter.textureType != TextureImporterType.Default)
                        isValid = false;
                    if (textureImporter.alphaIsTransparency)
                        isValid = false;
                    if (defaultSettings.format != TextureImporterFormat.RGBA32)
                        isValid = false;

                    if (!isValid)
                    {
                        if (!autoFix)
                        {
                            if (EditorUtility.DisplayDialog("Fix Import Settings", "Please set :\nTexture Type to Default\nTexture Shape to 2D\nAlpha Is Transparency to false\nFormat to RGBA32", "Auto Fix", "Cancel"))
                            {
                                textureImporter.textureShape = TextureImporterShape.Texture2D;
                                textureImporter.textureType = TextureImporterType.Default;
                                textureImporter.alphaIsTransparency = false;

                                defaultSettings.format = TextureImporterFormat.RGBA32;
                                textureImporter.SetPlatformTextureSettings(defaultSettings);
                                textureImporter.SaveAndReimport();

                                isValid = true;
                            }
                        }
                        else
                        {
                            textureImporter.textureShape = TextureImporterShape.Texture2D;
                            textureImporter.textureType = TextureImporterType.Default;
                            textureImporter.alphaIsTransparency = false;

                            defaultSettings.format = TextureImporterFormat.RGBA32;
                            textureImporter.SetPlatformTextureSettings(defaultSettings);
                            textureImporter.SaveAndReimport();

                            isValid = true;
                        }
                    }
                }
                finally
                {
                    AssetDatabase.StopAssetEditing();
                }
                return isValid;
            }
            bool LoadFromPath(string assetPath)
            {
                Texture2D asset = AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath);
                if (targetWidth != 0 && targetHeight != 0)
                {
                    if (GetLoadedInputImageCount() == 1 && inputImages[inputIndex])
                    {
                        DestroyImmediate(outputImage);
                    }
                    else if (asset.width != targetWidth || asset.height != targetHeight)
                    {
                        EditorUtility.DisplayDialog("Failed To Load Image", "Input Resolution: " + asset.width + " * " + asset.height + "\nOutput Resolution: " + targetWidth + " * " + targetHeight + "\n\nThe Input and Output Resolution need to be equal to load, You could try resizing the texture you want to load from its import settings.", "Ok");
                        return false;
                    }
                }

                targetWidth = asset.width;
                targetHeight = asset.height;

                DestroyImmediate(inputImages[inputIndex]);

                InputImage image = Image.CreateImage<InputImage>(asset);
                inputImages[inputIndex] = image;
                UpdateSourceInputName(inputIndex);
                ChannelPackUtility.UpdateImagePreview(image);

                if (outputImage == null)
                {
                    outputImage = Image.CreateImage<OutputImage>(asset);
                    PackInputToOutputAll(true);
                }
                else
                {
                    TryPackInputToOutput(image);
                }
                return true;
            }

            if (ValidImporter(AssetImporter.GetAtPath(path), false))
            {
                return LoadFromPath(path);
            }
            else
            {
                if (!path.StartsWith("Assets"))
                {
                    FileInfo info = new FileInfo(path);
                    if (ChannelPackUtility.SupportedLoadFormat(info.Extension))
                    {
                        if (EditorUtility.DisplayDialog("Import Asset", "Do you want to import " + info.Name + " to the assets folder then copy to the image slot?", "Import and Load", "Cancel"))
                        {
                            string importedAssetPath = AssetDatabase.GenerateUniqueAssetPath("Assets/" + info.Name);
                            FileUtil.CopyFileOrDirectory(path, importedAssetPath);
                            AssetDatabase.ImportAsset(importedAssetPath);
                            AssetImporter importer = AssetImporter.GetAtPath(importedAssetPath);

                            if (ValidImporter(importer, true))
                            {
                                bool loaded = LoadFromPath(importedAssetPath);
                                Object importedObject = AssetDatabase.LoadAssetAtPath<Object>(importedAssetPath);
                                Selection.activeObject = importedObject;
                                EditorGUIUtility.PingObject(importedObject);
                                return loaded;
                            }
                        }
                    }
                }
            }
            return false;
        }
        public void UpdateGeneratedImage(int inputIndex, GeneratorAttribute attribute)
        {
            InputImage image = inputImages[inputIndex];
            if (image != null)
            {
                image.RebuildGenerator(attribute);
                ChannelPackUtility.GenerateImage(image, image.Generator);
                ChannelPackUtility.PostprocessImage(image);
                ChannelPackUtility.UpdateImagePreview(image);

                TryPackInputToOutput(image);
            }
            else
            {
                Texture2D texture = new Texture2D(targetWidth, targetHeight, TextureFormat.RGBA32, false, false)
                {
                    hideFlags = HideFlags.HideAndDontSave,
                    filterMode = FilterMode.Bilinear
                };

                DestroyImmediate(image);

                image = Image.CreateImage<InputImage>(texture);
                inputImages[inputIndex] = image;
                image.RebuildGenerator(attribute);
                ChannelPackUtility.GenerateImage(image, image.Generator);
                ChannelPackUtility.UpdateImagePreview(image);

                if (outputImage == null)
                {
                    outputImage = Image.CreateImage<OutputImage>(texture);
                    PackInputToOutputAll(true);
                }
                else
                {
                    TryPackInputToOutput(image);
                }
                DestroyImmediate(texture);
            }
            UpdateSourceInputName(inputIndex);
        }
        void TryPackInputToOutput(InputImage input, bool forceUpdate = false)
        {
            if (outputImage)
            {
                UtilityData data = ChannelPackUtility.GetData();
                if (data.Preferences.autoUpdate || forceUpdate)
                {
                    InputImage option1Image = inputImages[packOption1.inputImageIndex];
                    InputImage option2Image = inputImages[packOption2.inputImageIndex];
                    InputImage option3Image = inputImages[packOption3.inputImageIndex];
                    InputImage option4Image = inputImages[packOption4.inputImageIndex];
                    bool changed = false;

                    if (input == option1Image)
                    {
                        ChannelPackUtility.PackInputToOutput(packOption1, outputImage, input);
                        changed = true;
                    }
                    if (input == option2Image)
                    {
                        ChannelPackUtility.PackInputToOutput(packOption2, outputImage, input);
                        changed = true;
                    }
                    if (input == option3Image)
                    {
                        ChannelPackUtility.PackInputToOutput(packOption3, outputImage, input);
                        changed = true;
                    }
                    if (input == option4Image)
                    {
                        ChannelPackUtility.PackInputToOutput(packOption4, outputImage, input);
                        changed = true;
                    }
                    if (changed)
                    {
                        ChannelPackUtility.PostprocessImage(outputImage);
                        ChannelPackUtility.UpdateImagePreview(outputImage);
                    }
                }
            }
        }
    }
}
