package com.jeff.views 
{
	import com.jeff.views.characterModel.PlayerModel;
	import com.jeff.views.characterModel.Shadows;
	import com.jeff.views.level.Sky;
	import com.jeff.views.level.Terrain;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	
	public class Scene3D
	{
		private var _sky:Sky;
		private var _terrain:Terrain;
		private var _cameraController:CameraController;
		private var _playerModel:PlayerModel;
		//public var enemyModel:Vector.<EnemyModel>;
		//private var _fireEffect:FireEffect;
		//private var _axisAndGrid:AxisAndGrid;
		private var _shadow:Shadows;	
		private var _lightHeight:int=100;
		//private var _reticuleOnEnemy:ReticuleOnEnemy;
		
		public function Scene3D()
		{
			init();
		}		
		

		public function get cameraController():CameraController
		{
			return _cameraController;
		}
		
		public function get terrain():Terrain
		{
			return _terrain;
		}
		
		public function get playerModel():PlayerModel
		{
			return _playerModel;
		}
		
		private function init():void
		{	_sky=new Sky();
			_terrain=new Terrain();
			//_reticuleOnEnemy= new ReticuleOnEnemy("cross");
			_playerModel=new PlayerModel(new Vector3D(0,0,0));		
			//_axisAndGrid=new AxisAndGrid();
			//_fireEffect=new FireEffect();
			//ResourceManager.getInstance().addEventListener(ResourceManager.loadEnemyOver, loadEnemyComplete);
			_cameraController=new CameraController();
			// 上传资源
			for each(var resource:Resource in GlobalValue.mainScene.scene3DContainer.getResources(true)){
				resource.upload(GlobalValue.stage3D.context3D);	
			}
			setPerformance();
		}
		
		private function loadEnemyComplete(e:Event):void
		{
			//ResourceManager.getInstance().removeEventListener(ResourceManager.loadEnemyOver, loadEnemyComplete);
			
			/*enemyModel = new Vector.<EnemyModel>();
			enemyModel[0] = new SpiderModel(new Vector3D(0, 0, 0), 0);
			enemyModel[1] = new CrabmanModel(new Vector3D(0, 0, 0), 1);
			enemyModel[2] = new CrabmanModel(new Vector3D(0, 0, 0), 2);*/

			// 上传资源
			for each(var resource:Resource in GlobalValue.mainScene.scene3DContainer.getResources(true)){
				resource.upload(GlobalValue.stage3D.context3D);	
			}
			setPerformance();
		}
		
		private function setPerformance():void
		{
			if(GlobalValue.displayQuality==GlobalValue.HIGH_QUALITY)
			{
				addLight();
				addShadow();
			}
		}
		
		private function addLight():void
		{
			//light
			var _light:AmbientLight=new AmbientLight(0xeeeeee)
			_light.z=10+_lightHeight;
			_light.intensity=1.1			
			GlobalValue.mainScene.scene3DContainer.addChild(_light);
			
			var _light3:DirectionalLight=new DirectionalLight(0x221111)
			
			_light3.x=-1615;_light3.y=6855;
			_light3.z=1220+_lightHeight;
			_light3.intensity=.5;	
			_light3.lookAt(-1676,6968,1064)
			GlobalValue.mainScene.scene3DContainer.addChild(_light3);
			var _light4:DirectionalLight=new DirectionalLight(0x221111)
			//	light.x=light.y=100;
			_light4.z=200+_lightHeight;
			_light4.x=350;
			_light4.y=1900;
			_light4.intensity=.5
			_light4.lookAt(350,1900,0);
			GlobalValue.mainScene.scene3DContainer.addChild(_light4);
		}
		
		private function addShadow():void
		{
			_shadow=new Shadows(terrain.shadowTerrain,_playerModel._characterContainer);
		}
		
		public function update():void
		{
			_cameraController.update();	
			_playerModel.update();
			if(null!=_shadow)
			{
				_shadow.update();
			}
			/*if(null != enemyModel) 
			{	
				if(null!=_shadow)
				{
					_shadow.update();
				}
				for (var i:int = 0; i < enemyModel.length; ++i)
				{
					enemyModel[i].setObject(GlobalValue.gm.enemyManager._enemyObject[i]);
					enemyModel[i].update();
				}	
			}*/
		}
		
		/*public function getTargetModelAnimation(index:int):String
		{
			return enemyModel[index].currentAnimation;
		}*/
		
	}
}
