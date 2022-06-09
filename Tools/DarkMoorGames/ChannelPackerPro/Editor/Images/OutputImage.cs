using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class OutputImage : Image
    {
        protected override void OnCreate(Texture2D sourceTexture)
        {
            base.OnCreate(sourceTexture);
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
        }
    }
}
