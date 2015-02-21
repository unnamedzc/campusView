package com.jeff.views.level
{
	import com.jeff.managers.ResourceManager;
	
	import flash.utils.Dictionary;
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	public class Terrain
	{
		private var _rootContainer:Object3D;
		private var _bulid:Object=new Object();
		private var _shadowTerrain:Object3D;
		private var _collisionTerrain:Object3D;
		private var _excludedBuilds:Dictionary=new Dictionary;
		
		public function Terrain()
		{
			init();
			//_rootContainer.z=-150;
			//_rootContainer.x=-200
			//_rootContainer.y=6000;
		}

		

		public function get collisionTerrain():Object3D
		{
			return _collisionTerrain;
		}
		public function get shadowTerrain():Object3D
		{
			return _shadowTerrain;
		}
		
		
		
		private function uploadResources(resources:Vector.<Resource>):void {
			for each (var resource:Resource in resources) {
				resource.upload(GlobalValue.stage3D.context3D);
			}
		}		

		private function init():void
		{
			_rootContainer=new Object3D();	
			_collisionTerrain=new Object3D();
			GlobalValue.mainScene.scene3DContainer.addChild(_rootContainer);
			_rootContainer.addChild(_collisionTerrain);
			_shadowTerrain=new Object3D();
			_rootContainer.addChild(_shadowTerrain);	
			_rootContainer.mouseChildren=false;
			_rootContainer.mouseEnabled=false;	
			
			//test
			
			///================================
			_bulid["Ground"]=Mesh(ResourceManager.getInstance().model["Ground"]["Build"]);
			shadowTerrain.addChild(_bulid["Ground"]);
			
			_bulid["Build0"]=Mesh(ResourceManager.getInstance().model["Terrain"]["Build"]);
			//_bulid["Build0"].scaleX=_bulid["Build0"].scaleY=_bulid["Build0"].scaleZ=0.8;
			_rootContainer.addChild(_bulid["Build0"]);
			var length:int=ResourceManager.getInstance().model["Terrain"]["length"];
			var meshName:String="";
			for(var i:int= 1;i<length;i++)
			{
				meshName=Mesh(ResourceManager.getInstance().model["Terrain"]["Build"+i]).name;
				_bulid[meshName]=Mesh(ResourceManager.getInstance().model["Terrain"]["Build"+i]);
				
				
				//follows add to collisionContainer				
				if(meshName.indexOf("Collision")!=-1)
				{
					_collisionTerrain.addChild(_bulid[meshName]);
				}
				//follows add to shadow caster
				else if(meshName.indexOf("Tree")!=-1
						//||meshName.indexOf("Building")!=-1										
					)
				{
					_rootContainer.addChild(_bulid[meshName]);
				}
				//follows add to bullet collision container
				
				else
				{
					_rootContainer.addChild(_bulid[meshName]);
				}
			}
		}
	}
}