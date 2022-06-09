using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(SolidColorGenerator))]
    public class SolidColorGeneratorEditor : Editor
    {
        SerializedProperty color;

        private void OnEnable()
        {
            if (target == null)
                return;
            color = serializedObject.FindProperty("color");
        }
        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;
            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.PropertyField(color);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
