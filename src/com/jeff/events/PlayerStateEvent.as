package com.jeff.events
{
	public class PlayerStateEvent extends BaseEvent
	{
		public static const PLAYER_STATE_CHANGE:String="playerstatechange";
		
		public function PlayerStateEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, $data, bubbles, cancelable);
		}
	}
}