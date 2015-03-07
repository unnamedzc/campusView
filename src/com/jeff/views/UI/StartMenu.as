package com.jeff.views.UI
{
	import com.jeff.events.GameEvent;
	import com.jeff.managers.GameManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class StartMenu extends UIElement	
	{
		private static const END_FRAME_NUMBER:int = 25;
		private static const READY_FRAME_NUMBER:int = 10;
		private static const NORMAL_FRAME_NUMBER:int = 1;
		private static const HIGHLIGHT_FRAME_NUMBER:int = 2;
		
		private static var _isStartGame:Boolean=false;
		
		private var _registed:Boolean = false;
		private var _beginTime:Number;
		public function StartMenu(className:String)
		{
			super(className);
		}
		
		protected override function init():void
		{
			super.init();
			_em.addEventListener(_bg, Event.ENTER_FRAME, checkFrame);
			_em.addEventListener(GlobalValue.stage, Event.RESIZE, onResize);
			
			//resetGame
			//_em.addEventListener(this,GameEvent.RESTART_GAME,onRestart)
		}
		
		public function reset():void
		{
			init();
			_registed=false;
			this.visible=true;
			(_bg as MovieClip).play();
		}
		
		private function onResize(event:Event):void
		{
			this.x = GlobalValue.stage.stageWidth / 2;
			this.y = GlobalValue.stage.stageHeight / 2;
		}
			
		private function checkFrame(e:Event):void
		{
			if ((_bg as MovieClip).currentFrame == READY_FRAME_NUMBER && _registed == false)
			{
				//_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.ROLL_OVER, newGameRoolOver);
				//_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.ROLL_OUT, newGameRoolOut);
				_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.CLICK, newGameClick);
				_registed = true;
			}
			else if ((_bg as MovieClip).currentFrame >= END_FRAME_NUMBER)
			{
				_em.removeAllListener();
				if(!_isStartGame)
				{
					_isStartGame=true;
					this.dispatchEvent(new GameEvent(GameEvent.SHOW_NAVIGATION));		
				}else
				{
					this.visible=false;
					//GameManager.getInstance().dispatchEvent(new GameEvent(GameEvent.NEW_GAME));
				}
			}
		}
		
		private function newGameRoolOver(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.BUTTON;
			//_bg["mcNewGameWrapper"]["mcContent"].gotoAndStop(HIGHLIGHT_FRAME_NUMBER);
		}
		
		private function newGameRoolOut(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;
			//_bg["mcNewGameWrapper"]["mcContent"].gotoAndStop(NORMAL_FRAME_NUMBER);
		}
		
		private function newGameClick(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;
			//GlobalValue.stage.mouseLock=true;
			
			(_bg as MovieClip).play();
			Mouse.hide();
		}
	}
}