package com.jeff.managers.characterManager
{
	import alternativa.engine3d.collisions.EllipsoidCollider;
	import alternativa.engine3d.primitives.GeoSphere;
	
	import com.jeff.events.ParticleEffectEvent;
	import com.jeff.events.PlayerStateEvent;
	import com.jeff.managers.EventManager;
	import com.jeff.object.PlayerObject;
	import com.jeff.util.DemoMath;
	import com.jeff.views.CameraController;
	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	public class PlayerManager extends EventDispatcher
	{
		private static var _weaponIndex:uint=0;
		private static const _weaponArray:Array=["","sword","buster","cannon"];
		public static const IDLE:String = "idle"; 
		public static const RUN:String = "run"; 
		public static const WALK:String = "walk"; 
		public static const JUMP_RISING:String = "jump_rising";
		public static const JUMP_FALLING:String = "jump_falling"; 
		public static const JUMP_LANDING:String = "jump_landing"; 
		public static const ATTACK:String = "attack";
		public static const BEATTACKED:String = "beattacked"; 
		public static const DIE:String = "die";
		public static const ACTIVATION:String="activation";
		public static const DEACTIVATION:String="deactivation";
		public static const ATTACK_DISTANCE:int= 350;
		public static const ATTACK_FAN_RANGE:int = 45;
		public static const ATTACK_HEIGHT_RANGE:int= 150;
		private static const TURN_SPEED:Number = Math.PI / (0.2 * GlobalValue.FPS); // turn speed
		private static const CHARACTER_MAX_HEALTH:Number = 350;	
		private static const CHARACTER_ATTACK_DAMAGE:Number = 300; 
		
		private var _em:EventManager;
		//private var _enemy:EnemyObject;
		private var _playerObject:PlayerObject;
		private var _turnLeft:Boolean;
		private var _turnRight:Boolean;
		private var _moveForward:Boolean;
		private var _moveBackward:Boolean;
		private var _jumpUp:Boolean;
		private var _quotiety:int=1;
		private var _attack:Boolean;
		private var _switchWeapon:Boolean;	
		private var _aimEnemy:Boolean;
		private var _deltaTime:Number=0;
		private var _rotationZtoEnemy:Number=0;
		private var _activateAll:Boolean;
		private var _cannonCD:Boolean;
		private var _intervalAngle:int=0;
		
		private var _isJumping:Boolean=false;
		private var _isLanding:Boolean=false;
		private var _isAttacking:Boolean=false;
		private var _canAttack:Boolean=false;
		private var _canMove:Boolean=false;
		private var _weaponSwitching:Boolean;
		private var _hadJudged:Boolean=true;
		private var _hadBeAttacked:Boolean;
		private var _ifAttackEnemy:Boolean;
		private var _shootBeStop:Boolean;
		
		private var _onGround:Boolean;
		private var _onEnemy:Boolean;
		private var _collisionPoint:Vector3D = new Vector3D();
		private var _collisionPlane:Vector3D = new Vector3D();
		private var _destination:Vector3D=new Vector3D(); 
		private var _turnDestination:Number;
		private var _turnOffset:Number;
		//
		private var _personPos:Vector3D = new Vector3D();
		private var _cameraPos:Vector3D = new Vector3D();
		private var _lVector:Vector3D = new Vector3D();
		private var _rVector:Vector3D = new Vector3D();
		private var _fVector:Vector3D = new Vector3D();
		private var _bVector:Vector3D = new Vector3D();
		private var _finalVector:Vector3D = new Vector3D();
		//	
		public var isDead:Boolean=false;
		public var landingComplete:Boolean=false;
		public var beginJudgeAttack:Boolean=false;	
		public var beAttacked:Boolean=false;
		public var activationWeapon:Boolean=false;

		public var activationWeaponComplete:Boolean=false;
		public var deactivationWeaponComplete:Boolean=false;
		public var attackComplete:Boolean=false;
		public var attackIsComplete:Boolean=false;
		public var beAttackedComplete:Boolean=false;

		public function set cannonCD(value:Boolean):void
		{
			_cannonCD = value;
		}

		public function get isAttacking():Boolean
		{
			return _isAttacking;
		}

		public static function get weaponArray():Array
		{
			return _weaponArray;
		}
		
		public static function set weaponIndex(value:uint):void
		{
			_weaponIndex = value;
		}

		public static function get weaponIndex():uint
		{
			return _weaponIndex;
		}

		public function get collider():EllipsoidCollider
		{
			return GlobalValue.mainScene.scene3D.playerModel.ellipsoidCollider;
		}
		
		public function get playerObject():PlayerObject
		{
			return _playerObject;
		}	
		
		public function PlayerManager()
		{
			init();
		}
		
		private function init():void
		{
			_playerObject=new PlayerObject();
			addKeyBoardEvent();
		}
		
		private function addKeyBoardEvent():void
		{
			_em=new EventManager();
			_em.addEventListener(GlobalValue.stage,KeyboardEvent.KEY_DOWN,keyDownHandler);
			_em.addEventListener(GlobalValue.stage,KeyboardEvent.KEY_UP,keyUpHandler);
			//_em.addEventListener(GlobalValue.stage,MouseEvent.CLICK,clickHandler);
			//_em.addEventListener(GlobalValue.stage,MouseEvent.RIGHT_MOUSE_DOWN,onRightDownHandler);
			//_em.addEventListener(GlobalValue.stage,MouseEvent.RIGHT_MOUSE_UP,onRightUpHandler);
		}
		private function onRightDownHandler(e:MouseEvent):void
		{
			if(weaponArray[weaponIndex]=="cannon")
			_aimEnemy=true;
		}	
		private function onRightUpHandler(e:MouseEvent):void
		{
			_aimEnemy=false;
		}
		private function clickHandler(e:MouseEvent):void
		{
			if(_activateAll && !GlobalValue.gameOver)
			{
				if(_canAttack&&!_isAttacking&&!_weaponSwitching&&!_isJumping&&!_isLanding&&!beAttacked&&!isDead)
				{
					if(weaponIndex>0)
					{										
						if(weaponArray[weaponIndex]=="cannon")
						{
							if(!_cannonCD)
							{
								changeState(ATTACK);
								_isAttacking=true;
								_hadJudged=false;
								this.dispatchEvent(new ParticleEffectEvent(ParticleEffectEvent.CANNON_FIRE));
								_cannonCD=true;
								//GlobalValue.mainScene.scene2D.playerHealthBar.cannonFreeze();
							}
						}
						else
						{
							changeState(ATTACK);
							_isAttacking=true;
							_hadJudged=false;
						}
					}			
				}
			}
			_activateAll=true;
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{	
				case "A".charCodeAt():
				case Keyboard.LEFT:
					_turnLeft = true;
					break;
				case "D".charCodeAt():
				case Keyboard.RIGHT:
					_turnRight = true;
					break;
				case "W".charCodeAt():
				case Keyboard.UP:
					_moveForward = true;
					break;
				case "S".charCodeAt():
				case Keyboard.DOWN:	
					_moveBackward = true;
					break;
				case Keyboard.SPACE:
					_jumpUp=true;
					break;
				case "1".charCodeAt():
					CameraController.cameraMode=="thirdPerson"?CameraController.cameraMode="freeMode":CameraController.cameraMode="thirdPerson";
					GlobalValue.mainScene.scene3D.cameraController.setCameraController();
					break;
				case "E".charCodeAt(): 
					if(!_switchWeapon)
					{
						_switchWeapon=true;
					}				
					break;	
				case "H".charCodeAt(): //reset codeww
					//if(GlobalValue.DEBUG)
					{
						var randomNum:Number = Math.random();
						if(randomNum >0.66){
							_playerObject.x=-3810;_playerObject.y=7735;_playerObject.z=-554.8;
						}
						else if(randomNum>0.33){
							_playerObject.x=-255;_playerObject.y=4380;_playerObject.z=-544;
						}else{
							_playerObject.x=-60;_playerObject.y=-1226;_playerObject.z=161.75;
						}
						_playerObject.rotationZ=0;
						_playerObject.vx=_playerObject.vy=_playerObject.vz=0;
						_moveForward=_moveBackward=_turnLeft=_turnRight=false;
						_playerObject.weaponAndState="";
						isDead=_weaponSwitching=_isJumping=_isLanding=isDead=_isAttacking=beAttacked=_hadBeAttacked=_hadJudged=_activateAll=false;
						_playerObject.currentHp= CHARACTER_MAX_HEALTH
						//GlobalValue.mainScene.scene2D.playerHealthBar.setValue(_playerObject.currentHp / CHARACTER_MAX_HEALTH);
						_canMove=true;		
					}
					break;
				case "R".charCodeAt(): //test code
					if(GlobalValue.DEBUG)
					{
						_fVector.scaleBy(6 * _playerObject.moveSpeed);
						_playerObject.x+=_fVector.x;
						_playerObject.y+=_fVector.y;
						if(_playerObject.x>5000) _playerObject.x=5000;
						if(_playerObject.y>5000) _playerObject.y=5000;
						if(_playerObject.x<-5000) _playerObject.x=-5000;
						if(_playerObject.y<-5000) _playerObject.y=-5000;
					}
					break;	
				case Keyboard.SHIFT:
					if(GlobalValue.DEBUG)
					{
						_quotiety==1?_quotiety=3:_quotiety=1;
					}
					break;
			}
		}
		
		private function keyUpHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{	
				case "A".charCodeAt():
				case Keyboard.LEFT:
					_turnLeft = false;
					break;
				case "D".charCodeAt():
				case Keyboard.RIGHT:
					_turnRight = false;
					break;
				case "W".charCodeAt():
				case Keyboard.UP:
					_moveForward = false;
					break;
				case "S".charCodeAt():
				case Keyboard.DOWN:	
					_moveBackward = false;
					break;
				case Keyboard.SPACE:
					_jumpUp=false;
					break;
				case Keyboard.NUMPAD_ADD:
					if(GlobalValue.DEBUG)
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					if(GlobalValue.DEBUG)
					break;
			}	
		}
	
		public function update():void
		{
			//updateForEnemy();
			updateState();
			updateDisplacement();		
		}
		
		private function changeState(state:String):void
		{
			if(_playerObject.weaponAndState!=weaponArray[weaponIndex]+"_"+state)
			{
				_playerObject.weaponAndState=weaponArray[weaponIndex]+"_"+state;
				this.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.PLAYER_STATE_CHANGE,_playerObject.weaponAndState));
			}
		}
		
		private function updateState():void
		{	
			if(Math.round(DemoMath.vectorXYLength(_playerObject.displacment))==_playerObject.moveSpeed)
			{
				changeState(WALK);
				
				_deltaTime=GlobalValue.gm.deltaTime;
				_playerObject.fallSpeed -= 0.5*GlobalValue.GRAVITY*_deltaTime*_deltaTime;
				
			}
			//activate idle animation
			if(Math.round(DemoMath.vectorXYLength(_playerObject.displacment))==0)
			{
				changeState(IDLE);
			}
			
		}	
		
		private function updateDisplacement():void
		{
			
			if(/*_canMove&&!_isLanding&&!_weaponSwitching&&!_isAttacking&&!beAttacked&&!isDead&&!GlobalValue.gameOver&&*/CameraController.cameraMode=="thirdPerson")
			{
				_personPos.x = _playerObject.x;
				_personPos.y = _playerObject.y;
				_personPos.z = 0;
				_cameraPos.x = GlobalValue.mainScene.scene3D.cameraController.coords.x;
				_cameraPos.y = GlobalValue.mainScene.scene3D.cameraController.coords.y;
				_cameraPos.z = 0;
				var moveDirection:Vector3D = _personPos;
				moveDirection = moveDirection.subtract(_cameraPos);
				moveDirection.normalize();
				_lVector.x = moveDirection.y * (-1);  _lVector.y = moveDirection.x; _lVector.z = 0;
				_rVector.x = moveDirection.y;         _rVector.y = moveDirection.x * (-1); _rVector.z = 0;
				_fVector = moveDirection;
				_bVector.x = _fVector.x * (-1); _bVector.y = _fVector.y * (-1); _bVector.z = _fVector.z * (-1);
				if (moveDirection.crossProduct(_lVector).z < 0)
				{
					var tempV:Vector3D = _lVector;
					_lVector = _rVector;
					_rVector = tempV;
				}
				_finalVector.x = _finalVector.y = _finalVector.z = 0;
				if (_turnLeft)
				{
					_finalVector = _finalVector.add(_lVector);
				}
				if (_turnRight)
				{
					_finalVector = _finalVector.add(_rVector);
				}
				if (_moveForward)
				{
					_finalVector = _finalVector.add(_fVector);
				}
				if (_moveBackward)
				{
					_finalVector = _finalVector.add(_bVector);
				}
				_finalVector.normalize();	
				_finalVector.scaleBy(_playerObject.moveSpeed);
				_playerObject.vx = _finalVector.x;
				_playerObject.vy = _finalVector.y;
				if (_finalVector.x != 0 || _finalVector.y != 0 || _finalVector.z != 0)
				{
					var rotation:Number = DemoMath.calculateRoataionZByV(_finalVector);
					_turnDestination = rotation + Math.PI / 2;
					_turnDestination = DemoMath.normalizeDegree(_turnDestination);
					_turnOffset = DemoMath.normalizeDegree(_turnDestination - DemoMath.normalizeDegree(_playerObject.rotationZ));
					if (_turnOffset > Math.PI)
						_turnOffset = _turnOffset - 2 * Math.PI;  // range from [-Math.PI, 0] U [0, Math.PI]
					if (TURN_SPEED < Math.abs(_turnOffset))
						rotation = _turnOffset / Math.abs(_turnOffset) * TURN_SPEED;
					else
						rotation = _turnOffset;
					_playerObject.rotationZ = (_playerObject.rotationZ + rotation);
				}
			}
			collisionDetection();
		}
				
		private function collisionDetection():void
		{	
			var characterCoords:Vector3D= new Vector3D(_playerObject.x, _playerObject.y, _playerObject.z+90);
			GlobalValue.camera.startTimer();
			_onGround =collider.getCollision(characterCoords, new Vector3D(0, 0, _playerObject.fallSpeed), _collisionPoint, _collisionPlane,GlobalValue.terrainContainer);		
			if (_onGround&&_collisionPlane.z > 0.5) 
			{
				_playerObject.fallSpeed = 0;
			} 		
			_playerObject.vz = _playerObject.fallSpeed;	
			// Collision detection
			_destination = GlobalValue.mainScene.scene3D.playerModel.ellipsoidCollider.calculateDestination(characterCoords, _playerObject.displacment, GlobalValue.terrainContainer);	
			//trace(_destination.z)
			if(_destination.z>90)
			{
				_destination.z-= 90;
			}else
			{
				_destination.z=90;
			}
			/*if(GlobalValue.gm.enemyManager!=null)
			{
				var __enemySphere:GeoSphere;
				var i:int = 0;
				var max:int = GlobalValue.enemySphere.length;
				for (i = 0; i < max; i++)
				{
					__enemySphere = GlobalValue.enemySphere[i]
					_onEnemy = collider.getCollision(characterCoords, _playerObject.displacment, _collisionPoint, _collisionPlane, __enemySphere);				
					if (_onEnemy)
					{
						_destination = collider.calculateDestination(characterCoords, _playerObject.displacment, __enemySphere);				
						if(!_onGround)
						{
							_destination.z-= 90;
						}
						else
						{
							_destination.z=characterCoords.z-90;
						}
					}
				}	
			}	*/
			GlobalValue.camera.stopTimer();
			_playerObject.x = _destination.x;
			_playerObject.y = _destination.y;
			_playerObject.z = _destination.z;
		}
		
		public function reset():void
		{
			_playerObject.x=-3726;_playerObject.y=7602;_playerObject.z=-554.8;_playerObject.rotationZ=-5.446;
			_playerObject.vx=_playerObject.vy=_playerObject.vz=0;
			_moveForward=_moveBackward=_turnLeft=_turnRight=false;
			_playerObject.weaponAndState="";
			isDead=_weaponSwitching=_isJumping=_isLanding=isDead=_isAttacking=beAttacked=_hadBeAttacked=_hadJudged=_activateAll=false;
			_playerObject.currentHp= CHARACTER_MAX_HEALTH
			//GlobalValue.mainScene.scene2D.playerHealthBar.setValue(_playerObject.currentHp / CHARACTER_MAX_HEALTH);
			addKeyBoardEvent();
			_canMove=_canAttack=true;		
		}
		
		public function destroy():void
		{
			_em.removeAllListener();
			_em = null;
		}
	}
}