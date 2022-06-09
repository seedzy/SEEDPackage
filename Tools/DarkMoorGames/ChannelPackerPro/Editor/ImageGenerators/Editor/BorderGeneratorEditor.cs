using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(BorderGenerator))]
    public sealed class BorderGeneratorEditor : Editor
    {
        SerializedProperty color1;
        SerializedProperty color2;
        SerializedProperty thickness;

        private void OnEnable()
        {
            if (target == null)
                return;
            color1 = serializedObject.FindProperty("color1");
            color2 = serializedObject.FindProperty("color2");
            thickness = serializedObject.FindProperty("thickness");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;
            serializedObject.UpdateIfRequiredOrScript();

            EditorGUILayout.PropertyField(color1);
            EditorGUILayout.PropertyField(color2);

            EditorGUI.BeginChangeCheck();
            EditorGUILayout.PropertyField(thickness);
            if (EditorGUI.EndChangeCheck())
            {
                thickness.intValue = Mathf.Clamp(thickness.intValue, 1, 8192);
            }
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
