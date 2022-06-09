using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [CustomEditor(typeof(Template))]
    public class TemplateEditor : Editor
    {
        protected override void OnHeaderGUI()
        {

        }
        public override void OnInspectorGUI()
        {
            if (GUILayout.Button("Open With Channel Packer Pro"))
            {
                ChannelPackEditor.Open(false, (Template)target);
            }
        }
    }
}
