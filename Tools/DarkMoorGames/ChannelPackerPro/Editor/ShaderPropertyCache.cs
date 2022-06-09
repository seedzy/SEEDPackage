using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public static class ShaderPropertyCache
    {
        public static readonly int InputID = Shader.PropertyToID("Input");
        public static readonly int OriginalID = Shader.PropertyToID("Original");
        public static readonly int OutputID = Shader.PropertyToID("Output");

        public static readonly int ImageWidthID = Shader.PropertyToID("ImageWidth");
        public static readonly int ImageHeightID = Shader.PropertyToID("ImageHeight");

        public static readonly int HueID = Shader.PropertyToID("Hue");
        public static readonly int SaturationID = Shader.PropertyToID("Saturation");
        public static readonly int ValueID = Shader.PropertyToID("Value");

        public static readonly int InvertID = Shader.PropertyToID("Invert");
        public static readonly int ThesholdID = Shader.PropertyToID("Threshold");
        public static readonly int IntValueID = Shader.PropertyToID("IntValue");
        public static readonly int SeedID = Shader.PropertyToID("Seed");

        public static readonly int Color1ID = Shader.PropertyToID("Color1");
        public static readonly int Color2ID = Shader.PropertyToID("Color2");

        public static readonly int HardnessID = Shader.PropertyToID("Hardness");
        public static readonly int OffsetXID = Shader.PropertyToID("OffsetX");
        public static readonly int OffsetYID = Shader.PropertyToID("OffsetY");
        public static readonly int ScaleID = Shader.PropertyToID("Scale");
        public static readonly int RotationID = Shader.PropertyToID("Rotation");

        public static readonly int ThicknessID = Shader.PropertyToID("Thickness");
        public static readonly int SizeID = Shader.PropertyToID("Size");

        public static readonly int BrightnessID = Shader.PropertyToID("Brightness");
        public static readonly int ContrastID = Shader.PropertyToID("Contrast");

        public static readonly int MinID = Shader.PropertyToID("Min");
        public static readonly int MaxID = Shader.PropertyToID("Max");

        public static readonly int StrengthID = Shader.PropertyToID("Strength");
        public static readonly int LinearSpaceID = Shader.PropertyToID("LinearSpace");

        public static readonly int RedFactorID = Shader.PropertyToID("RedFactor");
        public static readonly int GreenFactorID = Shader.PropertyToID("GreenFactor");
        public static readonly int BlueFactorID = Shader.PropertyToID("BlueFactor");
        public static readonly int AlphaFactorID = Shader.PropertyToID("AlphaFactor");
    }
}
