using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class ImageGeneratorWindow : EditorWindow
    {
        EditorWindow parent;

        PackingGroup group;
        int inputImageIndex;
        GeneratorAttribute attribute;

        int inputWidth = 1024;
        int inputHeight = 1024;

        Editor cache;
        Vector2 scrollView;

        public static void ShowImageGeneratorAuxWindow(PackingGroup group, int inputImageIndex, GeneratorAttribute attribute, EditorWindow parent)
        {
            ImageGeneratorWindow window = CreateInstance<ImageGeneratorWindow>();
            window.hideFlags = HideFlags.DontSave;
            window.parent = parent;
            window.group = group;
            window.inputImageIndex = inputImageIndex;
            window.attribute = attribute;

            if (group.TargetWidth != 0 && group.TargetHeight != 0)
            {
                window.SetWindowGenerateMode();
                group.UpdateGeneratedImage(inputImageIndex, attribute);
                Editor.CreateCachedEditor(group.InputImages[inputImageIndex].Generator, null, ref window.cache);
                parent.Repaint();
            }
            else
            {
                window.SetWindowCreateImageMode();
            }
            window.ShowAuxWindow();
        }
        void OnDestroy()
        {
            DestroyImmediate(cache);
        }
        void OnGUI()
        {
            UtilityData data = ChannelPackUtility.GetData();

            if (data.GeneratorAttributes.Length > 0)
            {
                if (group.TargetWidth == 0 && group.TargetHeight == 0)
                {
                    EditorGUI.BeginChangeCheck();
                    inputWidth = EditorGUILayout.IntField("Image Width", inputWidth);
                    inputHeight = EditorGUILayout.IntField("Image Height", inputHeight);
                    if (EditorGUI.EndChangeCheck())
                    {
                        inputWidth = Mathf.Clamp(inputWidth, 4, ChannelPackUtility.MAX_TEXTURE_SIZE);
                        inputHeight = Mathf.Clamp(inputHeight, 4, ChannelPackUtility.MAX_TEXTURE_SIZE);
                    }

                    EditorGUILayout.BeginHorizontal();
                    GUILayout.FlexibleSpace();
                    if (GUILayout.Button("Create"))
                    {
                        SetWindowGenerateMode();

                        group.TargetWidth = inputWidth;
                        group.TargetHeight = inputHeight;

                        group.UpdateGeneratedImage(inputImageIndex, attribute);

                        Editor.CreateCachedEditor(group.InputImages[inputImageIndex].Generator, null, ref cache);
                        parent.Repaint();
                    }
                    EditorGUILayout.EndHorizontal();
                }
                else
                {
                    EditorGUILayout.BeginVertical();
                    EditorGUI.BeginChangeCheck();
                    if (cache != null)
                    {
                        scrollView = GUILayout.BeginScrollView(scrollView, false, true);
                        cache.OnInspectorGUI();
                        GUILayout.EndScrollView();
                    }
                    if (EditorGUI.EndChangeCheck())
                    {
                        group.UpdateGeneratedImage(inputImageIndex, attribute);
                        parent.Repaint();
                    }
                    EditorGUILayout.EndVertical();
                }
            }
        }
        void SetWindowCreateImageMode()
        {
            titleContent = new GUIContent("Create Image");
            minSize = new Vector2(250f, 65f);
            maxSize = minSize;
            Repaint();
        }
        void SetWindowGenerateMode()
        {
            titleContent = new GUIContent(attribute.DisplayName);
            minSize = new Vector2(250f, 200f);
            maxSize = minSize;
            Repaint();
        }
    }
}
