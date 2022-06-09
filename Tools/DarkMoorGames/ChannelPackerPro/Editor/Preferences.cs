using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class Preferences : ScriptableObject
    {
        public bool autoUpdate = true;
        public int jpgQuality = 100;
        public string prefixTextColorHtml = "#00BFFF";
        public string lastLoadSaveDirectory;

        public static Preferences Create()
        {
            Preferences preferences = CreateInstance<Preferences>();
            preferences.hideFlags = HideFlags.HideAndDontSave;
            return preferences;
        }
        void Awake()
        {
            autoUpdate = EditorPrefs.GetBool("ChannelPackerProAutoUpdate", true);
            jpgQuality = EditorPrefs.GetInt("ChannelPackerProJpgQuality", 100);
            prefixTextColorHtml = EditorPrefs.GetString("ChannelPackerProPrefixTextColor", "#00BFFF");
            lastLoadSaveDirectory = EditorPrefs.GetString("ChannelPackerPreviousDirectory", "Assets");
        }
        void OnDestroy()
        {
            EditorPrefs.SetBool("ChannelPackerProAutoUpdate", autoUpdate);
            EditorPrefs.SetInt("ChannelPackerProJpgQuality", jpgQuality);
            EditorPrefs.SetString("ChannelPackerProPrefixTextColor", prefixTextColorHtml);
            EditorPrefs.SetString("ChannelPackerPreviousDirectory", lastLoadSaveDirectory);
        }
    }
}
