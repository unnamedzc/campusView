package com.jeff.views.UI
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	public class PlayerHealthBar extends UIElement
	{
		private var bar:MovieClip;
		public var actionMC:MovieClip;
		private var barFullSize:Number;
		private var _freezeMC:MovieClip;
		private static const HEALTH_DURATION:Number = 0.5;
		
		public function PlayerHealthBar(className:String)
		{
			super(className);
		}
		
		protected override function init():void
		{
			super.init();
			bar = _bg["mcHealthPanel"]["mcBar"];
			actionMC = _bg["action_mc"];
			_freezeMC= _bg["action_mc"]["freeze"];
			actionMC.gotoAndStop(1);
			barFullSize = bar.width;
		}
		
		// value range from 0 to 1
		public function setValue(value:Number):void
		{
			value = value < 0 ? 0 : value; 
			TweenLite.to(bar, HEALTH_DURATION, {width: value * barFullSize});
		}
		
		public function cannonFreeze():void
		{
			_freezeMC.gotoAndPlay(2);
		}
		
	}
}