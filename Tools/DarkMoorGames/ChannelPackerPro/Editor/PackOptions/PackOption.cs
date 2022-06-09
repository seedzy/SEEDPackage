using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public abstract class PackOption : ScriptableObject
    {
        public Channel inputChannel;
        public bool invertChannel;

        public int inputImageIndex;
        public float value = 1f;

        public abstract Channel OutputChannel { get; }

        public static T CreateOption<T>(Channel inputChannel, int imageIndex) where T : PackOption
        {
            T input = CreateInstance<T>();
            input.hideFlags = HideFlags.HideAndDontSave;
            input.inputChannel = inputChannel;
            input.inputImageIndex = imageIndex;
            return input;
        }
        public static T CreateOption<T>(PackOptionData data) where T : PackOption
        {
            T input = CreateInstance<T>();
            input.hideFlags = HideFlags.HideAndDontSave;
            input.inputChannel = data.InputChannel;
            input.invertChannel = data.InvertChannel;
            input.inputImageIndex = data.InputImageIndex;
            input.value = data.Value;
            return input;
        }
        public abstract string GetPackKernel(bool hasInputImage);
        public void SetPackOptionData(PackOptionData data)
        {
            inputChannel = data.InputChannel;
            invertChannel = data.InvertChannel;
            inputImageIndex = data.InputImageIndex;
            value = data.Value;
        }
    }
}

