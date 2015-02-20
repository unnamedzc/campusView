package com.jeff.views.UI
{
	import flash.display.MovieClip;
	import com.jeff.managers.TimerManager;

	public class NavigationMenu extends HUD
	{
		private var menu:MovieClip;
		private var _currentIndex:int = 0;
		
		private static const MAX_HINT_SCREEN:int = 3;
		private static const CHANGE_INTERVAL:int = 10000; // 10 seconds to change hint screen

		public function NavigationMenu(className:String)
		{
			super(className);
		}
		
		protected override function init():void
		{
			super.init();
			_direction = HUD_DIR_LEFT_DOWN;
			_margin = 20;
			menu = _bg["ctrl"];
			(_bg as MovieClip).gotoAndStop(_currentIndex + 1);
			GlobalValue.timer.addCallBack(changeScene, CHANGE_INTERVAL, true, false);
		}
		
		private function changeScene(e:int):void
		{
			_currentIndex = ++_currentIndex % MAX_HINT_SCREEN;
			(_bg as MovieClip).gotoAndStop(_currentIndex + 1);
		}
	}
	
}