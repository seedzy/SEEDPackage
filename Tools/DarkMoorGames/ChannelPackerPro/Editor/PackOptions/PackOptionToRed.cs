
namespace DarkMoorGames.ChannelPackerPro
{
    public class PackOptionToRed : PackOption
    {
        public override Channel OutputChannel
        {
            get
            {
                return Channel.Red;
            }
        }

        public override string GetPackKernel(bool hasInputImage)
        {
            if (!hasInputImage)
            {
                return "PackValueToRed";
            }
            switch (inputChannel)
            {
                case Channel.Red:
                    return "PackRedToRed";
                case Channel.Green:
                    return "PackGreenToRed";
                case Channel.Blue:
                    return "PackBlueToRed";
                case Channel.Alpha:
                    return "PackAlphaToRed";
                default:
                    break;
            }
            return null;
        }
    }
}
