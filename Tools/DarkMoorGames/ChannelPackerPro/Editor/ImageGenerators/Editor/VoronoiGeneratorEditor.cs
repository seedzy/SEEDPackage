using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(VoronoiGenerator))]
    public sealed class VoronoiGeneratorEditor : Editor
    {
        SerializedProperty method;
        SerializedProperty scale;
        SerializedProperty offsetX;
        SerializedProperty offsetY;

        private void OnEnable()
        {
            if (target == null)
                return;
            method = serializedObject.FindProperty("method");
            scale = serializedObject.FindProperty("scale");
            offsetX = serializedObject.FindProperty("offsetX");
            offsetY = serializedObject.FindProperty("offsetY");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;
            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.PropertyField(method);
            EditorGUILayout.Slider(scale, 1f, 100f);
            EditorGUILayout.PropertyField(offsetX);
            EditorGUILayout.PropertyField(offsetY);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
