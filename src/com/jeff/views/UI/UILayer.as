package com.jeff.views.UI 
{
	import com.jeff.events.GameEvent;
	import com.jeff.managers.EventManager;
	import com.jeff.views.UI.UIButtons;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class UILayer extends Sprite
	{	
		public var startMenu:StartMenu = new StartMenu("StartMenuWeb");
		
		public var playerHealthBar:PlayerHealthBar = new PlayerHealthBar("player");
		public var popupUI:RestartPopup=new RestartPopup();
		private var xfBt :UIButtons=new UIButtons("xf","");
		private var tsjyBt:UIButtons=new UIButtons("tsjy","");
		private var jwxxBt:UIButtons=new UIButtons("jwxx","");
		
		private var chatBar:UIElement=new UIElement("chat");
		
		private var bcBar:TwoFrameHud=new TwoFrameHud("bczn");
		private var ggBar:TwoFrameHud=new TwoFrameHud("ggxx");
		private var mapFrame:UIElement =new UIElement("map");
		
		private var popFrame:PopUpFrame = new PopUpFrame("popFrame");
		//private var tBt:UIButtons=new UIButtons("buttons","stu");
		public var navigationMenu:NavigationMenu //= new NavigationMenu("ctrl");
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
			
			_em.addEventListener(GlobalValue.gm, GameEvent.RESTART_GAME, reshowStartMenu);
		}
		
		private function hideNavigation(e:GameEvent):void
		{
			if(this.contains(navigationMenu))
			{
				this.removeChild(navigationMenu);
				GlobalValue.stage.focus=GlobalValue.stage;
				GlobalValue.gm.newGame();
			}
		}
		
		private function showNavigation(e:GameEvent):void
		{
			this.removeChildren();
			navigationMenu = new NavigationMenu("ctrl");
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
			
			addChild(xfBt);
			addChild(tsjyBt);
			addChild(jwxxBt);
			addChild(mapFrame);
			
			
						
			popFrame.x = (GlobalValue.stage.stageWidth ) / 2;
			popFrame.y = (GlobalValue.stage.stageHeight ) / 2;
			popFrame.visible=false;
			popFrame.reset();
			
			mapFrame.x=GlobalValue.stage.stageWidth-mapFrame.width;
			
			xfBt.y=GlobalValue.stage.stageHeight-100;
			xfBt.x=GlobalValue.stage.stageWidth/2;
			tsjyBt.y=GlobalValue.stage.stageHeight-100;
			tsjyBt.x=xfBt.x+100;
			jwxxBt.y=GlobalValue.stage.stageHeight-100;
			jwxxBt.x=tsjyBt.x+100;
			
			//playerHealthBar.scaleX = playerHealthBar.scaleY = playerHealthBar.scaleZ = 0.8;
			addChild(playerHealthBar);
			addChild(popupUI);			
			addChild(bcBar);
			addChild(ggBar);
			
			addChild(chatBar);
			
			addChild(popFrame);
			
			chatBar.y=GlobalValue.stage.stageHeight/2;
			
			bcBar.x=GlobalValue.stage.stageWidth -bcBar.width;
			ggBar.x=GlobalValue.stage.stageWidth -bcBar.width;
			
			bcBar.y=GlobalValue.stage.stageHeight/2 -bcBar.height*2;
			ggBar.y=GlobalValue.stage.stageHeight/2 +bcBar.height*2;
			
			popupUI.x = (GlobalValue.stage.stageWidth - popupUI.width) / 2;
			popupUI.y = (GlobalValue.stage.stageHeight - popupUI.height) / 2;
			popupUI.visible=false;
			
			_em.addEventListener(xfBt, MouseEvent.CLICK, onShowPop);
			_em.addEventListener(tsjyBt, MouseEvent.CLICK, onShowPop);
			_em.addEventListener(jwxxBt, MouseEvent.CLICK, onShowPop);
		}
		
		private function onShowPop(e:MouseEvent):void
		{
			popFrame.onShow();
		}
		
		private function endIntro(e:GameEvent):void
		{
			//this.removeChild(radio);
		}
		
		private function disappearStartMenu(e:GameEvent):void
		{
			this.removeChildren();
			startMenu=null;
			//startMenu.visible=false;
		}
		
		private function reshowStartMenu(e:GameEvent):void
		{
			if(startMenu)
			{
				this.removeChild(startMenu);
				startMenu=null;
			}
			startMenu	= new StartMenu("StartMenuWeb");
			this.addChild(startMenu);
			startMenu.x = GlobalValue.stage.stageWidth / 2;
			startMenu.y = GlobalValue.stage.stageHeight / 2;
			
			//startMenu.width=1024;
			//startMenu.height=768;
			//startMenu.visible=true;
			//startMenu.reset();
		}
		
		private function showStartMenu(e:GameEvent):void
		{
			this.removeChildren();
			//startMenu=null;
			//if(startMenu==null) startMenu	= new StartMenu("StartMenuWeb");
			this.addChild(startMenu);
			startMenu.x = GlobalValue.stage.stageWidth / 2;
			startMenu.y = GlobalValue.stage.stageHeight / 2;
			//startMenu.width=1024;
			//startMenu.height=768;
		}
		
	}
}