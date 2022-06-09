namespace DarkMoorGames.ChannelPackerPro
{
    public class PackOptionToBlue : PackOption
    {
        public override Channel OutputChannel
        {
            get
            {
                return Channel.Blue;
            }
        }

        public override string GetPackKernel(bool hasInputImage)
        {
            if (!hasInputImage)
            {
                return "PackValueToBlue";
            }

            switch (inputChannel)
            {
                case Channel.Red:
                    return "PackRedToBlue";
                case Channel.Green:
                    return "PackGreenToBlue";
                case Channel.Blue:
                    return "PackBlueToBlue";
                case Channel.Alpha:
                    return "PackAlphaToBlue";
                default:
                    break;
            }
            return null;
        }
    }
}

