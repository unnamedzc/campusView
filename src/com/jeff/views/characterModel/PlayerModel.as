package com.jeff.views.characterModel
{
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.animation.AnimationNotify;
	import alternativa.engine3d.animation.events.NotifyEvent;
	import alternativa.engine3d.objects.Skin;
	
	import com.jeff.events.PlayerStateEvent;
	import com.jeff.managers.EventManager;
	import com.jeff.managers.ResourceManager;
	import com.jeff.managers.characterManager.PlayerManager;
	import com.jeff.object.PlayerObject;
	
	import flash.geom.Vector3D;
	
	public class PlayerModel extends BaseModel
	{
		private var _playerModel:Skin; //人物
		private var _sword:Skin; //攻击
		private var _buster:Skin;
		private var _cannon:Skin;
		private var _idle:AnimationClip;//动作片段：左右张
		private var _run:AnimationClip;//动作片段：跑

		
		private var _playerObject:PlayerObject;
		private var _em:EventManager;		
		private var _previouseAnimation:Object;
		private var _initAnimationName:Object=new Object();
		private var _haveAddedAnimation:Object=new Object();
		
		public function PlayerModel(location:Vector3D)
		{
			super(location);
			init();
		}
		
		override protected function init():void
		{
			super.init();						
			_playerModel=ResourceManager.getInstance().skin["Male_idle"];
			//_playerModel.divide(11);
			_playerModel.mouseEnabled = false;
			_characterContainer.mouseChildren=_characterContainer.mouseEnabled=false;
			//_playerModel.rotationX=Math.PI/2;
			_characterContainer.addChild(_playerModel);
				
			_playerObject=GlobalValue.gm.playerManager.playerObject;
			initPreLoadAnimation();
			_animationSwitcher.addAnimation(_idle);
			_animationSwitcher.addAnimation(_run);
			_animationSwitcher.activate(_idle);
			//_animationSwitcher_weapon.speed=_animationSwitcher.speed = GlobalValue.TIME_SCALE;	
			_animationController.root = _animationSwitcher;	
			//_animationController_weapon.root = _animationSwitcher_weapon;	
			_em=new EventManager();
			_em.addEventListener(GlobalValue.gm.playerManager,PlayerStateEvent.PLAYER_STATE_CHANGE,onStateChange);
		}
		
		public function initPreLoadAnimation():void
		{
			var length:int=ResourceManager.getInstance().preLoadAnimation.length;
			var modelName:String="";
			var characterName:String="";
			var weapon:String="";
			var state:String="";
			for(var i:int=0;i<length;i++)
			{
				 modelName=ResourceManager.getInstance().preLoadAnimation[i];
				 characterName=modelName.substring(0,modelName.indexOf("_"));
				 if(characterName=="Male")
				 {
					 modelName=modelName.slice(modelName.indexOf("_")+1);
					 weapon=modelName.substring(0,modelName.indexOf("_"));
					 weapon=weapon.toLocaleLowerCase();
					 state=modelName.slice(modelName.indexOf("_")+1);
					 state=state.toLocaleLowerCase();
					 initializeAnimation(weapon,state);
					 _initAnimationName["_"+weapon+"_"+state+"_body"]=String("_"+weapon+"_"+state+"_body");
					 _initAnimationName["_"+weapon+"_"+state+"_weapon"]=String("_"+weapon+"_"+state+"_"+weapon);
				 }
			}
			ResourceManager.getInstance().preLoadAnimation=[];
		}
		//mutil-thread here
		private function onStateChange(e:PlayerStateEvent):void
		{
			//trace(e.data);
			var data:String=e.data;
			//var weapon:String=data.substring(0,data.indexOf("_"));
			var state:String=data.substring(data.indexOf("_")+1);
			switchAnimation(state);
			
		}
	
		private function parseData(data:String):String
		{
 			var str:String = data;
			var arr:Array = str.split("_");
			var arr2:Array = [];
			
			for (var i:* in arr){
				var a:String = (arr[i] as String).substr(0,1).toLocaleUpperCase();
				var b:String = (arr[i] as String).substr(1,arr[i].length-1);
				arr2.push(a+b)
			}
			str = arr2.join("_");
			return str;
		}		
		
		private function initializeAnimation(weapon:String,state:String):void
		{
			switch (state)
			{
				case PlayerManager.IDLE:					
					
						//trace(ResourceManager.getInstance().animation["Male_walk"][0]);
						var t1:AnimationClip = ResourceManager.getInstance().animation["Male_idle"];
						_idle = t1.slice(0, 0);
						_run=t1.slice(1/33,1);
					
					break;
			}
		}

		
		private function switchAnimation(data:String):void
		{
			if(data=="idle"){_animationSwitcher.activate(_idle,.1);}
			else{_animationSwitcher.activate(_run,0);}			
		}
		
		override public function update():void
		{
			super.update();
			positionUpdate();
		}
		
		private function positionUpdate():void
		{
			this._characterContainer.x=_playerObject.x;
			this._characterContainer.y=_playerObject.y;
			this._characterContainer.z=_playerObject.z;
			this._characterContainer.rotationZ=_playerObject.rotationZ;
		}
		
		public function destroy():void
		{
			_em.removeAllListener();
			_em = null;
		}
	}
}