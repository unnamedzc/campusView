package com.jeff.managers
{
	import com.jeff.events.GameEvent;
	//import com.jeff.managers.characterManager.EnemyManager;
	import com.jeff.managers.characterManager.PlayerManager;
	import com.jeff.util.PseudoThread;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	public class GameManager extends EventDispatcher
	{
		private static const STATE_BEFORE_GAME:String = "statebeforegame";
		private static const STATE_GAME:String = "stategame";
		private static const START_INTRO:String = "startintro";
		private static const END_INTRO:String = "endintro";
		private static const END_GAME:String = "endgame";
		
		private static const BEGIN_INTRO_DURATION:int = 2;
		private static const INTRO_DURATION:int = 5;
		
		private static var _instance:GameManager;
		public var playerManager:PlayerManager;
		private var _em:EventManager = new EventManager();
		private var _gameState:String;
		private var _lastTime:int=0;
		private var _deltaTime:Number=0;
		
		private var _displayIntroTimer:int; 
		private var _showIntroTimer:int;
		private var _enemyLoadFlag:Boolean = false;
		private var _characterLoadFlag:Boolean = false;
		
		/*private var _enemyManager:EnemyManager;
		public function get enemyManager():EnemyManager
		{
			return this._enemyManager;
		}*/
		
		public static function getInstance():GameManager
		{
			if (null == _instance)
				_instance = new GameManager();
			return _instance;
		}
		
		public function init():void
		{
			playerManager=new PlayerManager();
			
			ResourceManager.getInstance().addEventListener(ResourceManager.loadOver, loadEnemyComplete);
		}
		
		private function onShowNavigationBar(e:Event):void
		{
			/*ResourceManager.getInstance().load(ResourceManager.enemyXML);
			var obj:Object = new Object();
			obj.max = 0;
			var thread:PseudoThread = new PseudoThread(GlobalValue.stage, ResourceManager.getInstance().parserCharacterAnimation, obj);
			thread.addEventListener("threadComplete", onThreadFinished);*/
			//jeff 2015.2.5. startGame
			newGame();
		}
		
		private function onThreadFinished(e:Event):void
		{
			_characterLoadFlag = true;
			GlobalValue.mainScene.scene3D.playerModel.initPreLoadAnimation();
			checkIfHideNavigation();
		}
		
		private function loadEnemyComplete(e:Event):void
		{
			//ResourceManager.getInstance().removeEventListener(ResourceManager.loadEnemyOver, loadEnemyComplete);
			_enemyLoadFlag = true;
			checkIfHideNavigation();
			//_enemyManager = new EnemyManager();
		}
		
		private function checkIfHideNavigation():void
		{
			if (_enemyLoadFlag && _characterLoadFlag)
				this.dispatchEvent(new GameEvent(GameEvent.HIDE_NAVIGATION));
		}
		
		public function startUp():void
		{
			_em.addEventListener(GlobalValue.mainScene.scene2D.startMenu, GameEvent.SHOW_NAVIGATION, onShowNavigationBar);
			_gameState = STATE_BEFORE_GAME;
			if (GlobalValue.DEBUG)
				newGame();//for debug
			else	
			{
				dispatchEvent(new GameEvent(GameEvent.START_MENU_EVENT));//for debug
			}
			
			//newGame();
		}
				
		public function newGame():void
		{
			_gameState = STATE_GAME;
			_em.addEventListener(GlobalValue.stage, Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
			_displayIntroTimer = GlobalValue.timer.addCallBack(displayIntro, BEGIN_INTRO_DURATION * 1000, true, false);
			_lastTime = getTimer();
		}
		
		private function displayIntro(e:*):void
		{
			GlobalValue.timer.removeCallBack(_displayIntroTimer);
			dispatchEvent(new GameEvent(GameEvent.BEGIN_INTRO));
			_showIntroTimer = GlobalValue.timer.addCallBack(showIntro, INTRO_DURATION * 1000, true, false);
			playerManager.activationWeapon=true;
		}
		
		private function showIntro(e:*):void
		{
			GlobalValue.timer.removeCallBack(_showIntroTimer);
			dispatchEvent(new GameEvent(GameEvent.END_INTRO));
		}
		
		private function onEnterFrame(e:Event):void
		{
			var time:int = getTimer();
			_deltaTime = GlobalValue.TIME_SCALE*(time - _lastTime)/1000;
			_lastTime = time;
			GlobalValue.mainScene.render();
			playerManager.update();
			//if (null != _enemyManager) _enemyManager.update();	
		}
		
		public function reset():void
		{
			playerManager.reset();
			//if (null != _enemyManager) _enemyManager.reset();
		}
		
		public function destroy():void
		{
			_em.removeAllListener();
			_em = null;
			_instance = null
		}
		public function get deltaTime():Number
		{
			return _deltaTime;
		}
	}
}