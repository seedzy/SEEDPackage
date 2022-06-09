using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(ChannelFactorPostprocessor))]
    public class ChannelFactorPostprocessorEditor : Editor
    {
        SerializedProperty redFactor;
        SerializedProperty greenFactor;
        SerializedProperty blueFactor;
        SerializedProperty alphaFactor;

        void OnEnable()
        {
            if (target == null)
                return;
            redFactor = serializedObject.FindProperty("redFactor");
            greenFactor = serializedObject.FindProperty("greenFactor");
            blueFactor = serializedObject.FindProperty("blueFactor");
            alphaFactor = serializedObject.FindProperty("alphaFactor");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.Slider(redFactor, 0f, 1f);
            EditorGUILayout.Slider(greenFactor, 0f, 1f);
            EditorGUILayout.Slider(blueFactor, 0f, 1f);
            EditorGUILayout.Slider(alphaFactor, 0f, 1f);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}
