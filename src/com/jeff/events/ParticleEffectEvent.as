package com.jeff.events
{
	public class ParticleEffectEvent extends BaseEvent
	{
		public static const CANNON_FIRE:String="cannon_fire";
		
		public function ParticleEffectEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, $data, bubbles, cancelable);
		}
	}
}