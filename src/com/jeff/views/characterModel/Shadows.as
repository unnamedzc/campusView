package com.jeff.views.characterModel
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.shadows.DirectionalLightShadow;

	public class Shadows
	{
		private var shadow:DirectionalLightShadow = new DirectionalLightShadow(4000, 2000, -1900, 1000, 2048,1);
		private var directionalLight:DirectionalLight = new DirectionalLight(0xddaaaa);
		private var playerModel:Object3D;
		public function Shadows(terrain:Object3D,player:Object3D)
		{
			//shadow
			playerModel=player
			directionalLight.z=2000;
			//directionalLight.y=-300;
			directionalLight.x=-1000;
			directionalLight.lookAt(0, 0, 0);
			GlobalValue.mainScene.scene3DContainer.addChild(directionalLight);		
			directionalLight.intensity=0.28;
			
			shadow.addCaster(terrain);			
			shadow.addCaster(player);
			
			/*for (var i:* in enemyModel)
			{
				shadow.addCaster(enemyModel[i]._characterContainer);
			}*/
			
			directionalLight.shadow = shadow;
		}
		public function update():void{
			shadow.centerX=playerModel.x;
			shadow.centerY=playerModel.y;
			shadow.centerZ=playerModel.z;
		}
	}
}