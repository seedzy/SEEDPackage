using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace SEED.Rendering
{
    #region ShaderPath
    internal struct ShaderPath
    {
        internal static string screenSpaceShadowPath = "Hidden/Universal Render Pipeline/ScreenSpaceShadows";
        internal static string GPUInstanceGrass = "SEEDzy/URP/GPUInstance/Grass";
        internal static string GenerateMipMaps = "SEEDzy/URP/GenerateMipMaps";
        internal static string GaussianBlur = "SEEDzy/URP/RenderFeature/Bloom";
        internal static string PostProcess = "SEEDzy/URP/PostProcess";
    }
    #endregion
    
    
    
    
    [Serializable]
    public class ScreenSpaceShadowSetting
    {
        public bool enable = false;
        [Range(1, 10)]
        public int downSample = 1;
        
        public bool GaussianSoftShadow = true;
    }

    [Serializable]
    public class ScreenSpaceFogSetting
    {
        public bool enable = false;
    }
    
    [Serializable]
    public class ToneMappingSetting
    {
        public enum ToneMappingType
        {
            YS,
            Film,
            ACES
        }
        public bool enable = false;
        [EnumPaging] 
        public ToneMappingType Type = ToneMappingType.YS;
        [Range(0,2)]
        public float Expossure = 1;
    }
    
    [Serializable]
    public class BloomSetting
    {
        public bool enable = false;
    }
    
    [Serializable]
    public class GaussianSetting
    {
        public bool enable = false;
    }
    
    [Serializable]
    public class DepthOfFieldSetting
    {
        public bool enable = false;
    }
    
    [Serializable]
    public class VolumeCloudSetting
    {
        public bool enable = false;
    }
    
    [Serializable]
    public class GPUInstanceSetting
    {
        [HideInInspector]
        public bool rebuildCBuffer = false;
        public bool enable = false;
        [Header("????????????????????????")]
        public Mesh instanceMesh = null;
        [Header("??????????????????????????????(????????????Instance??????)")] 
        public Material material;
        [Header("?????????????????????Mesh?????????")]
        public Transform groundTran = null;
        [Header("?????????????????????"),Range(1, 25600)]
        public int maxInstanceCount = 25600;
        [Header("???????????????"),Range(1, 100)] 
        public int instanceDensity = 8;
        [Header("HizCullingOn")] 
        public bool cullingOn = false;
        [Header("SceneCameraHizCullingOn")]
        public bool sceneCullingOn = false;
        [Header("HizCullingCS")] 
        public ComputeShader computeShader;
        [Header("GPUInstance???????????????(????????????????????????)")] 
        public RenderPassEvent renderPassEvent = RenderPassEvent.BeforeRenderingOpaques;
        [Button(ButtonSizes.Large),PropertySpace]
        private void RebuildCBuffer()
        {
            rebuildCBuffer = !rebuildCBuffer;
        }

    }
}
