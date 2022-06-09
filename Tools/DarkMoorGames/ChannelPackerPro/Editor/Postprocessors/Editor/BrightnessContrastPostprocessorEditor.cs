using UnityEditor;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(BrightnessContrastPostprocessor))]
    public class BrightnessContrastPostprocessorEditor : Editor
    {
        SerializedProperty brightness;
        SerializedProperty contrast;

        void OnEnable()
        {
            if (target == null)
                return;
            brightness = serializedObject.FindProperty("brightness");
            contrast = serializedObject.FindProperty("contrast");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.UpdateIfRequiredOrScript();
            EditorGUILayout.Slider(brightness, -1f, 1f);
            EditorGUILayout.Slider(contrast, -1f, 1f);
            serializedObject.ApplyModifiedPropertiesWithoutUndo();
        }
    }
}

