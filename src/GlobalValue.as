package  
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.primitives.GeoSphere;
	
	import com.jeff.managers.GameManager;
	import com.jeff.managers.TimerManager;
	import com.jeff.views.MainScene;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.system.Capabilities;
	
	public class GlobalValue
	{	
		public static const DEBUG:Boolean = false;
		public static const PERMIT_VERSION_1:Number = 11;
		public static const PERMIT_VERSION_2:Number = 2;
		public static const FPS:int = 30;
		public static const TIME_SCALE:Number = 0.7;
		public static const GRAVITY:int=9000;
		public static const JUMP_START_SPEED:Number=1150;
		public static const CROSS_ZOOM_RATE:Number=0.0007;
		public static const PLAYER_ATTACK_SPEED:Number=1;
		public static const FALLING_START_SPEED:Number=-2 * JUMP_START_SPEED * TIME_SCALE / FPS;
		public static const LOW_QUALITY:int = 0;
		public static const HIGH_QUALITY:int = 1;
		
		public static var root:Sprite;
		public static var stage:Stage;
		public static var stage3D:Stage3D;
		public static var context3D:Context3D;
		public static var stageWidth:int;
		public static var stageHeight:int;
		
		public static var gm:GameManager;
		public static var mainScene:MainScene;
		public static var timer:TimerManager;
		public static var gameOver:Boolean;
		
		public static var displayQuality:int = HIGH_QUALITY;
		
		public static function init($root:Sprite, $stage:Stage, $stage3D:Stage3D, $context3D:Context3D):void
		{
			root = $root;
			refresh3DEnvironment($stage, $stage3D, $context3D);
			timer = new TimerManager();
		}
		
		public static function checkPlayerVersion():Boolean
		{
			var version:String = Capabilities.version;
			version = version.substr(4);
			var platformInfo:Array = version.split(",");
			if (Number(platformInfo[0]) > PERMIT_VERSION_1)
				return true;
			else if (Number(platformInfo[0]) == PERMIT_VERSION_1 && 
					 Number(platformInfo[1]) >= PERMIT_VERSION_2)
				return true;
			else
				return false;
		}
		
		public static function setDisplayQuality(driverInfo:String):void
		{
			if (driverInfo.indexOf("software") != -1)
			{
				displayQuality = LOW_QUALITY;
			}
			else
			{
				displayQuality = HIGH_QUALITY;
			}
		}
		
		public static function refresh3DEnvironment($stage:Stage, $stage3D:Stage3D, $context3D:Context3D):void
		{
			stage = $stage;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			stage3D = $stage3D;
			context3D = $context3D;
		}
		
		public static function initilize3DEngine():void
		{
			gm = GameManager.getInstance();
			gm.init();
			mainScene = MainScene.getInstance();
			mainScene.init();
		}
		
		public static function startUP3DEngine():void
		{
			gm.startUp();
		}
		
		public static function get camera():Camera3D
		{
			return mainScene.scene3D.cameraController.camera;
		}
		public static  function get terrainContainer():Object3D
		{
			return mainScene.scene3D.terrain.collisionTerrain;
		}	
		/*public static function get enemySphere():Vector.<GeoSphere>
		{
			if (null != GlobalValue.mainScene.scene3D.enemyModel)
			{
				var i:int = 0;
				var max:int = GlobalValue.mainScene.scene3D.enemyModel.length;
				var __enemyModel:EnemyModel;
				var __sphere:GeoSphere;
				var __enemySphere:Vector.<GeoSphere> = new Vector.<GeoSphere>();
				
				for (i = 0; i < max; i++)
				{
					__enemyModel = GlobalValue.mainScene.scene3D.enemyModel[i];
					__sphere = __enemyModel.sphere;
					__enemySphere.push(__sphere);
				}
			}
			return __enemySphere;
		}*/
	}
}