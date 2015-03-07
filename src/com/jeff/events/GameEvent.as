package com.jeff.events 
{
	import com.jeff.events.BaseEvent;
	
	public class GameEvent extends BaseEvent
	{
		public static const START_MENU_EVENT:String = "startmenustart";
		public static const RESTART_GAME:String = "restartgame";
		public static const NEW_GAME:String = "newgame";
		public static const SHOW_NAVIGATION:String = "showNavigation";
		public static const HIDE_NAVIGATION:String = "hideNavigation";
		
		public static const BEGIN_INTRO:String = "beginintro";
		public static const END_INTRO:String = "endintro";
		public static const ENEMY_BE_ATTACKED:String = "enemybeattacked";
		public static const ENEMY_DEFEAT:String = "enemydefeat";
		
		public static const LOAD_A3D_COMPLETE:String="loada3dcomplete";
		
		
		public function GameEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}