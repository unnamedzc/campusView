package com.jeff.object
{
	import com.jeff.managers.characterManager.PlayerManager;
	
	import flash.geom.Vector3D;
	
	public class PlayerObject extends FightObject
	{			
		public var rotationZ:Number;
		public var weaponAndState:String="";
		public var jumpSpeed:Number=0;
		public var fallSpeed:Number=0;
		public var attackDistance:int=0;
		public var attackAngle:int=0;
		public var attackHeigh:int=0;
		
		public function PlayerObject()
		{
			super();
			init();
		}	
		private function init():void
		{
			this.x=23546;
			this.y=3411;
			this.z=70;
			this.moveSpeed=20;
			this.rotationZ=-8.046;
			this.currentHp=300;
			this.jumpSpeed=GlobalValue.JUMP_START_SPEED;
			this.attackDistance = PlayerManager.ATTACK_DISTANCE;
			this.attackAngle = PlayerManager.ATTACK_FAN_RANGE;
			this.attackHeigh = PlayerManager.ATTACK_HEIGHT_RANGE;
		}
		
		public function get location():Vector3D
		{
			return new Vector3D(this.x, this.y, this.z);
		}
		
		public function get displacment():Vector3D
		{
			return new Vector3D(this.vx,this.vy,this.vz);
		}
	}
}