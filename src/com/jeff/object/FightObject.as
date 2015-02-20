package com.jeff.object
{
	public class FightObject
	{
		public var currentHp:int;//当前血量.
		public var maxHp:uint;//最大血量.
		public var attackValue:uint=100;//攻击值.
		public var x:Number=0;//x轴.
		public var y:Number=0;//y轴.
		public var z:Number=0;//z轴.
		public var vx:Number=0;//x轴向量.
		public var vy:Number=0;//y轴向量.
		public var vz:Number=0;//z轴向量.
		public var moveSpeed:Number=0;//移动速度.
		public var isDead:Boolean;//是否死亡.
		
		public function FightObject()
		{
		}
	}
}