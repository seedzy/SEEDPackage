using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(LinearGradientGenerator))]
    public class LinearGradientGeneratorEditor : Editor
    {
        SerializedProperty rotation;
        SerializedProperty hardness;
        SerializedProperty start;
        SerializedProperty end;

        private void OnEnable()
        {
            if (target == null)
                return;
            rotation = serializedObject.FindProperty("rotation");
            hardness = serializedObject.FindProperty("hardness");
            start = serializedObject.FindProperty("start");
            end = serializedObject.FindProperty("end");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;

            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.Slider(rotation, -180f, 180f);
            EditorGUILayout.Slider(hardness, 0f, 1f);
            EditorGUILayout.PropertyField(start);
            EditorGUILayout.PropertyField(end);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
