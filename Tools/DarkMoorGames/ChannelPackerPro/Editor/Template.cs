using System.Collections.Generic;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    [System.Serializable]
    public class PackingGroupData
    {
        [SerializeField]
        string name;
        [SerializeField]
        PackOptionData packOption1;
        [SerializeField]
        PackOptionData packOption2;
        [SerializeField]
        PackOptionData packOption3;
        [SerializeField]
        PackOptionData packOption4;

        public string Name
        {
            get
            {
                return name;
            }
        }
        public PackOptionData PackOption1
        {
            get
            {
                return packOption1;
            }
        }
        public PackOptionData PackOption2
        {
            get
            {
                return packOption2;
            }
        }
        public PackOptionData PackOption3
        {
            get
            {
                return packOption3;
            }
        }
        public PackOptionData PackOption4
        {
            get
            {
                return packOption4;
            }
        }

        public PackingGroupData(PackingGroup group)
        {
            name = group.name;
            packOption1 = new PackOptionData(group.PackOption1);
            packOption2 = new PackOptionData(group.PackOption2);
            packOption3 = new PackOptionData(group.PackOption3);
            packOption4 = new PackOptionData(group.PackOption4);
        }
    }

    [System.Serializable]
    public class PackOptionData
    {
        [SerializeField]
        Channel inputChannel;
        [SerializeField]
        bool invertChannel;
        [SerializeField]
        int inputImageIndex;
        [SerializeField]
        float value = 1f;

        public Channel InputChannel
        {
            get
            {
                return inputChannel;
            }
        }
        public bool InvertChannel
        {
            get
            {
                return invertChannel;
            }
        }
        public int InputImageIndex
        {
            get
            {
                return inputImageIndex;
            }
        }
        public float Value
        {
            get
            {
                return value;
            }
        }

        public PackOptionData(PackOption option)
        {
            inputChannel = option.inputChannel;
            invertChannel = option.invertChannel;
            inputImageIndex = option.inputImageIndex;
            value = option.value;
        }
    }

    public sealed class Template : ScriptableObject
    {
        [SerializeField]
        List<PackingGroupData> data = new List<PackingGroupData>();

        public List<PackingGroupData> Data
        {
            get
            {
                return data;
            }
        }

        public void SetTemplateData(List<PackingGroup> groups)
        {
            data = new List<PackingGroupData>();
            for (int i = 0; i < groups.Count; i++)
            {
                data.Add(new PackingGroupData(groups[i]));
            }
        }
    }
}
