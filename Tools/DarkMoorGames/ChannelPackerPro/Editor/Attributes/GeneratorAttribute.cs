using System;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [Serializable]
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = false)]
    public class GeneratorAttribute : Attribute
    {
        [SerializeField]
        Type type;
        [SerializeField]
        GUIContent menuContext;
        [SerializeField]
        string displayName;

        public Type Type
        {
            get
            {
                return type;
            }
        }
        public GUIContent MenuContext
        {
            get
            {
                return menuContext;
            }
        }
        public string DisplayName
        {
            get
            {
                return displayName;
            }
        }
        public GeneratorAttribute(Type type, string menuContext, string displayName)
        {
            this.type = type;
            this.menuContext = new GUIContent(menuContext);
            this.displayName = displayName;
        }
    }
}
