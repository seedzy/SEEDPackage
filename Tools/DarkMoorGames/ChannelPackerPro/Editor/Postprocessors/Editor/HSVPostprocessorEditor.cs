using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(HSVPostprocessor))]
    public sealed class HSVPostprocessorEditor : Editor
    {
        SerializedProperty hue;
        SerializedProperty saturation;
        SerializedProperty value;

        void OnEnable()
        {
            if (target == null)
                return;
            hue = serializedObject.FindProperty("hue");
            saturation = serializedObject.FindProperty("saturation");
            value = serializedObject.FindProperty("value");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.UpdateIfRequiredOrScript();

            EditorGUILayout.Slider(hue, 0f, 1f);
            EditorGUILayout.Slider(saturation, -1f, 1f);
            EditorGUILayout.Slider(value, -1f, 1f);

            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
