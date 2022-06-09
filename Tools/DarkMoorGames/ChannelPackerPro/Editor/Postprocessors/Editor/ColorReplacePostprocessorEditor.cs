using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(ColorReplacePostprocessor))]
    public class ColorReplacePostprocessorEditor : Editor
    {
        SerializedProperty min;
        SerializedProperty max;
        SerializedProperty sourceColor;
        SerializedProperty targetColor;

        GUIStyle label;

        private void OnEnable()
        {
            if (target == null)
                return;
            min = serializedObject.FindProperty("min");
            max = serializedObject.FindProperty("max");
            sourceColor = serializedObject.FindProperty("sourceColor");
            targetColor = serializedObject.FindProperty("targetColor");
        }
        public override void OnInspectorGUI()
        {
            if (label == null)
            {
                label = new GUIStyle(EditorStyles.miniBoldLabel)
                {
                    imagePosition = ImagePosition.TextOnly,
                    fontStyle = FontStyle.Bold,
                    alignment = TextAnchor.MiddleLeft,
                    margin = new RectOffset(0, 0, 0, 0)
                };
            }
            serializedObject.UpdateIfRequiredOrScript();

            float minValue = min.floatValue;
            float maxValue = max.floatValue;
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.MinMaxSlider("Range", ref minValue, ref maxValue, 0f, 1f);
            EditorGUILayout.LabelField("[" + minValue.ToString("F1") + "," + maxValue.ToString("F1") + "]", label, GUILayout.Width(65f));
            EditorGUILayout.EndHorizontal();
            if (EditorGUI.EndChangeCheck())
            {
                min.floatValue = minValue;
                max.floatValue = maxValue;
            }
            sourceColor.colorValue = EditorGUILayout.ColorField(new GUIContent(sourceColor.displayName, sourceColor.tooltip), sourceColor.colorValue, true, false, false);
            targetColor.colorValue = EditorGUILayout.ColorField(new GUIContent(targetColor.displayName, targetColor.tooltip), targetColor.colorValue, true, false, false);

            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
