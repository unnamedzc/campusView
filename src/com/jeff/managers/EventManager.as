package com.jeff.managers
{
	import flash.events.IEventDispatcher;
	
	public class EventManager
	{
		private var _listeners:Vector.<Listener>;
		
		public function EventManager()
		{
			_listeners=new Vector.<Listener>();
		}
		
		public function addEventListener($target:IEventDispatcher,$eventType:String,$callback:Function):void
		{
			$target.addEventListener($eventType,$callback);
			_listeners.push(new Listener($target,$eventType,$callback));
		}
		
		public function removeEventListener($target:IEventDispatcher,$eventType:String,$callback:Function):void
		{
			$target.removeEventListener($eventType,$callback);
			for(var i:int=0;i<_listeners.length;i++)
			{
				if(_listeners[i].target==$target && _listeners[i].eventType==$eventType && _listeners[i].callback==$callback)
				{
					_listeners.splice(i,1);
					break;
				}
			}
		}
		
		public function removeAllListener():void
		{
			for(var i:int=_listeners.length-1;i>=0;i--)
			{
				_listeners[i].target.removeEventListener(_listeners[i].eventType,_listeners[i].callback);
			}
			_listeners.length=0;
		}
	}
}
import flash.events.IEventDispatcher;

class Listener
{
	public var target:IEventDispatcher;
	public var eventType:String;
	public var callback:Function;
	
	public function Listener($target:IEventDispatcher,$eventType:String,$callback:Function)
	{
		target=$target;
		eventType=$eventType;
		callback=$callback;
	}
}