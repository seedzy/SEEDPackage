using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class PostprocessorWindow : EditorWindow
    {
        PackingGroup group;
        Image image;

        EditorWindow parent;

        Texture2D arrowUpIconDarkTheme;
        Texture2D arrowDownIconDarkTheme;

        Texture2D arrowUpIconLightTheme;
        Texture2D arrowDownIconLightTheme;

        Rect buttonRect;
        Vector2 scrollView;

        public static void ShowPostprocessAuxWindow(PackingGroup group, Image image, EditorWindow parent)
        {
            PostprocessorWindow window = CreateInstance<PostprocessorWindow>();
            window.hideFlags = HideFlags.DontSave;

            window.group = group;
            window.parent = parent;
            window.image = image;

            window.titleContent = new GUIContent("Image Postprocessor");
            window.minSize = new Vector2(300f, 500f);
            window.maxSize = window.minSize;

            window.ShowAuxWindow();
        }
        void Awake()
        {
            arrowUpIconDarkTheme = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/DarkMoorGames/ChannelPackerPro/Editor/Icons/ArrowUpDarkTheme.png");
            arrowDownIconDarkTheme = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/DarkMoorGames/ChannelPackerPro/Editor/Icons/ArrowDownDarkTheme.png");
            arrowUpIconLightTheme = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/DarkMoorGames/ChannelPackerPro/Editor/Icons/ArrowUpLightTheme.png");
            arrowDownIconLightTheme = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/DarkMoorGames/ChannelPackerPro/Editor/Icons/ArrowDownLightTheme.png");
        }
        void OnDestroy()
        {
            arrowUpIconDarkTheme = null;
            arrowDownIconDarkTheme = null;
            arrowUpIconLightTheme = null;
            arrowDownIconLightTheme = null;
        }
        void OnGUI()
        {
            SerializedObject imageObject = new SerializedObject(image);
            SerializedProperty postprocessors = imageObject.FindProperty("imagePostprocessors");

            float width = EditorGUIUtility.labelWidth;
            EditorGUIUtility.labelWidth = 80f;

            if (EditorGUILayout.DropdownButton(new GUIContent("Add Postprocessor"), FocusType.Passive))
            {
                PostprocessorAttribute[] attributes = ChannelPackUtility.GetData().PostprocessorAttributes;

                GenericMenu menu = new GenericMenu();
                menu.allowDuplicateNames = true;
                for (int i = 0; i < attributes.Length; i++)
                {
                    menu.AddItem(attributes[i].MenuContext, false, Add, attributes[i]);
                }
                menu.DropDown(buttonRect);
            }
            if (Event.current.type == EventType.Repaint)
                buttonRect = GUILayoutUtility.GetLastRect();

            bool changed = false;
            scrollView = GUILayout.BeginScrollView(scrollView, false, true);
            for (int i = 0; i < postprocessors.arraySize; i++)
            {
                SerializedProperty postprocessor = postprocessors.GetArrayElementAtIndex(i);

                SerializedObject postprocessorObject = new SerializedObject(postprocessor.objectReferenceValue);
                SerializedProperty enabled = postprocessorObject.FindProperty("enabled");

                EditorGUILayout.BeginHorizontal(EditorStyles.helpBox);
                postprocessorObject.UpdateIfRequiredOrScript();
                EditorGUI.BeginChangeCheck();
                enabled.boolValue = EditorGUILayout.Toggle(enabled.boolValue, GUILayout.Width(16f));
                postprocessorObject.ApplyModifiedPropertiesWithoutUndo();

                postprocessor.isExpanded = EditorGUILayout.Foldout(postprocessor.isExpanded, new GUIContent(postprocessor.objectReferenceValue.name), true);
                EditorGUI.BeginDisabledGroup(i == 0);
                if (GUILayout.Button(new GUIContent(GetUpArrow()), GUILayout.Width(21f), GUILayout.Height(21f)))
                {
                    imageObject.Update();
                    SwapSerializedPropertyObjects(postprocessors.GetArrayElementAtIndex(i), postprocessors.GetArrayElementAtIndex(i - 1));
                    imageObject.ApplyModifiedPropertiesWithoutUndo();
                }
                EditorGUI.EndDisabledGroup();
                EditorGUI.BeginDisabledGroup(i == postprocessors.arraySize - 1);
                if (GUILayout.Button(new GUIContent(GetDownArrow()), GUILayout.Width(21f), GUILayout.Height(21f)))
                {
                    imageObject.Update();
                    SwapSerializedPropertyObjects(postprocessors.GetArrayElementAtIndex(i), postprocessors.GetArrayElementAtIndex(i + 1));
                    imageObject.ApplyModifiedPropertiesWithoutUndo();
                }
                EditorGUI.EndDisabledGroup();
                if (GUILayout.Button("x", GUILayout.Width(21f), GUILayout.Height(21f)))
                {
                    imageObject.Update();
                    postprocessors.GetArrayElementAtIndex(i).objectReferenceValue = null;
                    postprocessors.DeleteArrayElementAtIndex(i);
                    imageObject.ApplyModifiedPropertiesWithoutUndo();

                    group.FindAndTryPostprocessImage(image);
                    parent.Repaint();
                    continue;
                }
                EditorGUILayout.EndHorizontal();

                if (postprocessor.isExpanded)
                {
                    Editor editor = Editor.CreateEditor(postprocessor.objectReferenceValue);
                    if (editor != null)
                    {
                        float labelWidth = EditorGUIUtility.labelWidth;
                        EditorGUIUtility.labelWidth = 100f;
                        EditorGUI.indentLevel++;
                        editor.OnInspectorGUI();
                        EditorGUI.indentLevel--;
                        EditorGUIUtility.labelWidth = labelWidth;
                    }
                    DestroyImmediate(editor);
                }
                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
                postprocessorObject.Dispose();
            }
            GUILayout.EndScrollView();
            EditorGUIUtility.labelWidth = width;
            imageObject.Dispose();

            if (changed)
            {
                group.FindAndTryPostprocessImage(image);
                parent.Repaint();
            }
        }
        void Add(object attributeData)
        {
            PostprocessorAttribute attribute = (PostprocessorAttribute)attributeData;
            SerializedObject serializedObject = new SerializedObject(image);
            SerializedProperty array = serializedObject.FindProperty("imagePostprocessors");

            int index = array.arraySize++;
            array.GetArrayElementAtIndex(index).objectReferenceValue = ImagePostprocessor.CreatePostprocessor(attribute, true);

            serializedObject.ApplyModifiedPropertiesWithoutUndo();
            serializedObject.Dispose();

            group.FindAndTryPostprocessImage(image);
            parent.Repaint();
        }
        void SwapSerializedPropertyObjects(SerializedProperty prop1, SerializedProperty prop2)
        {
            Object currentObject = prop1.objectReferenceValue;
            Object targetObject = prop2.objectReferenceValue;

            bool currentExpanded = prop1.isExpanded;
            bool targetExpanded = prop2.isExpanded;

            prop2.objectReferenceValue = currentObject;
            prop2.isExpanded = currentExpanded;

            prop1.objectReferenceValue = targetObject;
            prop1.isExpanded = targetExpanded;
        }
        Texture2D GetDownArrow()
        {
            if (EditorGUIUtility.isProSkin)
                return arrowDownIconDarkTheme;
            return arrowDownIconLightTheme;
        }
        Texture2D GetUpArrow()
        {
            if (EditorGUIUtility.isProSkin)
                return arrowUpIconDarkTheme;
            return arrowUpIconLightTheme;
        }
    }
}
