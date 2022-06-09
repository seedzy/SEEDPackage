using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class UtilityData : ScriptableObject
    {
        Preferences preferences;
        GUICache guiContentCache;

        ComputeShader channelPackShader;
        ComputeShader channelPreviewShader;

        ComputeShader imagePostprocessorShader;
        ComputeShader imageGeneratorShader;

        RenderTexture temporyRenderTexture;

        GeneratorAttribute[] generatorAttributes;
        PostprocessorAttribute[] postprocessorAttributes;

        Template[] templates;
        string[] exportFormats;

        public string outputPrefix = string.Empty;

        int activePackingGroupIndex;
        List<PackingGroup> packingGroups;

        public GeneratorAttribute[] GeneratorAttributes
        {
            get
            {
                return generatorAttributes;
            }
        }
        public PostprocessorAttribute[] PostprocessorAttributes
        {
            get
            {
                return postprocessorAttributes;
            }
        }
        public ComputeShader ChannelPackShader
        {
            get
            {
                return channelPackShader;
            }
        }
        public ComputeShader ChannelPreviewShader
        {
            get
            {
                return channelPreviewShader;
            }
        }
        public ComputeShader ImageGeneratorShader
        {
            get
            {
                return imageGeneratorShader;
            }
        }
        public ComputeShader ImagePostprocessorShader
        {
            get
            {
                return imagePostprocessorShader;
            }
        }
        public RenderTexture TemporyRenderTexture
        {
            get
            {
                return temporyRenderTexture;
            }
            set
            {
                temporyRenderTexture = value;
            }
        }
        public GUICache GUICache
        {
            get
            {
                return guiContentCache;
            }
        }
        public Preferences Preferences
        {
            get
            {
                return preferences;
            }
        }
        public int ActivePackingGroupIndex
        {
            get
            {
                return activePackingGroupIndex;
            }
        }
        public string[] ExportFormats
        {
            get
            {
                return exportFormats;
            }
        }

        public static UtilityData Create()
        {
            UtilityData data = CreateInstance<UtilityData>();
            data.hideFlags = HideFlags.HideAndDontSave;
            data.exportFormats = new string[] { ".png", ".jpg", ".tga" };
            data.preferences = Preferences.Create();
            data.guiContentCache = GUICache.Create();
            data.GetRequiredShaders();
            data.GetImageGeneratorAndPostprocessorTypes();
            data.packingGroups = new List<PackingGroup>
            {
                PackingGroup.Create("New Image")
            };
            return data;
        }
        void OnEnable()
        {
            AssemblyReloadEvents.afterAssemblyReload -= AfterAssemblyReload;
            AssemblyReloadEvents.afterAssemblyReload += AfterAssemblyReload;
        }
        void OnDestroy()
        {
            AssemblyReloadEvents.afterAssemblyReload -= AfterAssemblyReload;

            if (guiContentCache)
            {
                DestroyImmediate(guiContentCache);
                guiContentCache = null;
            }
            if (preferences)
            {
                DestroyImmediate(preferences);
                preferences = null;
            }
            if (temporyRenderTexture)
            {
                temporyRenderTexture.Release();
                DestroyImmediate(temporyRenderTexture);
                temporyRenderTexture = null;
            }

            DestroyPackingGroups();

            channelPackShader = null;
            channelPreviewShader = null;
            imagePostprocessorShader = null;
            imageGeneratorShader = null;
        }
        void AfterAssemblyReload()
        {
            GetImageGeneratorAndPostprocessorTypes();
        }
        void GetImageGeneratorAndPostprocessorTypes()
        {
            Assembly[] assemblies = AppDomain.CurrentDomain.GetAssemblies();

            List<Type> imageGeneratorTypesList = new List<Type>();
            List<Type> imagePostprocessorTypesList = new List<Type>();

            List<GeneratorAttribute> generatorAttributeList = new List<GeneratorAttribute>();
            List<PostprocessorAttribute> postprocessorAttributeList = new List<PostprocessorAttribute>();

            for (int i = 0; i < assemblies.Length; i++)
            {
                Type[] assemblyTypes = assemblies[i].GetTypes();
                for (int j = 0; j < assemblyTypes.Length; j++)
                {
                    if (assemblyTypes[j].IsSubclassOf(typeof(ImageGenerator)))
                    {
                        imageGeneratorTypesList.Add(assemblyTypes[j]);

                        GeneratorAttribute attribute = (GeneratorAttribute)assemblyTypes[j].GetCustomAttribute(typeof(GeneratorAttribute), false);
                        if (attribute != null)
                            generatorAttributeList.Add(attribute);
                    }
                    else if (assemblyTypes[j].IsSubclassOf(typeof(ImagePostprocessor)))
                    {
                        imagePostprocessorTypesList.Add(assemblyTypes[j]);

                        PostprocessorAttribute attribute = (PostprocessorAttribute)assemblyTypes[j].GetCustomAttribute(typeof(PostprocessorAttribute), false);
                        if (attribute != null)
                            postprocessorAttributeList.Add(attribute);
                    }
                }
            }

            postprocessorAttributes = postprocessorAttributeList.ToArray();
            generatorAttributes = generatorAttributeList.ToArray();

            if (imageGeneratorTypesList.Count != generatorAttributes.Length)
            {
                for (int i = 0; i < imageGeneratorTypesList.Count; i++)
                {
                    if (imageGeneratorTypesList[i].GetCustomAttribute(typeof(GeneratorAttribute)) == null)
                    {
                        Debug.LogWarning("Missing (GeneratorAttribute) on the type (" + imageGeneratorTypesList[i].Name + ")");
                    }
                }
            }
            if (imagePostprocessorTypesList.Count != postprocessorAttributes.Length)
            {
                for (int i = 0; i < imagePostprocessorTypesList.Count; i++)
                {
                    if (imagePostprocessorTypesList[i].GetCustomAttribute(typeof(PostprocessorAttribute)) == null)
                    {
                        Debug.LogWarning("Missing (PostprocessorAttribute) on the type (" + imagePostprocessorTypesList[i].Name + ")");
                    }
                }
            }

            generatorAttributeList.Clear();
            postprocessorAttributeList.Clear();
            imageGeneratorTypesList.Clear();
            imagePostprocessorTypesList.Clear();
        }
        void GetRequiredShaders()
        {
            int foundCount = 0;
            string[] guids = AssetDatabase.FindAssets("t:ComputeShader");
            for (int i = 0; i < guids.Length; i++)
            {
                ComputeShader foundShader = AssetDatabase.LoadAssetAtPath<ComputeShader>(AssetDatabase.GUIDToAssetPath(guids[i]));
                if (foundShader == null)
                    continue;

                if (foundShader.name == "ChannelPackShader")
                {
                    channelPackShader = foundShader;
                    foundCount++;
                }
                else if (foundShader.name == "ChannelPreviewShader")
                {
                    channelPreviewShader = foundShader;
                    foundCount++;
                }
                else if (foundShader.name == "ImageGeneratorShader")
                {
                    imageGeneratorShader = foundShader;
                    foundCount++;
                }
                else if (foundShader.name == "ImagePostprocessorShader")
                {
                    imagePostprocessorShader = foundShader;
                    foundCount++;
                }

                if (foundCount == 4)
                    break;
            }
        }
        void SaveTemplate()
        {
            string path = EditorUtility.SaveFilePanelInProject("Save Template", string.Empty, "asset", "Save a Template of the Packing Group names and options.");
            if (path == string.Empty)
                return;

            Template template = CreateInstance<Template>();
            template.SetTemplateData(packingGroups);

            AssetDatabase.CreateAsset(template, path);
            AssetDatabase.Refresh();
        }
        void FindTemplatesInProject()
        {
            string[] guids = AssetDatabase.FindAssets("t:DarkMoorGames.ChannelPackerPro.Template");
            templates = new Template[guids.Length];

            for (int i = 0; i < guids.Length; i++)
            {
                Template template = AssetDatabase.LoadAssetAtPath<Template>(AssetDatabase.GUIDToAssetPath(guids[i]));
                templates[i] = template;
            }
        }
        void DestroyPackingGroups()
        {
            for (int i = 0; i < packingGroups.Count; i++)
                DestroyImmediate(packingGroups[i]);
            packingGroups.Clear();
        }
        public void ResetToDefaultPackingGroups(bool resetPrefix)
        {
            DestroyPackingGroups();
            packingGroups.Add(PackingGroup.Create("New Image"));
            activePackingGroupIndex = 0;
            if (resetPrefix)
                outputPrefix = string.Empty;
        }
        public void RemoveAllPackingGroupImages()
        {
            for (int i = 0; i < packingGroups.Count; i++)
                packingGroups[i].DestroyAllImages();
        }
        public GeneratorAttribute GetGeneratorAttribute(ImageGenerator generator)
        {
            if (!generator)
                return null;

            for (int i = 0; i < generatorAttributes.Length; i++)
            {
                if (generatorAttributes[i].Type == generator.GetType())
                {
                    return generatorAttributes[i];
                }
            }
            return null;
        }
        public string[] GetPackingGroupNames(PackingGroup ignore)
        {
            return ChannelPackUtility.GetObjectNames(ignore, packingGroups);
        }
        public string[] GetPackingGroupNames()
        {
            return ChannelPackUtility.GetObjectNames(packingGroups);
        }
        public PackingGroup GetSelectedPackingGroup()
        {
            return packingGroups[activePackingGroupIndex];
        }
        public void SetSelectedPackingGroup(int index)
        {
            activePackingGroupIndex = index;
        }
        public PackingGroup GetPackingGroup(int index)
        {
            if (index > packingGroups.Count - 1 || index < 0)
                return null;
            return packingGroups[index];
        }
        public int PackingGroupCount()
        {
            return packingGroups.Count;
        }
        public void AddPackingGroup(PackingGroup group, bool selectAdded)
        {
            packingGroups.Add(group);
            if (selectAdded)
                activePackingGroupIndex = packingGroups.Count - 1;
        }
        public void RemovePackingGroup(int index)
        {
            DestroyImmediate(packingGroups[index]);
            packingGroups.RemoveAt(index);

            if (index < activePackingGroupIndex)
                activePackingGroupIndex -= 1;
            activePackingGroupIndex = Mathf.Clamp(activePackingGroupIndex, 0, packingGroups.Count - 1);
        }
        public void SetTemplate(object data)
        {
            Template template = (Template)data;
            int id = EditorUtility.DisplayDialogComplex("Set Template", "Do you want to set the template " + template.name + "?", "Keep Images", "Cancel", "Clear Images");
            if (id == 1)
                return;

            if (id == 0)
            {
                if (packingGroups.Count != template.Data.Count)
                {
                    if (packingGroups.Count > template.Data.Count)
                    {
                        while (packingGroups.Count != template.Data.Count)
                        {
                            int index = packingGroups.Count - 1;
                            DestroyImmediate(packingGroups[index]);
                            packingGroups.RemoveAt(index);
                        }
                    }
                    for (int i = 0; i < template.Data.Count; i++)
                    {
                        if (i < packingGroups.Count)
                        {
                            packingGroups[i].SetPackingGroupData(template.Data[i]);
                        }
                        else
                        {
                            packingGroups.Add(PackingGroup.Create(template.Data[i]));
                        }
                    }
                }
                else
                {
                    for (int i = 0; i < template.Data.Count; i++)
                    {
                        packingGroups[i].SetPackingGroupData(template.Data[i]);
                    }
                }
            }
            else if (id == 2)
            {
                DestroyPackingGroups();
                for (int i = 0; i < template.Data.Count; i++)
                    packingGroups.Add(PackingGroup.Create(template.Data[i]));
            }

            if (activePackingGroupIndex > packingGroups.Count - 1)
                activePackingGroupIndex = packingGroups.Count - 1;
        }
        public GenericMenu GetTemplateGenericMenu()
        {
            FindTemplatesInProject();

            GenericMenu menu = new GenericMenu();
            menu.AddItem(new GUIContent("Save Template..."), false, SaveTemplate);
            if (templates.Length > 0)
            {
                menu.AddSeparator("");
                for (int i = 0; i < templates.Length; i++)
                {
                    menu.AddItem(new GUIContent(templates[i].name), false, SetTemplate, templates[i]);
                }
            }
            return menu;
        }
    }
}
