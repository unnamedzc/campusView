package com.jeff.views
{
	import alternativa.engine3d.collisions.EllipsoidCollider;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.View;
	
	import com.jeff.managers.EventManager;
	import com.jeff.object.PlayerObject;
	import com.jeff.util.DemoMath;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	
	
	public class CameraController
	{	
		public var camera:Camera3D;
		private var _cameraCollisionBall:EllipsoidCollider;
		private var _playerObject:PlayerObject;
		private var _controller:SimpleObjectController;
		private var _prevCoords:Vector3D = new Vector3D();
		private var _controllerCoords:Vector3D;
		private var _playPos:Vector3D = new Vector3D();
		public static var cameraMode:String="thirdPerson";
		public static var randomCamActive:Boolean;
		private var _collisionPoint:Vector3D = new Vector3D();//碰撞点
		private var _collisionPlane:Vector3D = new Vector3D();//碰撞面
		private var _em:EventManager = new EventManager();
		
		private static const CAMERA_DISTANCE:Number = 500;
		private static const CAMERA_HEIGHT:Number = 190;
		private static const CAMERA_MAX_ROTATION:Number = Math.PI / 180 * 3600; //每帧最多旋转6度
		private static const CAMERA_MAX_VALUE:Number = 200; //鼠标阀值 150
		private var _cameraFixVector3D:Vector3D=new Vector3D();	
		
		private var _mousePrevValue:int = -1;
		private var _mouseCurrentValue:int = -1;
		private var _mouseOffset:int = 0;
		private var _cameraRotation:Number;
		private var _tempV1:Vector3D = new Vector3D();
		private var _tempV2:Vector3D = new Vector3D();
		private var _rotateMatrix:Matrix3D = new Matrix3D();
		
		public function CameraController()
		{
			init();	
		}
		
		private function init():void
		{
			camera=new Camera3D(10,40000);
			GlobalValue.mainScene.scene3DContainer.addChild(camera);
			camera.view=new View(GlobalValue.stageWidth,GlobalValue.stageHeight);
			camera.view.antiAlias=4;
			camera.view.hideLogo();
			GlobalValue.stage.addChild(camera.view);
			if(GlobalValue.DEBUG)
				GlobalValue.stage.addChild(camera.diagram);
			camera.rotationX=120 * Math.PI/180;
			camera.y=-300;
			camera.z=200;
			_controller=new SimpleObjectController(GlobalValue.stage,camera,0,0,0);
			_playerObject=GlobalValue.gm.playerManager.playerObject;
			camera.view.width = GlobalValue.stage.stageWidth;
			camera.view.height = GlobalValue.stage.stageHeight;
			
			camera.debug=GlobalValue.DEBUG;
			GlobalValue.stage.addEventListener(Event.RESIZE, onResizeHandler);
			_cameraCollisionBall = new EllipsoidCollider(5, 5, 5); // Create a small(radius 5 cm) ellipsoid collider
			_em.addEventListener(GlobalValue.stage, MouseEvent.MOUSE_MOVE, cameraRotate);
		}
		
		private function cameraRotate(event:MouseEvent):void
		{
				if (_mousePrevValue == -1)
						_mousePrevValue = event.localX;
					if (_mouseCurrentValue == -1)
							_mouseCurrentValue = event.localX;
				_mouseCurrentValue = event.localX;
		}
		
		public function update():void
		{
			if(!GlobalValue.gameOver)
			{
				_rotateMatrix.identity();
				_mouseOffset = _mouseCurrentValue - _mousePrevValue;
				_mousePrevValue = _mouseCurrentValue;
				var lr:Boolean = false; // l: false r: right
				lr = _mouseOffset < 0 ? false : true;
				var rotation:Number = 0;
				rotation = Math.abs(_mouseOffset) / CAMERA_MAX_VALUE;
				rotation = rotation > 1 ? 1: rotation;
				rotation = CAMERA_MAX_ROTATION * rotation;
				rotation = lr ? rotation * (-1) : rotation;
				
				var persent:Number = _mouseOffset / CAMERA_MAX_VALUE;
				
				switch(cameraMode)
				{			
					case "thirdPerson":
						_playPos.x = _playerObject.x; 
						_playPos.y = _playerObject.y; 
						_playPos.z = _playerObject.z;
						if (_controllerCoords != null)
						{
							_controllerCoords.z = _playPos.z;
							var D:Number = DemoMath.distanceXYZ(_playPos, _controllerCoords);
							_controllerCoords.x = _playPos.x - (CAMERA_DISTANCE / D) * (_playPos.x - _controllerCoords.x);
							_controllerCoords.y = _playPos.y - (CAMERA_DISTANCE / D) * (_playPos.y - _controllerCoords.y);
							_controllerCoords.z = _playPos.z - (CAMERA_DISTANCE / D) * (_playPos.z - _controllerCoords.z) + CAMERA_HEIGHT;
							// deal with rotation
							_tempV1.x = _playerObject.x; _tempV1.y = _playerObject.y; _tempV1.z = _playerObject.z + 170; //轴点
							_tempV2.x = 0; _tempV2.y = 0; _tempV2.z = 100;
							_rotateMatrix.appendRotation(rotation, _tempV2, _tempV1);
							_controllerCoords = _rotateMatrix.transformVector(_controllerCoords);
						}
						else
						{
							_controllerCoords = new Vector3D( _playPos.x + CAMERA_DISTANCE * Math.sin(_playerObject.rotationZ),
								_playPos.y + CAMERA_DISTANCE * Math.cos(_playerObject.rotationZ), 
								_playPos.z + CAMERA_HEIGHT);
							_prevCoords.x = _controllerCoords.x;
							_prevCoords.y = _controllerCoords.y;
							_prevCoords.z = _controllerCoords.z;
						}
						// If enable camera collision would decline performance obviously
						//collisionDection();
						_controller.setObjectPos(_controllerCoords);
						_controller.lookAtXYZ(_playerObject.x, _playerObject.y, _playerObject.z + 170);
						break;
				}	
			}
			_controller.update();
			camera.render(GlobalValue.stage3D);
		}
		public function setCameraController():void
		{
			switch(cameraMode)
			{			
				case "thirdPerson":
					_controller.speed=0;
					_controller.speedMultiplier=0;
					_controller.mouseSensitivity=0;
					break;
				case "freeMode":
					_controller.speed=200;
					_controller.speedMultiplier=5;
					_controller.mouseSensitivity=1;
					break;
			}
		}
		
		private function collisionDection():void
		{
			var onGround:Boolean;
			onGround = _cameraCollisionBall.getCollision(_prevCoords, _controllerCoords.subtract(_prevCoords), _collisionPoint, _collisionPlane,GlobalValue.terrainContainer);
			if (onGround)
			{
				_controllerCoords = _collisionPoint;
			}
		}
		
		public function get coords():Vector3D
		{
			return _controllerCoords;
		}
		
		public function get cameraFixVector3D():Vector3D
		{
			return _cameraFixVector3D;
		}
		
		public function set cameraFixVector3D(vector3D:Vector3D):void
		{
			_cameraFixVector3D=vector3D;
		}
		
		private function onResizeHandler(e:Event = null):void 
		{
			camera.view.width = GlobalValue.stage.stageWidth;
			camera.view.height = GlobalValue.stage.stageHeight;
		}
		
	}
}