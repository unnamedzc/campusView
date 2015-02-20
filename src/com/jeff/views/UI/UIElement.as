package com.jeff.views.UI
{
	import com.jeff.managers.EventManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	public class UIElement extends Sprite
	{
		private var _className:String;
		protected var _bg:DisplayObject;
		protected var _em:EventManager = new EventManager();
		
		public function UIElement(className:String)
		{
			this._className = className;
			super();	
			init();
		}
		
		protected function init():void
		{
			var define:Class = ApplicationDomain.currentDomain.getDefinition(_className) as Class;
			if (define)
			{
				_bg = new define();
				addChild(_bg);
			}
		}
	}
}