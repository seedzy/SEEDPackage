using UnityEditor;
using UnityEngine;

namespace DarkMoorGames.ChannelPackerPro
{
    public sealed class GUICache : ScriptableObject
    {
        GUIStyle boldCenteredLabel;
        GUIStyle boldRightLabel;
        GUIStyle boxCenteredLabel;

        GUIStyle richBoldCenteredLabel;
        GUIStyle richTextField;
        GUIStyle toolbarButtonRichText;

        GUIContent exportButtonContent;

        GUIContent postprocessButtonContent;

        GUIContent removeInputImageContent;
        GUIContent removePackingGroupContent;

        GUIContent addNewPackingGroupContent;

        GUIContent zoomInToLargeViewContent;
        GUIContent zoomOutOfLargeViewContent;
        GUIContent loadImageButtonContent;

        GUIContent settingsDropdownContent;

        GUIContent[] previewChannelOptions;

        public GUIContent ExportButtonContent
        {
            get
            {
                return exportButtonContent;
            }
        }
        public GUIContent PostprocessButtonContent
        {
            get
            {
                return postprocessButtonContent;
            }
        }
        public GUIContent RemoveInputImageContent
        {
            get
            {
                return removeInputImageContent;
            }
        }
        public GUIContent ZoomInToLargeViewContent
        {
            get
            {
                return zoomInToLargeViewContent;
            }
        }
        public GUIContent ZoomOutOfLargeViewContent
        {
            get
            {
                return zoomOutOfLargeViewContent;
            }
        }
        public GUIContent LoadImageContent
        {
            get
            {
                return loadImageButtonContent;
            }
        }
        public GUIContent AddNewPackingGroupContent
        {
            get
            {
                return addNewPackingGroupContent;
            }
        }
        public GUIContent RemovePackingGroupContent
        {
            get
            {
                return removePackingGroupContent;
            }
        }
        public GUIContent SettingsDropdownContent
        {
            get
            {
                return settingsDropdownContent;
            }
        }
        public GUIContent[] PreviewChannelOptions
        {
            get
            {
                return previewChannelOptions;
            }
        }

        public GUIStyle BoldRightLabel
        {
            get
            {
                if (boldRightLabel == null)
                {
                    boldRightLabel = new GUIStyle(EditorStyles.label)
                    {
                        fontSize = 11,
                        fontStyle = FontStyle.Bold,
                        alignment = TextAnchor.MiddleRight,
                        imagePosition = ImagePosition.TextOnly,
                        stretchWidth = true
                    };
                }
                return boldRightLabel;
            }
        }
        public GUIStyle BoldCenteredLabel
        {
            get
            {
                if (boldCenteredLabel == null)
                {
                    boldCenteredLabel = new GUIStyle(EditorStyles.label)
                    {
                        fontSize = 11,
                        fontStyle = FontStyle.Bold,
                        alignment = TextAnchor.MiddleCenter,
                        imagePosition = ImagePosition.TextOnly,
                        stretchWidth = true,
                    };
                }
                return boldCenteredLabel;
            }
        }
        public GUIStyle BoxCenteredLabel
        {
            get
            {
                if (boxCenteredLabel == null)
                {
                    boxCenteredLabel = new GUIStyle(EditorStyles.helpBox)
                    {
                        fontSize = 11,
                        fontStyle = FontStyle.Bold,
                        alignment = TextAnchor.MiddleCenter,
                        imagePosition = ImagePosition.ImageAbove,
                        stretchWidth = true,
                    };
                }
                return boxCenteredLabel;
            }
        }
        public GUIStyle RichTextField
        {
            get
            {
                if (richTextField == null)
                {
                    richTextField = new GUIStyle(EditorStyles.textField)
                    {
                        richText = true
                    };
                }
                return richTextField;
            }
        }
        public GUIStyle RichBoldCenteredLabel
        {
            get
            {
                if (richBoldCenteredLabel == null)
                {
                    richBoldCenteredLabel = new GUIStyle(EditorStyles.label)
                    {
                        fontSize = 11,
                        fontStyle = FontStyle.Bold,
                        alignment = TextAnchor.MiddleCenter,
                        imagePosition = ImagePosition.TextOnly,
                        richText = true,
                        stretchWidth = true,
                    };
                }
                return richBoldCenteredLabel;
            }
        }
        public GUIStyle ToolbarButtonRichText
        {
            get
            {
                if (toolbarButtonRichText == null)
                {
                    toolbarButtonRichText = new GUIStyle(EditorStyles.toolbarButton)
                    {
                        fontSize = 11,
                        fontStyle = FontStyle.Bold,
                        alignment = TextAnchor.MiddleCenter,
                        imagePosition = ImagePosition.TextOnly,
                        richText = true,
                        stretchWidth = true,
                    };
                }
                return toolbarButtonRichText;
            }
        }

        public static GUICache Create()
        {
            GUICache cache = CreateInstance<GUICache>();
            cache.hideFlags = HideFlags.HideAndDontSave;

            cache.previewChannelOptions = new GUIContent[6]
            {
                new GUIContent("RGBA", "Preview all channels of the image."),
                new GUIContent ("RGB", "Preview the Red, Green and Blue channels of the image."),
                new GUIContent("R", "Preview the Red channel of the image."),
                new GUIContent("G", "Preview the Green channel of the image."),
                new GUIContent("B", "Preview the Blue channel of the image."),
                new GUIContent("A", "Preview the Alpha channel of the image.")
            };
            cache.postprocessButtonContent = new GUIContent("Postprocess", "Add postprocess effects for the output image.\n\nEffects work from top to bottom of the stack and take effect after input image packing.");
            cache.exportButtonContent = new GUIContent("Export", "Export - Export the selected packing group output image only.\n\nExport Batch - Export all packing group output images to a chosen folder.");
            cache.removeInputImageContent = new GUIContent("x", "Remove the input image.");
            cache.zoomInToLargeViewContent = new GUIContent("+", "Zoom in to large view.");
            cache.zoomOutOfLargeViewContent = new GUIContent("-", "Zoom out of large view.");
            cache.loadImageButtonContent = new GUIContent("Image", "Load, generate or postprocess an input image.");
            cache.removePackingGroupContent = new GUIContent("x", "Remove the packing group with all its input images.");

            cache.addNewPackingGroupContent = EditorGUIUtility.IconContent("Toolbar Plus");
            cache.addNewPackingGroupContent.tooltip = "Add a new packing group.";

            cache.settingsDropdownContent = EditorGUIUtility.IconContent("_Popup");
            cache.settingsDropdownContent.tooltip = "Channel Packer Pro settings.";
            return cache;
        }
    }
}
