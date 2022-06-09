using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class StoreRatingWindow : EditorWindow
    {
        bool dontShowAgain;

        public static void TryShow(EditorWindow parent)
        {
            if (!EditorPrefs.HasKey("ChannelPackerProDontShowRateUs"))
                EditorPrefs.SetBool("ChannelPackerProDontShowRateUs", false);

            if (!EditorPrefs.GetBool("ChannelPackerProDontShowRateUs"))
            {
                StoreRatingWindow storeWindow = CreateInstance<StoreRatingWindow>();
                storeWindow.hideFlags = HideFlags.DontSave;

                storeWindow.titleContent = new GUIContent("Rate Channel Packer Pro");
                storeWindow.maxSize = new Vector2(300f, 110f);
                storeWindow.minSize = storeWindow.maxSize;

                storeWindow.position = new Rect(parent.position.x + (parent.position.size.x / 2f) - 150f, parent.position.y + (parent.position.size.y / 2f) - 55f, 0f, 0f);
                storeWindow.ShowModalUtility();
            }
        }

        void Awake()
        {
            dontShowAgain = EditorPrefs.GetBool("ChannelPackerProDontShowRateUs");
        }
        void OnDestroy()
        {
            EditorPrefs.SetBool("ChannelPackerProDontShowRateUs", dontShowAgain);
        }
        void OnLostFocus()
        {
            Close();
        }
        void OnGUI()
        {
            EditorGUILayout.LabelField("Thank you for purchasing Channel Packer Pro.\n\nIf you like this tool we would really appreciate\nan honest rating or review, Thank you.", GUILayout.MinHeight(60f));
            GUILayout.FlexibleSpace();
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("Asset Store Link", GUILayout.MinWidth(150f)))
            {
                Application.OpenURL("https://assetstore.unity.com/packages/slug/182987");
            }

            EditorGUIUtility.labelWidth = 105f;
            GUILayout.FlexibleSpace();
            dontShowAgain = EditorGUILayout.Toggle("Don't Show Again", dontShowAgain);
            EditorGUILayout.EndHorizontal();
        }
    }
}
