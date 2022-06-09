# Changelog
All notable changes to this project will be documented in this file.
##[1.4.2] - 28-11-2021
	Fixed - fixed errors when trying to load a texture if the target platform is not standalone.
##[1.4.1] - 13-11-2021
	Fixed - fixed an error with the reset button.
##[1.4.0] - 06-11-2021
	Added - added Templates to replace the Presets as they give more control.
	Added - added settings dropdown that shows settings, preferences and help popup windows.
	Added - added Prefix name setting that applies to all output names.
	Added - added auto update toggle for the output images. Update meaning packing and postprocessing the output image.
	Added - added jpg compression quality slider in preferences.
	Added - added Channel Factor Postprocessor.		
	Changed - slightly changed the output area gui.
	Changed - removed Presets. Replaced with Templates.
	Changed - minimum Unity version is now 2019.4.
	Changed - added attributes for image postprocessors like how image generators work.
	Changed - all textures that can be loaded must be in the unity project. Or a dialog will appear to ask if you want to import and load in channel packer pro.
	Changed - ChannelPackerPro window now shows its version number with the title name.
	Changed - postprocessor window now can add the same postprocessor multiple times.
	Fixed - fixed banding in previews.
	Fixed - fixed Graphics.CopyTexture warning showing if the user set texture quality in project settings lower than full res. This caused the image to not fit the expected size.
	Fixed - fixed normal map postprocessor bad results.
	Fixed - fixed removing a packing group that is not selected changes the selected packing group.

##[1.3.2] - 15-09-2021
	Fixed - fixed channel packing not working in linear color space.	
	Fixed - fixed previews showing different in linear color space.

##[1.3.1] - 29-06-2021
	Added - added HSV shift postprocessor.
			added Sepia postprocessor.
			added Colorize postprocessor.
			added Brightness and Contrast postprocessor.
			added NormalMap postprocessor.

	Added - can now load .tif and .psd files but only if they exist in the project folder with uncompresssed import settings.

	Changed - Color To Alpha now has smoothness factor.
	Changed - Color Replace now has smoothness factor.
	Fixed - fixed not being able to load png images that are not 32 bit.

##[1.3.0] - 12-04-2021
	Added - added image postprocessors.
			added Color to Alpha postprocessor.
			added Grey Scale postprocessor.
			added Color Replace postprocessor.

	Added - added input image generators.
			added Circle generator.
			added Linear Gradient generator.
			added Bi-Linear Gradient generator.
			added Checker Board generator.
			added Border Color generator.
			added Solid Color generator.
			added Generic Noise generator.
			added Cloud Noise generator.
			added Voronoi generator.

	Added - added tooltips for most of the editor.
	Added - added a window for users to get a link to the asset store page for rating or review.
	Added - added context right click menus when over input images for quick loading or editing.
	Added - added attributes for Image Generators that are used to hold meta data for custom created Image Generators.
	Added - added the load or generate image dropdown button to large view mode of input images.
	Added - added UtilityData class to store ChannelPackUtility class data.
	Added - added automatic finding of image postprocessors and input image generators. Useful for custom ones to be automatically found by channel packer pro.

	Changed - changed view mode from being disabled if no input image is created to being clickable. Just so a user can drag an image in while in big view or generate one.
	Changed - change to compute shader now seperated into 4 shaders, ImageGeneratorShader, ChannelPackShader, ChannelPreviewShader and ImagePostprocessorShader.
	Changed - loading images now have a max size of 8192.

	Fixed - fixed build errors that occured due to assembly definition file having platforms enabled, Set to just the editor.
##[1.2.4] - 14-02-2021
	Fixed error that sometimes happened loading the Compute Shader.
##[1.2.3] - 27-11-2020
	Changed - changed save dialog for single export back to old way.
	Fixed - fixed changing output name then clicking export not applying name change.
##[1.2.2] - 24-11-2020
	Added - added dialog for user ensuring if they want to delete a packing group.
	Changed - moved delete input image button to top right.
	Changed - made zoom modes disabled if there is no image.
	Fixed - fixed gui button filter mode size changing when toggled because of string lengths are different.
##[1.2.1] - 23-11-2020
	Fixed - fixed output name must have at least one character.
	Fixed - fixed output name now generates a unique name if the user types an existing one.
##[1.2.0] - 22-11-2020
	Added - added multi image editing and batching.
	Added - added output naming and extension selection for the output images.
	Changed - changed layout of options.
##[1.1.0] - 21-11-2020
	Added - added .tga file support but they can not be RLE compressed.
	Added - added Output option presets that can be saved in the unity project and loaded.
	Added - added large previews for the input images like the output image has.
	Changed - added save format filter checks by unity version.
	Changed - changed large output view mode style.
##[1.0.0] - 17-11-2020
	Changed - placed scripts into namespaces.
	Fixed - render textures not working in projects with linear color space.
	Fixed - Channel enums not displaying full names.
##[0.7.2] - 15-11-2020
	Added - added more warnings for saving and loading files that are not supported.
	Changed - changed Image classes InputImage and OutputImage. these just inherit from Image but OutputImage creates one more RenderTexture.
	Fixed - fixed a texture not being cleaned up after closing the window.
##[0.7.1] - 14-11-2020
	Fixed - fixed Source selection names not being displayed correctly.
	Fixed - fixed Compute shader not being cache referenced some times when unity loads.
##[0.7.0] - 14-11-2020
	Added - added to the Compute Shader to pack the Output Image. This help using the value sliders on high resolution textures.
	Changed - packing now happens on the GPU with the ChannelPack Compute Shader.
##[0.6.0] - 13-11-2020
	Added - added dialogs for warning invalid loading of images.
##[0.5.0] - 11-11-2020
	Added - added Compute Shader to incease the speed for previews.
	Fixed - fixed not being able to load jpg images that are extension named JPG or jpeg.
##[0.4.0]
	Added - added image filterMode previews, could be useful for pixel art or low res textures so they dont look blurry in the preview.
	Added - added drag and drop for quick image loading to each image slot.
##[0.3.0]
	Added - added sliders per channel if no source image is used or the user chooses.
	Added - added a view mode to preview the output image filling the whole window.
## [0.2.0] - 04-10-2020
	Added - added EditorPrefs to save previous save and load directory for images.
## [0.1.0] - 31-08-2020
	Initial.