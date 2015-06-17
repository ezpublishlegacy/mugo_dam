{ezcss_require( 'dam_image.css' )}

{* --- ezscript_require( array( 'jquery.tocanvas.js', 'jquery.damimages.js' ) ) --- *}
{* 
Be sure these files are listed under 
[JavaScriptSettings]
...
JavaScriptList[]=jquery.tocanvas.js
JavaScriptList[]=jquery.damimages.js

In all siteaccesses where this template may be used

The supporting JavaScript files must be loaded AFTER jQuery
*}

{if is_unset( $attribute_base )}
	{def $attribute_base='ContentObjectAttribute'}
{/if}

{* options are
    0 : max file size in MB
    1 : allow multiple files
    2 : auto upload
*}
{def $options        = $attribute.contentclass_attribute.data_text4|explode('-')
     $max_size       = $options.0
     $allow_multiple = $options.1
     $auto_upload    = $options.2
}

{def $image_url    = false()
     $base_url     = ezini( 'Base', 'DamBaseUrl', 'mugo_dam.ini' )
     $ratios       = ezini( 'ImageRatios', 'List', 'mugo_dam.ini' )
     $i_alias      = false()}


<div class="dam-images" id="ezp-attribute-id-{$attribute.id}">

	<fieldset class="preview">
		<legend>Preview</legend>
		<ul>
			<li data-alias="standard_218x145" style="width: 260px">
				Standard
				<img src="" class="thumbnail" />
			</li>
			<li data-alias="cinema_288x154" style="width: 260px">
				Wide <span></span>
				<img src="" class="thumbnail" width="218" />
			</li>
			<li data-alias="square_50x50" style="width: 140px">
				Square <span></span>
				<img src="" class="thumbnail" />
			</li>
		</ul>
	</fieldset>
	
	{foreach $ratios as $id}
		{set $image_url = first_set( $attribute.content[ $id ], false() )
		     $i_alias   = first_set( ezini( $id, 'Alias', 'mugo_dam.ini' ), '' )}

		<div class="tocanvas" data-ratio="{$id|wash()}">

			<input 
				class="storage"
				type="hidden"
				name="{$attribute_base}_dam_images_{$attribute.id}[{$id}]"
				value="{$image_url}" />

			<h2>{first_set( ezini( $id, 'Label', 'mugo_dam.ini' ), 'Image' )|wash()}</h2>
			<p>{first_set( ezini( $id, 'Description', 'mugo_dam.ini' ), '' )|wash()}</p>

			<div>
				<div class="current-image preview-size">
					{if $image_url}
						<img class="thumbnail"
							 data-base="{$base_url}{$image_url}"
							 src="{$base_url}{$image_url}?alias={$i_alias}"
							 alt=""
							 data-alias="{$i_alias}" />
					{else}
						<img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D" 
							 alt=""
							 data-alias="{$i_alias}" />
					{/if}
				</div>

				<div class="preview-size dropbox">
					<canvas width="300" height="200"></canvas>
				</div>
				
				<div style="clear: both"></div>
			</div>
			
			<div class="select-image">				
				<button class="remove-image-trigger ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					<span class="ui-button-text">Remove current image</span>
				</button>
				<button class="select-image-trigger ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					<span class="ui-button-text">Select new image</span>
				</button>

				<div class="fromurl">
					<input type="hidden" value="" />
				</div>

				<div class="fromdisk">
					<input type="file" name="files[]" />
				</div>
			</div>

			<div class="upload-image">
				<button class="upload ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					<span class="ui-button-text">Upload</span>
				</button>
				<button class="cancel-upload ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					<span class="ui-button-text">Cancel</span>
				</button>
			</div>

			<div class="uploading">
				Uploading...
			</div>

			<div style="clear: both"></div>
		</div>
	{/foreach}
</div>

<script>
	$(function()
	{ldelim}
		var damimages = $( '#ezp-attribute-id-{$attribute.id}' ).damimages();
		
		$( '#ezp-attribute-id-{$attribute.id} .tocanvas' ).toCanvas(
		{ldelim}
			object_id           : '{$attribute.contentobject_id}',
			version             : '{$attribute.version}',
			upload_service      : '{ezini( 'Base', 'UploadServiceUrl', 'mugo_dam.ini' )}',
			from_remote_service : '{ezini( 'Base', 'FromRemoteServiceUrl', 'mugo_dam.ini' )}',
			base_url            : '{$base_url}',
			repository          : '{ezini( 'Base', 'Repository', 'mugo_dam.ini' )}',
			api_key             : '{ezini( 'Base', 'ApiKey', 'mugo_dam.ini' )}',
			afterUpdate         : function()
				{ldelim}
					damimages.damimages( 'updatePreview' );
				{rdelim},
		{rdelim});
	{rdelim});
</script>