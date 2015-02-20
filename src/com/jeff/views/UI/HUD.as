package com.jeff.views.UI 
{
	public class HUD extends UIElement
	{
		public static const HUD_DIR_UP:int = 0;
		public static const HUD_DIR_DOWN:int = 1;
		public static const HUD_DIR_LEFT:int = 2;
		public static const HUD_DIR_RIGHT:int =3;
		public static const HUD_DIR_LEFT_DOWN:int =4;
		public static const HUD_DIR_CENTER:int =5;
		
		protected var _direction:int = HUD_DIR_UP;
		protected var _margin:Number = 0;
		
		public function HUD(className:String)
		{
			super(className);
		}
		
		public function get direction():int
		{
			return _direction;
		}
		
		public function get margin():Number
		{
			return _margin;
		}
		
	}
}