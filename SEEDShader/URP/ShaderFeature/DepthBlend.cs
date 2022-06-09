using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class DepthBlend : ScriptableRendererFeature
{
    public enum RenderQueueType
    {
        Opaque,
        Transparent,
    }
    
    [System.Serializable]
    public class FilterSettings
    {
        // TODO: expose opaque, transparent, all ranges as drop down
        public RenderQueueType RenderQueueType;
        public LayerMask LayerMask;
        public string[] PassNames;

        public FilterSettings()
        {
            RenderQueueType = RenderQueueType.Opaque;
            LayerMask = 0;
        }
    }
    
    [System.Serializable]
    public class DepthBlendSettings
    {
        public string passTag = "DepthBlendFeature";
        public RenderPassEvent Event = RenderPassEvent.BeforeRenderingOpaques;

        public FilterSettings filterSettings = new FilterSettings();
    }

    
    
    class DepthBlendPass : ScriptableRenderPass
    {
        private string _passTag;
        private FilterSettings _filterSettings;
        private RenderTargetHandle terrainDepthHandle;
        private RenderTargetHandle terrainColorHandle;
        //记录需要渲染目标shader pass lightmode
        List<ShaderTagId> _ShaderTagIdList = new List<ShaderTagId>();

        private FilteringSettings filteringSettings;
        public DepthBlendPass(string passTag, FilterSettings filterSettings)
        {
            _passTag = passTag;
            _filterSettings = filterSettings;
            terrainDepthHandle.Init("_TerrainDepthBuffer");
            terrainColorHandle.Init("_TerrainColorBuffer");
            
            _ShaderTagIdList.Add(new ShaderTagId("UniversalForward"));
            //_ShaderTagIdList.Add(new ShaderTagId("DepthOnly"));
            
            RenderQueueRange renderQueueRange = (_filterSettings.RenderQueueType == RenderQueueType.Transparent)
                ? RenderQueueRange.transparent
                : RenderQueueRange.opaque;

            filteringSettings = new FilteringSettings(renderQueueRange, filterSettings.LayerMask);
        }

        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            base.Configure(cmd, cameraTextureDescriptor);
        }

        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in a performant manner.
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            
            // RenderTextureDescriptor depthDescriptor = renderingData.cameraData.cameraTargetDescriptor;
            // depthDescriptor.colorFormat = RenderTextureFormat.Depth;
            // depthDescriptor.depthBufferBits = 32; //TODO: do we really need this. double check;
            // depthDescriptor.msaaSamples = 1;
            // cmd.GetTemporaryRT(terrainDepthHandle.id, renderingData.cameraData.cameraTargetDescriptor);
            
            RenderTextureDescriptor colorDepthDescriptor = renderingData.cameraData.cameraTargetDescriptor;
            //colorDepthDescriptor.colorFormat = RenderTextureFormat.ARGB32;
            cmd.GetTemporaryRT(terrainColorHandle.id, colorDepthDescriptor);
            
            ConfigureTarget(terrainColorHandle.Identifier());
            
            ConfigureClear(ClearFlag.All, new Color(0,0,0,1));
        }

        // Here you can implement the rendering logic.
        // Use <c>ScriptableRenderContext</c> to issue drawing commands or execute command buffers
        // https://docs.unity3d.com/ScriptReference/Rendering.ScriptableRenderContext.html
        // You don't have to call ScriptableRenderContext.submit, the render pipeline will call it at specific points in the pipeline.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            //决定是从前往后还是从后往前排序渲染
            SortingCriteria sortingCriteria = (_filterSettings.RenderQueueType == RenderQueueType.Transparent)
                ? SortingCriteria.CommonTransparent
                : renderingData.cameraData.defaultOpaqueSortFlags;
            
            DrawingSettings drawingSettings =
                CreateDrawingSettings(_ShaderTagIdList, ref renderingData, sortingCriteria);
            
            context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref filteringSettings);
        }

        // Cleanup any allocated resources that were created during the execution of this render pass.
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
        }
    }

    public DepthBlendSettings depthBlendSettings = new DepthBlendSettings();
    DepthBlendPass m_ScriptablePass;

    /// <inheritdoc/>
    public override void Create()
    {
        m_ScriptablePass = new DepthBlendPass(depthBlendSettings.passTag, depthBlendSettings.filterSettings);

        // Configures where the render pass should be injected.
        m_ScriptablePass.renderPassEvent = depthBlendSettings.Event;
        m_ScriptablePass.ConfigureColorStoreAction(RenderBufferStoreAction.Store);
        m_ScriptablePass.ConfigureDepthStoreAction(RenderBufferStoreAction.Store);
    }

    // Here you can inject one or multiple render passes in the renderer.
    // This method is called when setting up the renderer once per-camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(m_ScriptablePass);
    }
}


