package com.jeff.views.characterModel
{
	import alternativa.engine3d.animation.AnimationController;
	import alternativa.engine3d.animation.AnimationSwitcher;
	import alternativa.engine3d.collisions.EllipsoidCollider;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.shadows.DirectionalLightShadow;
	
	import com.jeff.managers.ResourceManager;
	import com.jeff.views.level.Terrain;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;

//	import flash.net.URLRequest;
	
	public class BaseModel
	{	
		public var _characterContainer:Object3D;
		protected var _animationController:AnimationController
		protected var _animationController_weapon:AnimationController
		protected var _animationSwitcher:AnimationSwitcher
		protected var _animationSwitcher_weapon:AnimationSwitcher
		protected var _location:Vector3D=new Vector3D();
		protected  var _collider:EllipsoidCollider;
//		protected var _shadow:Plane;
		private var terrain:Terrain
		protected var _tex_D:BitmapTextureResource
		protected var _tex_O:BitmapTextureResource
//		protected var shadow:DirectionalLightShadow = new DirectionalLightShadow(500, 500, -500, 500, 2048,1);
		
//		protected var directionalLight:DirectionalLight = new DirectionalLight(0x111111);
		public function BaseModel(location:Vector3D)
		{
			_location=location;
		}
		
		protected function init():void
		{
			
			_characterContainer=new Object3D();
			_characterContainer.mouseChildren=false;
			_characterContainer.mouseEnabled=false;
			GlobalValue.mainScene.scene3DContainer.addChild(_characterContainer);
			_animationController=new AnimationController();
			_animationController_weapon=new AnimationController();
			_animationSwitcher=new AnimationSwitcher();
			_animationSwitcher_weapon=new AnimationSwitcher();
			_collider = new EllipsoidCollider(50, 50, 90);
			_characterContainer.x=_location.x;
			_characterContainer.y=_location.y;
			_characterContainer.z=_location.z;
			_characterContainer.mouseChildren = false;
			_characterContainer.mouseEnabled = false;
			
			//_characterContainer.addEventListener(Event.INIT,added)
			//	function added(e:Event):void{
					//trace("this is :",this);
//					directionalLight.z=100;
//					directionalLight.lookAt(0, 0, 0);
//					_characterContainer.addChild(directionalLight);	
//					shadow.addCaster(_characterContainer);					
//					shadow.addCaster(Terrain.staticObj);	
//					directionalLight.shadow = shadow;
					
			//	}
			//_shadow=ResourceManager.getInstance().skin["Rex_Sword_Activition"]["Sword"];
			//
//			var loaderMat:Loader = new Loader();
//			var loaderMat2:Loader = new Loader();
			//shadow
			
		/*	var _diffuse:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0x7F7FFF));
			var _normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0x7F7FFF));
			var baseMaterial:StandardMaterial = new StandardMaterial(_diffuse, _normal);
			
				
			shadow.biasMultiplier = 0.97;			
			_shadow=new Plane(128,128,1,1,true,false,null,null);
			_shadow.z=1;
			_shadow.setMaterialToAllSurfaces(baseMaterial);
			_characterContainer.addChild(_shadow);
			shadow.addCaster(_shadow);	
			*/
			
			//trace(_characterContainer)
//			loaderMat.load(new URLRequest("assets/shadow_D.jpg"));			
//			loaderMat.contentLoaderInfo.addEventListener(Event.COMPLETE, onMatLoad);
//			loaderMat2.load(new URLRequest("assets/shadow_o.jpg"));			
//			loaderMat2.contentLoaderInfo.addEventListener(Event.COMPLETE, onMatLoad2);
		}
		/*protected function onMatLoad2(e:Event):void{
			_tex_O=new BitmapTextureResource(e.target.content.bitmapData)
				if(_tex_D!=null){
//			_shadow=new Plane(128,128,1,1,true,false,null,new TextureMaterial(_tex_D,_tex_O,1));
//			_shadow.z=1;
//			_characterContainer.addChild(_shadow);
			for each(var resource:Resource in _characterContainer.getResources(true)){
				resource.upload(GlobalValue.stage3D.context3D);
			}
				}
		}
		protected function onMatLoad(e:Event):void{
			_tex_D=new BitmapTextureResource(e.target.content.bitmapData)
			if(_tex_O!=null){
//			_shadow=new Plane(128,128,1,1,true,false,null,new TextureMaterial(_tex_D,_tex_O,1));
//			_shadow.z=1;
//			_characterContainer.addChild(_shadow);
			for each(var resource:Resource in _characterContainer.getResources(true)){
				resource.upload(GlobalValue.stage3D.context3D);
			}
			}
		}*/
		protected function animationSwitcher(animationName:String):void	
		{
			
		}
		
		public function update():void
		{	
			_animationController.update();
			_animationController_weapon.update();
		}
		
		public function get ellipsoidCollider():EllipsoidCollider
		{
			return this._collider;
		}
		
		public function set ellipsoidCollider(collider:EllipsoidCollider):void
		{
			_collider=collider;
		}
	}
}