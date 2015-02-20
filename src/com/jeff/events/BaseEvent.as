package com.jeff.events
{
	import flash.events.Event;
	
	public class BaseEvent extends Event
	{
		public var data:*;
		
		public function BaseEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data=$data;
		}
	}
}