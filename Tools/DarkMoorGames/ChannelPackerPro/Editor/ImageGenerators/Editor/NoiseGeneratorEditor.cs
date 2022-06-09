using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(NoiseGenerator))]
    public class NoiseGeneratorEditor : Editor
    {
        private void OnEnable()
        {
            if (target == null)
                return;
        }

        public override void OnInspectorGUI()
        {
            EditorGUIUtility.labelWidth = 90f;

            serializedObject.UpdateIfRequiredOrScript();

            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
