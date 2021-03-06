using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using System;
using UnityEditor;
using SEED.Rendering;
using Sirenix.OdinInspector;
using UnityEngine.Experimental.Rendering;
using DepthOfFieldSetting = SEED.Rendering.DepthOfFieldSetting;



public class SEEDPostProcess : ScriptableRendererFeature
{ 
    
   //  [Toggle("enable"),              GUIColor(0.8f,0.85f,1)]
   // public ScreenSpaceShadowSetting screenSpaceShadowSetting = new ScreenSpaceShadowSetting();

   //[Toggle("enable"), GUIColor(0.8f, 0.85f, 1)]
   public ToneMappingSetting toneMappingSetting     = new ToneMappingSetting();
   // [Toggle("enable"),               GUIColor(0.8f,0.85f,1)]
   // public SEED.Rendering.BloomSetting bloom          = new SEED.Rendering.BloomSetting();
   // [Toggle("enable"),               GUIColor(0.8f,0.85f,1)]
   // public SEED.Rendering.GaussianSetting gaussian    = new SEED.Rendering.GaussianSetting();
   // [Toggle("enable"),               GUIColor(0.8f,0.85f,1)]
   // public DepthOfFieldSetting depthOfField           = new DepthOfFieldSetting();
   // [Toggle("enable"),               GUIColor(0.8f,0.85f,1)]
   // public GPUInstanceSetting gpuInstanceSetting      = new GPUInstanceSetting();
   
   class SEEDPostProcessPass : ScriptableRenderPass
    {
        private RenderTargetIdentifier _src;
        private RenderTargetIdentifier _dis;
        private RenderTargetHandle _TempRT;
        private Material _material;
        private ToneMappingSetting _toneMappingSetting;

        public SEEDPostProcessPass()
        {
            _TempRT.Init("TempRT");
            _material = CoreUtils.CreateEngineMaterial(ShaderPath.PostProcess);
        }
        
        public void SetUp(RenderTargetIdentifier src, RenderTargetIdentifier dis, ToneMappingSetting toneMappingSetting)
        {
            _src = src;
            _dis = dis;
            _toneMappingSetting = toneMappingSetting;
        }
        //SEEDPostProcessPass
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            RenderTextureDescriptor camRTDescriptor = renderingData.cameraData.cameraTargetDescriptor;
            cmd.GetTemporaryRT(_TempRT.id, camRTDescriptor);
        }
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get("SEEDPostProcess");
            _material.SetFloat("_Expossure", _toneMappingSetting.Expossure);
            cmd.Blit(_src, _TempRT.Identifier(), _material);
            cmd.Blit(_TempRT.Identifier(), _src);
            
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
        
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            
        }
    }
    
   private SEEDPostProcessPass       PPPass                 = null;
   private ScreenSpaceShadowTexPass  SSShadow               = null;
   private ScreenSpaceShadowBlur     SSBlur                 = null;
   private ScreenSpaceShadowPostPass SSShadowPost           = null;
   private GPUInstancePass           GPUInstancePass        = null;
   private GenerateHiZBufferPass     GenerateHiZBufferPass  = null;


   /// <summary>
   /// ??????ShaderFeature????????????????????????????????????AddRenderPass
   /// </summary>
   public override void Create()
   {
       // if (screenSpaceShadowSetting.enable)
       // {
       //     //ScreenSpaceShadowTexPass
       //     SSShadow = new ScreenSpaceShadowTexPass(screenSpaceShadowSetting);
       //     SSShadow.renderPassEvent = RenderPassEvent.AfterRenderingPrePasses;
       //     if(screenSpaceShadowSetting.GaussianSoftShadow) 
       //         SSBlur = new ScreenSpaceShadowBlur(SSShadow.GetShadowRenderTextureHandle());
       //     SSBlur.renderPassEvent = RenderPassEvent.AfterRenderingPrePasses;
       //     SSShadowPost = new ScreenSpaceShadowPostPass();
       //     SSShadowPost.renderPassEvent = RenderPassEvent.BeforeRenderingTransparents;
       // }
       //
       // if (gpuInstanceSetting.enable)
       // {
       //     GPUInstancePass = new GPUInstancePass(gpuInstanceSetting);
       //     //????????????????????????GPUInstance????????????????????????????????????Early-Z????????????Instance???????????????????????????????????????
       //     //?????????instance?????????opaque?????????????????????
       //     //TODO:????????????????????????????????????????????????????????????????????????
       //     GPUInstancePass.renderPassEvent = gpuInstanceSetting.renderPassEvent;
       // }

       GenerateHiZBufferPass = new GenerateHiZBufferPass();
       GenerateHiZBufferPass.renderPassEvent = RenderPassEvent.AfterRenderingPrePasses;
       //PostProcessMainPass
       PPPass = new SEEDPostProcessPass();
       PPPass.renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
   }

   /// <summary>
   /// ?????????????????????SetUp??????????????????Create
   /// ToDo????????????????????????SetUp?????????(??????)
   /// </summary>
   /// <param name="renderer"></param>
   /// <param name="renderingData"></param>
   public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
   {
       
       
       //
       // if (screenSpaceShadowSetting.enable)
       // {
       //     bool allowMainLightShadows = renderingData.shadowData.supportsMainLightShadows && renderingData.lightData.mainLightIndex != -1;
       //     if (allowMainLightShadows)
       //     {
       //         SSShadow.SetUp();
       //         renderer.EnqueuePass(SSShadow);
       //         if(screenSpaceShadowSetting.GaussianSoftShadow) 
       //             renderer.EnqueuePass(SSBlur);
       //         renderer.EnqueuePass(SSShadowPost);
       //     }
       // }
       //
       // renderer.EnqueuePass(GenerateHiZBufferPass);
       //
       // if (gpuInstanceSetting.enable)
       // {
       //     renderer.EnqueuePass(GPUInstancePass);
       // }
       // else
       // {
       //     //ToDo????????????????????????renderFeature?????????????????????????????????cbuffer
       //     //InstanceBuffer.Release();
       //     GPUInstancePass?.ReleaseCullingBuffer();
       // }

       if (toneMappingSetting.enable)
       {
           //m_AfterPostProcessColor.Init("_AfterPostProcessTexture");
           //var sourceForFinalPass = (renderingData.cameraData.postProcessEnabled) ? m_AfterPostProcessColor : RenderTargetHandle.CameraTarget;
           PPPass.SetUp(renderer.cameraColorTarget, BuiltinRenderTextureType.CameraTarget, toneMappingSetting);
           renderer.EnqueuePass(PPPass);
       }
   }

   protected override void Dispose(bool disposing)
   {
       base.Dispose(disposing);
       GPUInstancePass?.ReleaseCullingBuffer();
   }

   private void OnDestroy()
   {
       GPUInstancePass?.ReleaseCullingBuffer();
   }

   private void OnDisable()
   {
       GPUInstancePass?.ReleaseCullingBuffer();
   }
}


