package com.jeff.views.UI
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;

	public class RestartPopup extends HUD
	{
		public var popupContent:MovieClip;
		public var restartButton:SimpleButton;
		public function RestartPopup(className:String="Popup")
		{
			super(className);
		}
		
		override protected function init():void
		{
			super.init();
			popupContent = _bg["popupContent"];
			popupContent.gotoAndStop(1);
			restartButton = _bg["popupContent"]["mcPopup"]["mcBackIcon"];
			_direction = HUD_DIR_CENTER;
			_margin = 20;
		}
	}
}