package com.jeff.views.UI 
{
	import com.jeff.events.GameEvent;
	import com.jeff.managers.EventManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UILayer extends Sprite
	{	
		public var startMenu:StartMenu = new StartMenu("StartMenuWeb");
		/*public var playerHealthBar:PlayerHealthBar = new PlayerHealthBar("HealthBar");*/
		//public var popupUI:RestartPopup=new RestartPopup();
		public var navigationMenu:NavigationMenu = new NavigationMenu("ctrl");
		private var _em:EventManager = new EventManager();
		
		public function UILayer()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			_em.addEventListener(GlobalValue.stage, Event.RESIZE, onStageResize);
			_em.addEventListener(GlobalValue.gm, GameEvent.START_MENU_EVENT, showStartMenu);
			_em.addEventListener(GlobalValue.gm, GameEvent.NEW_GAME, disappearStartMenu);
			_em.addEventListener(startMenu, GameEvent.SHOW_NAVIGATION, showNavigation);
			_em.addEventListener(GlobalValue.gm, GameEvent.HIDE_NAVIGATION, hideNavigation);
			
			_em.addEventListener(GlobalValue.gm, GameEvent.BEGIN_INTRO, beginIntro);
			_em.addEventListener(GlobalValue.gm, GameEvent.END_INTRO, endIntro);
		}
		
		private function hideNavigation(e:GameEvent):void
		{
			this.removeChild(navigationMenu);
			GlobalValue.stage.focus=GlobalValue.stage;
			GlobalValue.gm.newGame();
		}
		
		private function showNavigation(e:GameEvent):void
		{
			this.removeChildren();
			this.addChild(navigationMenu);
			navigationMenu.x = GlobalValue.stage.stageWidth / 2;
			navigationMenu.y = GlobalValue.stage.stageHeight / 2;
			navigationMenu.width=GlobalValue.stage.stageWidth*0.765;
			navigationMenu.height=GlobalValue.stage.stageHeight*0.765;
		}
		
		private function onStageResize(e:Event):void
		{
			var width:Number = GlobalValue.stage.stageWidth;
			var height:Number = GlobalValue.stage.stageHeight;
			for (var i:int = 0; i < this.numChildren; ++i)
			{
				var item:DisplayObject = this.getChildAt(i);
				if (item is HUD)
				{
					var direction:int = (item as HUD).direction;
					var margin:Number = (item as HUD).margin;
					switch (direction)
					{
						case HUD.HUD_DIR_UP:
							item.x = (width - item.width) / 2;
							item.y = margin;
							break;
						case HUD.HUD_DIR_DOWN:
							item.x = (width - item.width - margin) / 2;
							item.y = height - item.height - margin;
							break;
						case HUD.HUD_DIR_LEFT:
							item.x = margin;
							item.y = (height - item.height) / 2;
							break;
						case HUD.HUD_DIR_RIGHT:
							item.x = width - margin - item.width;
							item.y = (height - item.height) / 2;
							break;
						case HUD.HUD_DIR_LEFT_DOWN:
							item.x = margin;
							item.y = height - item.height - margin;
							break;
						case HUD.HUD_DIR_CENTER:
							item.x = (width - item.width - margin) / 2;
							item.y = (width - item.width) / 6;
							break;
					}
				}
			}
		}
		
		private function beginIntro(e:GameEvent):void
		{
			/*this.addChild(radio);
			radio.x = (GlobalValue.stage.stageWidth - radio.width) / 2;
			radio.y = GlobalValue.stage.stageHeight * 4 / 5;*/
			
			//playerHealthBar.scaleX = playerHealthBar.scaleY = playerHealthBar.scaleZ = 0.8;
			//addChild(playerHealthBar);
			/*addChild(popupUI);
			popupUI.x = (GlobalValue.stage.stageWidth - popupUI.width) / 2;
			popupUI.y = (GlobalValue.stage.stageHeight - popupUI.height) / 2;
			popupUI.visible=false;*/
		}
		
		private function endIntro(e:GameEvent):void
		{
			//this.removeChild(radio);
		}
		
		private function disappearStartMenu(e:GameEvent):void
		{
			this.removeChildren();
		}
		
		private function showStartMenu(e:GameEvent):void
		{
			this.removeChildren();
			this.addChild(startMenu);
			startMenu.x = GlobalValue.stage.stageWidth / 2;
			startMenu.y = GlobalValue.stage.stageHeight / 2;
		}
		
	}
}