using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(ColorToAlphaPostprocessor))]
    public class ColorToAlphaPostprocessorEditor : Editor
    {
        SerializedProperty min;
        SerializedProperty max;
        SerializedProperty color;

        GUIStyle label;

        private void OnEnable()
        {
            if (target == null)
                return;

            color = serializedObject.FindProperty("color");
            min = serializedObject.FindProperty("min");
            max = serializedObject.FindProperty("max");
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
            EditorGUILayout.MinMaxSlider("Smooth", ref minValue, ref maxValue, 0f, 1f);
            EditorGUILayout.LabelField("[" + minValue.ToString("F1") + "," + maxValue.ToString("F1") + "]", label, GUILayout.Width(65f));
            EditorGUILayout.EndHorizontal();
            if (EditorGUI.EndChangeCheck())
            {
                min.floatValue = minValue;
                max.floatValue = maxValue;
            }

            color.colorValue = EditorGUILayout.ColorField(new GUIContent(color.displayName, color.tooltip), color.colorValue, true, false, false);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
