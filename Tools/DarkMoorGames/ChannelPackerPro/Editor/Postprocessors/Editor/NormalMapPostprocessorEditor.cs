using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(NormalMapPostprocessor))]
    public sealed class NormalMapPostprocessorEditor : Editor
    {
        SerializedProperty strength;

        void OnEnable()
        {
            if (target == null)
                return;
            strength = serializedObject.FindProperty("strength");
        }
        public override void OnInspectorGUI()
        {
            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.Slider(strength, -100f, 100f);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
