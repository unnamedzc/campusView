package com.jeff.util
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.objects.WireFrame;
	
	import com.virtuos.object.EnemyObject;
	import com.virtuos.views.MainScene;
	
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	public class AxisAndGrid
	{
		private var rootContainer:Object3D;
		private var _enemy:EnemyObject;
		private const gridDistance:Number=100;
		private const girdNumberXHalf:Number=80;
		private const girdNumberYHalf:Number=80;
		
	public function AxisAndGrid()
		{
			this.rootContainer=new Object3D;
			GlobalValue.mainScene.scene3DContainer.addChild(rootContainer);
/*			makeAxes();
			makeGrid();*/
			enemyIndication();
		}	
		
		/**
		 * 绘制坐标轴
		 * X轴为红色；
		 * Y轴为绿色；
		 * Z轴为蓝色；
		 * */
		 
		private function makeAxes():void {
			var axisX:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(0, 0, 10), new Vector3D(300, 0, 10), new Vector3D(300, 0, 10),new Vector3D(280, 10, 10),new Vector3D(300, 0, 10),new Vector3D(280, -10, 10) ]), 0xff0000,1, 5);
			var axisY:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(0, 0, 10), new Vector3D(0, 300, 10), new Vector3D(0, 300, 10),new Vector3D(0, 280, 20),new Vector3D(0, 300, 10),new Vector3D(0, 280, 0) ]), 0x00ff00,1, 5);
			var axisZ:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(0, 0, 10), new Vector3D(0, 0, 310), new Vector3D(0, 0, 310),new Vector3D(10, 0, 290),new Vector3D(0, 0, 310),new Vector3D(-10, 0, 290) ]), 0x0000ff,1, 5);
			rootContainer.addChild(axisX);
			rootContainer.addChild(axisY);
			rootContainer.addChild(axisZ);
		}
		
		private function makeGrid():void
		{
			for(var i:int=-girdNumberXHalf;i<=girdNumberXHalf;i++)
			{
				var gridX:WireFrame=WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(gridDistance * i,gridDistance * girdNumberYHalf,50),new Vector3D(gridDistance * i,gridDistance * (-girdNumberYHalf),50)]),0x00ff00,1,3)
				rootContainer.addChild(gridX);
			}
			for(var j:int=-girdNumberYHalf;j<=girdNumberYHalf;j++)
			{
				var gridyY:WireFrame=WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(gridDistance * girdNumberXHalf,gridDistance * j,50),new Vector3D(gridDistance *  (-girdNumberXHalf),gridDistance * j ,50)]),0xff0000,1,3)
				rootContainer.addChild(gridyY);
			}		
		}	
		
		private function enemyIndication():void
		{
			var _indication:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>(
				[new Vector3D(0, 0, 350), new Vector3D(0, 0, 250), new Vector3D(0, 0, 245),new Vector3D(30, 0, 310),new Vector3D(0, 0, 245),new Vector3D(-30, 0, 310) ]), 0xfff000,1,8);
			rootContainer.addChild(_indication);	
		}
		
		public function update():void
		{
			_enemy=GlobalValue.gm.enemyManager.beAttackedEnemy;
			if(_enemy!=null)
			{
				rootContainer.visible=true;
				rootContainer.x=_enemy.x;
				rootContainer.y=_enemy.y;
				rootContainer.z=_enemy.z;
			}
			else
			{
				rootContainer.visible=false;
			}
		}
	}
}