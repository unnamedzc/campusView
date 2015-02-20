package com.virtuos.views.UI.UI3D
{
	import alternativa.engine3d.objects.Sprite3D;
	
	import com.virtuos.object.EnemyObject;
	import com.virtuos.util.DemoMath;
	import com.virtuos.views.UI.UIElement;
	
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	public class ReticuleOnEnemy extends UIElement
	{
		private var _cross:Sprite3D;
		private var sprite3DTool:Sprite3DTool;
		private var _cameraPosition:Vector3D;
		private var _crossPosition:Vector3D;
		private var _distanceToCamera:Number=0;

		public function ReticuleOnEnemy(className:String)
		{
			super(className);
		}
		
		public function get cross():Sprite3D
		{
			return _cross;
		}

		public function set cross(value:Sprite3D):void
		{
			_cross = value;
		}

		protected override function init():void
		{
			super.init();
			var cross:Sprite=Sprite(_bg);
			sprite3DTool=new Sprite3DTool(cross);
			_cross=Sprite3D(sprite3DTool.createImage());
			GlobalValue.mainScene.scene3DContainer.addChild(_cross);
			_cross.visible=false;
		}	
		public function showOnEnemy(enemy:EnemyObject):void
		{
			if(enemy!=null)
			{
				_cross.visible=true;
				_crossPosition=new Vector3D(enemy.x,enemy.y,enemy.z+125);
				_cross.x=_crossPosition.x;
				_cross.y=_crossPosition.y;
				_cross.z=_crossPosition.z;
				_cameraPosition=new Vector3D(GlobalValue.camera.x,GlobalValue.camera.y,GlobalValue.camera.z);
				_distanceToCamera = DemoMath.distanceXYZ(_cameraPosition,_crossPosition);
				_cross.scaleX=_cross.scaleY=_cross.scaleZ=1+(_distanceToCamera*GlobalValue.CROSS_ZOOM_RATE)
				_cross.alwaysOnTop=true;
			}
		}
	}
}