package com.jeff.views.UI
{
	import com.jeff.events.GameEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;
	
	public class StartMenu extends UIElement
	{
		private static const END_FRAME_NUMBER:int = 40;
		private static const READY_FRAME_NUMBER:int = 20;
		private static const NORMAL_FRAME_NUMBER:int = 1;
		private static const HIGHLIGHT_FRAME_NUMBER:int = 2;
		
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
				_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.ROLL_OVER, newGameRoolOver);
				_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.ROLL_OUT, newGameRoolOut);
				_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.CLICK, newGameClick);
				_registed = true;
			}
			else if ((_bg as MovieClip).currentFrame >= END_FRAME_NUMBER)
			{
				_em.removeAllListener();
				this.dispatchEvent(new GameEvent(GameEvent.SHOW_NAVIGATION));		
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
			
			(_bg as MovieClip).play();
			Mouse.hide();
		}
	}
}