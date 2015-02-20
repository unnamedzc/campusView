package com.jeff.views.level
{
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.SkyBox;

	public class Sky
	{
		[Embed(source="/assets/sky/sky_negX.jpg")] static private const EmbedTexture1:Class;
		[Embed(source="/assets/sky/sky_negY.jpg")] static private const EmbedTexture2:Class;
		[Embed(source="/assets/sky/sky_negZ.jpg")] static private const EmbedTexture3:Class;
		[Embed(source="/assets/sky/sky_posX.jpg")] static private const EmbedTexture4:Class;
		[Embed(source="/assets/sky/sky_posY.jpg")] static private const EmbedTexture5:Class;
		[Embed(source="/assets/sky/sky_posZ.jpg")] static private const EmbedTexture6:Class;
		
		private var _sky:SkyBox;
		
		public function Sky()
		{
			init();
		}
		private function init():void
		{
			var texture1:BitmapTextureResource=new BitmapTextureResource(new EmbedTexture1().bitmapData);
			var texture2:BitmapTextureResource=new BitmapTextureResource(new EmbedTexture2().bitmapData);
			var texture3:BitmapTextureResource=new BitmapTextureResource(new EmbedTexture3().bitmapData);
			var texture4:BitmapTextureResource=new BitmapTextureResource(new EmbedTexture4().bitmapData);
			var texture5:BitmapTextureResource=new BitmapTextureResource(new EmbedTexture5().bitmapData);
			var texture6:BitmapTextureResource=new BitmapTextureResource(new EmbedTexture6().bitmapData);
			
			var material1:TextureMaterial = new TextureMaterial(texture1);
			var material2:TextureMaterial = new TextureMaterial(texture2);
			var material3:TextureMaterial = new TextureMaterial(texture3);
			var material4:TextureMaterial = new TextureMaterial(texture4);
			var material5:TextureMaterial = new TextureMaterial(texture5);
			var material6:TextureMaterial = new TextureMaterial(texture6);
			_sky=new SkyBox(290000,material1,material4,material3,material6,material2,material5,0.003);
			GlobalValue.mainScene.scene3DContainer.addChild(_sky);
		}
	}
}