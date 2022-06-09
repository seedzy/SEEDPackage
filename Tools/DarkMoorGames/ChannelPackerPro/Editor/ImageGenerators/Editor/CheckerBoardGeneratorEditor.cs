using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(CheckerBoardGenerator))]
    public class CheckerBoardGeneratorEditor : Editor
    {
        SerializedProperty size;
        SerializedProperty color1;
        SerializedProperty color2;

        private void OnEnable()
        {
            if (target == null)
                return;
            size = serializedObject.FindProperty("size");
            color1 = serializedObject.FindProperty("color1");
            color2 = serializedObject.FindProperty("color2");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;
            serializedObject.UpdateIfRequiredOrScript();

            EditorGUI.BeginChangeCheck();
            EditorGUILayout.PropertyField(size);
            if (EditorGUI.EndChangeCheck())
            {
                size.intValue = Mathf.Clamp(size.intValue, 2, 8192);
            }
            EditorGUILayout.PropertyField(color1);
            EditorGUILayout.PropertyField(color2);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
