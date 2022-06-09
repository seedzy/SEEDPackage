using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(GreyScalePostprocessor))]
    public class GreyScalePostprocessorEditor : Editor
    {
        SerializedProperty amount;

        private void OnEnable()
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
