using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class SettingsPopupContent : PopupWindowContent
    {
        EditorWindow parent;
        Rect templateButtonRect;

        int selected;

        public SettingsPopupContent(EditorWindow parent)
        {
            this.parent = parent;
        }
        public override Vector2 GetWindowSize()
        {
            return new Vector2(300f, 300f);
        }
        public override void OnGUI(Rect rect)
        {
            UtilityData data = ChannelPackUtility.GetData();

            EditorGUILayout.BeginHorizontal(EditorStyles.toolbar);
            selected = GUILayout.Toolbar(selected, new string[3] { "Settings", "Preferences", "Help" }, EditorStyles.toolbarButton);
            EditorGUILayout.EndHorizontal();

            switch (selected)
            {
                case 0:

                    float width = EditorGUIUtility.labelWidth;
                    EditorGUIUtility.labelWidth = 85f;

                    EditorGUI.BeginChangeCheck();
                    data.outputPrefix = EditorGUILayout.TextField(new GUIContent("Output Prefix", "Inserts a prefix to all output image names."), data.outputPrefix);
                    if (EditorGUI.EndChangeCheck())
                    {
                        data.outputPrefix = data.outputPrefix.TrimStart();
                        if (parent)
                            parent.Repaint();
                    }
                    EditorGUIUtility.labelWidth = width;

                    if (EditorGUILayout.DropdownButton(new GUIContent("Template", "Save or Select a Template.\n\nTemplates save packing group names (Ignores the Prefix) and their output settings but they dont save images, postprocessors or generators."), FocusType.Passive))
                    {
                        GenericMenu menu = data.GetTemplateGenericMenu();
                        menu.DropDown(templateButtonRect);
                    }
                    if (Event.current.type == EventType.Repaint)
                        templateButtonRect = GUILayoutUtility.GetLastRect();

                    GUILayout.FlexibleSpace();
                    EditorGUILayout.BeginHorizontal();
                    if (GUILayout.Button(new GUIContent("Clear Active", "Clear the active packing group images but keep the packing group and its output settings.")))
                    {
                        if (!EditorUtility.DisplayDialog("Clear Active Packing Group Images", "Are you sure you want to clear the active packing group images?", "Yes", "No"))
                            return;
                        data.GetSelectedPackingGroup().DestroyAllImages();
                        if (parent)
                            parent.Repaint();
                    }
                    if (GUILayout.Button(new GUIContent("Clear All", "Clear all packing group images but keep the packing groups and their output settings.")))
                    {
                        if (!EditorUtility.DisplayDialog("Clear All Packing Groups Images", "Are you sure you want to clear all packing groups images?", "Yes", "No"))
                            return;
                        data.RemoveAllPackingGroupImages();
                        if (parent)
                            parent.Repaint();
                    }
                    if (GUILayout.Button(new GUIContent("Reset", "Remove all packing groups and their images.")))
                    {
                        int id = EditorUtility.DisplayDialogComplex("Reset To Default", "Are you sure you want to reset the channel packer?\nThis will remove all images and packing groups.", "Reset Keep Prefix", "Cancel", "Reset");
                        if (id == 1)
                            return;
                        data.ResetToDefaultPackingGroups(id == 2);
                        if (parent)
                            parent.Repaint();
                    }
                    EditorGUILayout.EndHorizontal();
                    break;
                case 1:
                    data.Preferences.jpgQuality = EditorGUILayout.IntSlider(new GUIContent("JPG Quality", "JPG compression quality. 100 is best"), data.Preferences.jpgQuality, 1, 100);
                    EditorGUI.BeginChangeCheck();
                    ColorUtility.TryParseHtmlString(data.Preferences.prefixTextColorHtml, out Color color);
                    color = EditorGUILayout.ColorField(new GUIContent("Prefix Text Color"), color, true, false, false);
                    if (EditorGUI.EndChangeCheck())
                    {
                        data.Preferences.prefixTextColorHtml = "#" + ColorUtility.ToHtmlStringRGB(color);
                        if (parent)
                            parent.Repaint();
                    }
                    break;
                case 2:
                    EditorGUILayout.HelpBox(new GUIContent("If you have any issues or need help just get in touch via our website contact form."), true);
                    if (GUILayout.Button(new GUIContent("Email Support", "Opens the default web browser and links to our contact page. If you have issues or feature requests just email us.")))
                    {
                        Application.OpenURL("https://darkmoorgames.com/contact-us");
                    }
                    break;
            }
        }
    }
}
