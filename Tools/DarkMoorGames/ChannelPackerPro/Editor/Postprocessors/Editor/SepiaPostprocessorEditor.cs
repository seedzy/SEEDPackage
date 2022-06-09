using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(SepiaPostprocessor))]
    public sealed class SepiaPostprocessorEditor : Editor
    {
        SerializedProperty amount;

        void OnEnable()
        {
            if (target == null)
                return;
            amount = serializedObject.FindProperty("amount");
        }
        public override void OnInspectorGUI()
        {
            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.Slider(amount, 0f, 1f);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
