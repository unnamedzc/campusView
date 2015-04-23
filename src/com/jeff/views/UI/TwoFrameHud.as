package com.jeff.views.UI
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class TwoFrameHud extends HUD
	{
		public var popupContent:MovieClip;
		public var restartButton:SimpleButton;
		public function TwoFrameHud(className:String="Popup")
		{
			super(className);
		}
		
		override protected function init():void
		{
			super.init();
			
			popupContent = _bg as MovieClip;
			popupContent.gotoAndStop(1);
			
			popupContent.addEventListener(MouseEvent.CLICK,onClick);
			//restartButton = _bg["popupContent"]["mcPopup"]["mcBackIcon"];
			//_direction = HUD_DIR_CENTER;
			//_margin = 20;
		}
		
		private function onClick(e:MouseEvent):void
		{
			(popupContent as MovieClip).currentFrame == 1 ? (popupContent as MovieClip).gotoAndStop(2):(popupContent as MovieClip).gotoAndStop(1)
		}
	}
}