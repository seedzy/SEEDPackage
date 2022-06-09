using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(CircleGenerator))]
    public class CircleGeneratorEditor : Editor
    {
        SerializedProperty scale;
        SerializedProperty grid;
        SerializedProperty hardness;
        SerializedProperty offsetX;
        SerializedProperty offsetY;
        SerializedProperty color;

        private void OnEnable()
        {
            if (target == null)
                return;
            scale = serializedObject.FindProperty("scale");
            grid = serializedObject.FindProperty("grid");
            hardness = serializedObject.FindProperty("hardness");
            offsetX = serializedObject.FindProperty("offsetX");
            offsetY = serializedObject.FindProperty("offsetY");
            color = serializedObject.FindProperty("color");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;

            serializedObject.UpdateIfRequiredOrScript();

            grid.intValue = EditorGUILayout.IntSlider(grid.displayName, grid.intValue, 1, 50);
            scale.floatValue = EditorGUILayout.Slider(scale.displayName, scale.floatValue, 0.1f, 1f);
            hardness.floatValue = EditorGUILayout.Slider(hardness.displayName, hardness.floatValue, 0f, 1f);
            offsetX.floatValue = EditorGUILayout.Slider(offsetX.displayName, offsetX.floatValue, -0.5f, 0.5f);
            offsetY.floatValue = EditorGUILayout.Slider(offsetY.displayName, offsetY.floatValue, -0.5f, 0.5f);
            color.colorValue = EditorGUILayout.ColorField(new GUIContent(color.displayName), color.colorValue, true, false, false);

            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
