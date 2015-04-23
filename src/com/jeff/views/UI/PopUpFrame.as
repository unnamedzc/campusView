package com.jeff.views.UI
{
	import com.jeff.events.GameEvent;
	import com.jeff.managers.GameManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import com.greensock.TweenLite
	import com.greensock.easing.Bounce
	
	public class PopUpFrame extends UIElement	
	{
		
		public function PopUpFrame(className:String)
		{
			super(className);
		}
		
		protected override function init():void
		{
			super.init();			
			//resetGame
			//_em.addEventListener(this,GameEvent.RESTART_GAME,onRestart)
		}
		
		public function reset():void
		{
			init();
			//_registed=false;
			this.visible=false;
			//this.alpha=0;
			this.scaleX=this.scaleY=0;
			_em.removeEventListener(_bg["close"], MouseEvent.CLICK, onCloseClick);
			
		}	
		
		public function onShow():void
		{
			this.visible=true;
			//this.alpha=1;
			//this.scaleX=this.scaleY=1;
			_em.addEventListener(_bg["close"], MouseEvent.CLICK, onCloseClick);
			TweenLite.to(this, 0.5, {scaleX:1,scaleY:1, ease:Bounce.easeOut/*,onComplete: onFinishTween, onCompleteParams:[5, this]*/});
			function onFinishTween(/*argument1:Number, argument2:MovieClip*/):void {
				//TweenLite.
				//trace("The tween has finished! argument1 = " + argument1 + ", and argument2 = " + argument2);
			}
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			reset();
		}
			
		/*private function checkFrame(e:Event):void
		{
			if ((_bg as MovieClip).currentFrame == READY_FRAME_NUMBER && _registed == false)
			{
				//_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.ROLL_OVER, newGameRoolOver);
				//_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.ROLL_OUT, newGameRoolOut);
				//_em.addEventListener(_bg["mcNewGameWrapper"], MouseEvent.CLICK, newGameClick);
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
		}	*/	
		
	}
}