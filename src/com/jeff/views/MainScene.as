package com.jeff.views
{
	import alternativa.engine3d.core.Object3D;
	
	import com.jeff.views.Scene3D;
	import com.jeff.views.UI.UILayer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.SimpleButton;
	public class MainScene
	{
		private static var _instance:MainScene;
		/**3D可视对象根容器**/
		private var _scene3DContainer:Object3D;
		public var scene3D:Scene3D;
		private var _scene2D:UILayer;
		
		public static function getInstance():MainScene
		{
			if (null == _instance)
				_instance = new MainScene();
			return _instance;
		}
		
		public function init():void
		{
			_scene3DContainer=new Object3D();
			scene3D=new Scene3D();
			_scene2D = new UILayer();
			GlobalValue.stage.addChild(_scene2D);
		}
		
		
		public function get scene3DContainer():Object3D
		{
			return _scene3DContainer;
		}
		
		public function get scene2D():UILayer
		{
			return _scene2D;
		}
		
		public function render():void
		{
			scene3D.update();
		}
		
		public function popup():void
		{
			if (!_scene2D.popupUI.visible)
			{
				Mouse.show();
				_scene2D.popupUI.visible=true;
				_scene2D.popupUI.popupContent.gotoAndPlay("show");			
				_scene2D.popupUI.restartButton.addEventListener(MouseEvent.CLICK,resetGame);
				GlobalValue.gm.playerManager.destroy();
			}
		}
		
		private function resetGame(event:MouseEvent):void
		{
			_scene2D.popupUI.restartButton.removeEventListener(MouseEvent.CLICK,resetGame);
			_scene2D.popupUI.visible=false;
			GlobalValue.gm.reset();
			GlobalValue.gameOver = false;
			//Mouse.hide();
		}
	
	}
}