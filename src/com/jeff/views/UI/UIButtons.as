package com.jeff.views.UI
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class UIButtons extends HUD
	{
		private var _name:String;
		public function UIButtons(className:String,btName:String)
		{
			super(className);
			
			_name = btName;
		}
		
		protected override function init():void
		{
			super.init();
			
			//_bg["Name"].text="ok";
			//bar = _bg["mcHealthPanel"]["mcBar"];
			//actionMC = _bg["action_mc"];
			//_freezeMC= _bg["action_mc"]["freeze"];
			//actionMC.gotoAndStop(1);
			//barFullSize = bar.width;
		}
		
		
		
	}
}