package com.jeff.util
{
	import alternativa.engine3d.core.Object3D;
	
	import flash.geom.Vector3D;
	
	public class DemoMath
	{
		public static function distanceXYZ(point1:Vector3D, point2:Vector3D):Number
		{
			var result:Number = Math.sqrt(Math.pow((point1.x - point2.x), 2) + Math.pow((point1.y - point2.y), 2) + Math.pow((point1.z - point2.z), 2));
			return result;
		}
		
		public static function distanceXY(point1:Vector3D, point2:Vector3D):Number
		{
			var result:Number = Math.sqrt(Math.pow(point2.y - point1.y, 2) + Math.pow(point2.x - point1.x, 2));
			return result;
		}
		
		public static function vectorXYLength(point:Vector3D):Number
		{
			return Math.sqrt(Math.pow(point.x, 2) + Math.pow(point.y, 2));
		}
		
		public static function directVector(beginPoint:Vector3D, endPoint:Vector3D):Vector3D
		{
			var directVector:Vector3D = new Vector3D((endPoint.x - beginPoint.x), (endPoint.y - beginPoint.y), (endPoint.z - beginPoint.z));
			return directVector;
		}
		
		public static function calculateRotationZ(beginPoint:Vector3D, endPoint:Vector3D):Number
		{
			var distance:Number = distanceXY(beginPoint, endPoint);
			var result:Number = Math.acos( (endPoint.x - beginPoint.x) / distance );
			if (endPoint.y - beginPoint.y < 0)
				result *= -1;
			return result;
		}
		
		public static function calculateRoataionZByV(vector:Vector3D):Number
		{
			var distance:Number = vector.length;
			var result:Number = Math.acos(vector.x / distance);
			if (vector.y < 0)
				result *= -1;
			return result;
		}
		
		public static function getVector(angle:Number):Vector3D
		{
			return new Vector3D(Math.cos(angle), Math.sin(angle), 0);
		}
		
		public static function calIntervalAngle(beginPoint:Vector3D, endPoint:Vector3D):Number
		{
			var dotMultiply:Number = (beginPoint.x * endPoint.x + beginPoint.y * endPoint.y) / (vectorXYLength(beginPoint) * vectorXYLength(endPoint));
			var result:Number = Math.acos(dotMultiply);
			return result;
		}
		
		// all range from [0, 2PI)
		public static function normalizeDegree(degree:Number):Number
		{
			var result:Number = degree;
			if (degree >= Math.PI * 2)
			{
				for (; result < 0 || result >= (Math.PI * 2); )
					result -= Math.PI * 2;
			}
			else if (degree <= Math.PI * (-2))
			{
				for (; result < 0 || result >= (Math.PI * 2); )
					result += Math.PI * 2;
			}
			else if (degree < 0 && degree > (Math.PI * -2))
			{
				result = (Math.PI * 2) + degree;
			}
			return result;
		}
		
		public static function radianToDegree(radian:Number):uint
		{
			var _radian:Number=radian*180/Math.PI;
			_radian=_radian%360
			if(_radian<0)
			{
				_radian=360+_radian
			}
			return uint(_radian);
		}
		
		public static function rotationZofVector(vector3D:Vector3D):Number
		{
			var distance:Number = vectorXYLength(vector3D);
			var result:Number = Math.acos(Math.abs(vector3D.y )/ distance);
			if(vector3D.x>=0&&vector3D.y>=0)
			{
				result=Math.PI-result;
			}
			else if(vector3D.x<=0&&vector3D.y>=0)
			{
				result=Math.PI+result;
			}
			else if(vector3D.x<=0&&vector3D.y<=0)
			{
				result=2*Math.PI-result;
			}	
			return result;
		}
	
	}
}