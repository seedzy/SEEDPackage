
namespace DarkMoorGames.ChannelPackerPro
{
    public class PackOptionToAlpha : PackOption
    {
        public override Channel OutputChannel
        {
            get
            {
                return Channel.Alpha;
            }
        }

        public override string GetPackKernel(bool hasInputImage)
        {
            if (!hasInputImage)
            {
                return "PackValueToAlpha";
            }

            switch (inputChannel)
            {
                case Channel.Red:
                    return "PackRedToAlpha";
                case Channel.Green:
                    return "PackGreenToAlpha";
                case Channel.Blue:
                    return "PackBlueToAlpha";
                case Channel.Alpha:
                    return "PackAlphaToAlpha";
                default:
                    break;
            }
            return null;
        }
    }
}
