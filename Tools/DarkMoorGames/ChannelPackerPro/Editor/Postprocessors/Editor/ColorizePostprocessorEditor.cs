using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(ColorizePostprocessor))]
    public sealed class ColorizePostprocessorEditor : Editor
    {
        SerializedProperty color;

        void OnEnable()
        {
            if (target == null)
                return;
            color = serializedObject.FindProperty("color");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.UpdateIfRequiredOrScript();
            color.colorValue = EditorGUILayout.ColorField(new GUIContent(color.displayName, color.tooltip), color.colorValue, true, false, false);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
