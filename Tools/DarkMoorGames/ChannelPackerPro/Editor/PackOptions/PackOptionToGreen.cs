
namespace DarkMoorGames.ChannelPackerPro
{
    public class PackOptionToGreen : PackOption
    {
        public override Channel OutputChannel
        {
            get
            {
                return Channel.Green;
            }
        }

        public override string GetPackKernel(bool hasInputImage)
        {
            if (!hasInputImage)
            {
                return "PackValueToGreen";
            }

            switch (inputChannel)
            {
                case Channel.Red:
                    return "PackRedToGreen";
                case Channel.Green:
                    return "PackGreenToGreen";
                case Channel.Blue:
                    return "PackBlueToGreen";
                case Channel.Alpha:
                    return "PackAlphaToGreen";
                default:
                    break;
            }
            return null;
        }
    }
}
