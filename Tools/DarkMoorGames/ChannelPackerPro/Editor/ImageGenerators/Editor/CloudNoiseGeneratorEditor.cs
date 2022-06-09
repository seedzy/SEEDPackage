using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(CloudNoiseGenerator))]
    public sealed class CloudNoiseGeneratorEditor : Editor
    {
        SerializedProperty scale;
        SerializedProperty octaves;
        SerializedProperty offsetX;
        SerializedProperty offsetY;

        private void OnEnable()
        {
            if (target == null)
                return;
            scale = serializedObject.FindProperty("scale");
            octaves = serializedObject.FindProperty("octaves");
            offsetX = serializedObject.FindProperty("offsetX");
            offsetY = serializedObject.FindProperty("offsetY");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;

            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.Slider(scale, 1.0f, 100f);
            EditorGUILayout.IntSlider(octaves, 0, 8);
            EditorGUILayout.PropertyField(offsetX);
            EditorGUILayout.PropertyField(offsetY);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
