package com.jeff.managers 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Skin;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	
	public class ResourceManager extends EventDispatcher
	{     
		private static var _instance:ResourceManager;
		public static var resourceXML:String = "xml/modelResource.xml";
		public static var loadOver:String= "loadOver";
		public static const NO_MODEL_FILE:String= "There is no dae file in this model.";
		
		private var _modelName:String="";
		private var _materialName:String="";
		private var _materExterName:String = "";
		private var _modelURL:String="";
		private var _parserType:String=""
		
		private var _xmlData:XML;
		private var _loaderXML:URLLoader;
		
		private var modelNumber:uint;
		private var modelIndex:uint;
		private var parserNumber:uint;
		private var parserIndex:uint;
		private var materialNumber:uint;
		private var materialIndex:uint;
		
		private var _material:Object=new Object();//材质�
		private var materialNameArray:Array;
		private var materialExterNameArray:Array = [];
		public var parser:Object=new Object(); //模型解析�
		public var model:Object = new Object();//模型容器
		public var skin:Object=new Object(); //skin模型�   
		public var animation:Object=new Object(); //animation�
		public var preLoadAnimation:Array=new Array();
		private var animationData:Array = new Array();
		
		private var loadParser:Boolean;
		private var _parserData:Object=new Object();
		private var loadMaterial:Boolean;
		private var m_loadinfo:LoaderInfo;
		private var btr:BitmapTextureResource;
		private var totalSize:int;
		public static var loadProgress:int=0;
		private var haveLoadSize:int;
		
		private var start:Number
		private var _animationLoad:Boolean;
		private var _animationIndex:int;
		private var _diffusePath:String = "";
		private var _normalPath:String = "";
		private var _specularPath:String = "";
		private  var _standardMaterial:StandardMaterial;
		private var _urlXML:String = "";
		private var loaderCollada:URLStream;
		private var loaderMatStream:URLStream;
		
		
		public function ResourceManager(){}
		
		private function progressEvent(e:ProgressEvent):void 
		{     
			loadProgress=int(103*(haveLoadSize)/totalSize);
			(GlobalValue.root as CampusTour).setProg(loadProgress);
		}
		
		public static function getInstance():ResourceManager
		{
			if(!_instance)
				_instance=new ResourceManager();
			return _instance;
		}
		
		public function load(url:String):void
		{
			_urlXML = url;
			_loaderXML = new URLLoader();
			_loaderXML.load(new URLRequest(_urlXML));
			_loaderXML.addEventListener(Event.COMPLETE, onXMLLoad);
		}
		
		private function onXMLLoad(event:Event):void
		{
			_loaderXML.removeEventListener(Event.COMPLETE, onXMLLoad);
			var xmlData:XML = XML(event.target.data);
			setXMLData(xmlData);
		}
		
		public function setXMLData(xmlData:XML):void
		{
			start=getTimer();
			_xmlData=xmlData;
			for(var i:int =0;i<_xmlData.*.*.@size.length();i++)
			{
				totalSize+=int(_xmlData.*.*.@size[i]);    
			}
			modelNumber= _xmlData.model.length();
			modelIndex=0;
			if(modelNumber>0){
				loadLoop()
				this.addEventListener(ProgressEvent.PROGRESS,progressEvent);
			}
			else
			{
				if (_urlXML == resourceXML) this.dispatchEvent(new Event(loadOver));
				
				//if (_urlXML == enemyXML) this.dispatchEvent(new Event(loadEnemyOver));
			}
		}
		
		private function loadLoop():void
		{
			parserNumber=_xmlData.model[modelIndex].textFile.length();
			if(parserNumber>0)
			{
				parserLoad();
			}
			else
			{
				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,ResourceManager.NO_MODEL_FILE));
				materialIndex=0;
				materialNumber=_xmlData.model[modelIndex].imageFile.length();
				if(materialNumber>0)
				{
					materialNameArray=new Array();
					materialLoad();
				}
			}                 
		}
		
		/**加载模型文件*/
		private function parserLoad():void 
		{                       
			loadParser=true;
			loaderCollada = new URLStream();
			_modelName=_xmlData.model[modelIndex].textFile[0].@name;
			_modelURL=_xmlData.model[modelIndex].textFile[0].@src;      
			loaderCollada.load(new URLRequest(_modelURL));
			initLoadEvent(loaderCollada); 
			this.addEventListener(Event.COMPLETE, onParserLoad);
		}                 
		
		/**模型文件加载完成*/
		private function onParserLoad(event:Event):void
		{
			loadParser=false;
			this.removeEventListener(Event.COMPLETE, onParserLoad);
			haveLoadSize+=int(_xmlData.model[modelIndex].textFile[0].@size);
			_parserType=_modelURL.slice(_modelURL.lastIndexOf(".")+1);
			materialNumber=_xmlData.model[modelIndex].imageFile.length();
			if(_xmlData.model[modelIndex].textFile.@animation == "0")
			{
				if (materialNumber == 0)
				{
					animationParser(_modelName);
					onParserComplete();
				}
				else
				{
/*					parser= new ParserCollada();
					parser.parse(XML(_parserData[_modelName]));*/
					switch(_parserType)
					{
						case "DAE":
						case "dae":
							parser= new ParserCollada();
							parser.parse(XML(_parserData[_modelName]));
							break;
						case "A3D":
						case "a3d":
							parser= new ParserA3D();
							parser.parse(_parserData[_modelName]);
							break;
						default:
							break;
					}
					materialIndex=0;
					materialNameArray=new Array();
					materialLoad();
				}
			}
			else
			{
				animationData.push(_modelName);
				onParserComplete();
			}
			
		}
		
		/**加载材质文件*/
		private function materialLoad():void 
		{
			if (_xmlData.model[modelIndex].imageFile[materialIndex].@ext == "1")
			{
				loadExternalTextureResource();
			}
			else
			{
				loadEntrailsResource();
			}
		}
		
		/**
		 * 加载内部资源.
		 */		
		private function loadEntrailsResource():void
		{
			//加载材质
			loadMaterial=true;
			loaderMatStream = new URLStream();
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;            
			_materialName=_xmlData.model[modelIndex].imageFile[materialIndex].@name;
			materialNameArray.push(_materialName);
			if(_material[_materialName]||_xmlData.model[modelIndex].imageFile[materialIndex].@src=="")
			{
				loadMaterial=false;
				haveLoadSize+=int(_xmlData.model[modelIndex].imageFile[materialIndex].@size);
				materialIndex++;
				if(materialIndex<materialNumber)
				{
					materialLoad();   
				}
				else
				{
					paserAnalyse();
				}
			}
			else
			{
				loaderMatStream.load(new URLRequest(_xmlData.model[modelIndex].imageFile[materialIndex].@src));
				loaderMatStream.addEventListener(Event.COMPLETE, loaderMatStreamHandler);
			}
		}
		
		private function loaderMatStreamHandler(e:Event):void
		{
			loaderMatStream.removeEventListener(Event.COMPLETE, loaderMatStreamHandler)
			//写入数据.
			var __byte:ByteArray = new ByteArray();
			this.loaderMatStream.readBytes(__byte, 0, this.loaderMatStream.bytesAvailable);
			
			//加载数据.
			var loaderMat:Loader = new Loader();
			initLoadEvent(loaderMat.contentLoaderInfo);     
			loaderMat.loadBytes(__byte);
			this.addEventListener(Event.COMPLETE, onMaterialLoad);
		}
		
		/**
		 * 加载外部资源.
		 */		
		private function loadExternalTextureResource():void
		{
			_materialName=_xmlData.model[modelIndex].imageFile[materialIndex].@name;
			_diffusePath=_xmlData.model[modelIndex].imageFile[materialIndex].@diffuseSrc;
			_normalPath = _xmlData.model[modelIndex].imageFile[materialIndex].@normalSrc;
			_specularPath = _xmlData.model[modelIndex].imageFile[materialIndex].@specularSrc;
			
			materialNameArray.push(_materialName);
			var fileTexture:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();		
			var _diffuse:ExternalTextureResource = new ExternalTextureResource(_diffusePath);	
			fileTexture.push (_diffuse);
			var textureLoader:TexturesLoader = new TexturesLoader(GlobalValue.context3D);
			textureLoader.loadResources(fileTexture, true, false);
			haveLoadSize+=int(_xmlData.model[modelIndex].imageFile[materialIndex].@size);
			if(GlobalValue.displayQuality==GlobalValue.HIGH_QUALITY)
			{
				var _normal:ExternalTextureResource = new ExternalTextureResource(_normalPath);
				var _specular:ExternalTextureResource = new ExternalTextureResource(_specularPath);
				fileTexture.push (_normal);
				fileTexture.push (_specular);
				_material[_materialName]= new StandardMaterial(_diffuse,_normal, _specular, null, null);
			}
			else
			{
				_material[_materialName] = new TextureMaterial(_diffuse);
			}
			materialIndex++
			if(materialIndex<materialNumber)
			{
				materialLoad();   
			}
			else 
			{
				paserAnalyse();
			}
		}
		
		/**材质文件加载完成*/
		private function onMaterialLoad(event:Event):void
		{
			loadMaterial=false;
			this.removeEventListener(Event.COMPLETE, onMaterialLoad);
			haveLoadSize+=int(_xmlData.model[modelIndex].imageFile[materialIndex].@size);
			_material[_materialName]= new TextureMaterial(btr);
			materialIndex++
			if(materialIndex<materialNumber)
			{
				materialLoad();   
			}
			else 
			{
				paserAnalyse();
			}
		}
		
		/**
		 * 纯动画解析
		 * 
		 * */
		public function animationParser(_modelName:String):void
		{
			preLoadAnimation.push(_modelName);
			parser= new ParserCollada();
			var tempXML:XML = XML(_parserData[_modelName]);
			var beginTime:Number = getTimer();
			parser.parse(tempXML);
			//trace("Parse Time: ", getTimer() - beginTime);
			_animationIndex=0;
			skin[_modelName]={};
			animation[_modelName]={};
			for each(var obj:Object3D in parser.objects)
			{ 
				if(obj is Skin)
				{
					skin[_modelName]=Skin(obj);
					animation[_modelName][_animationIndex]=AnimationClip(parser.getAnimationByObject(obj));
					_animationIndex++;
				}
			}
		}
		
		/**
		 * 解析角色动画.
		 */		
		public function parserCharacterAnimation(obj:Object):Boolean
		{
			if (obj.max >= animationData.length)
			{
				return false;
			}
			else
			{
				var modelName:String = "";
				modelName = animationData[obj.max];
				animationParser(modelName);
				obj.max++;
				return true;
			}	
		}
		
		/**模型文件分析匹配*/
		private function paserAnalyse():void 
		{
			materialIndex=0;
			model[_modelName]={};
			skin[_modelName]={};
			animation[_modelName]={}
			for each(var obj:Object3D in parser.objects)
			{     
				if(obj is Skin)
				{
					preLoadAnimation.push(_modelName);
					if(materialNumber==1)
					{
						skin[_modelName]=Skin(obj);
						// 模型贴图
						skin[_modelName].setMaterialToAllSurfaces(_material[_materialName]);
						animation[_modelName]=AnimationClip(parser.getAnimationByObject(obj));			
						(obj as Skin).setMaterialToAllSurfaces(_material[_materialName]);
						
					}
					else if(materialIndex<materialNumber)
					{
						_materialName=materialNameArray[materialIndex];
						skin[_modelName][_materialName]=Skin(obj);
						// 模型贴图
						skin[_modelName][_materialName].setMaterialToAllSurfaces(_material[_materialName]);
						animation[_modelName][_materialName]=AnimationClip(parser.getAnimationByObject(obj));
						materialIndex++;
					}	
					
				}
				else if(obj is Mesh&&!(obj is Skin)) 
				{			
					model[_modelName]["length"]=materialIndex+1;
					if(materialNumber==1){
						model[_modelName]=Mesh(obj);
						// 模型贴图
						model[_modelName].setMaterialToAllSurfaces(material[_materialName]);
					}
					else 
					{
						_materialName=materialNameArray[materialIndex];
						if(_materialName==null)	_materialName=materialNameArray[0]+materialIndex;
						model[_modelName][_materialName]=Mesh(obj);
						// 模型贴图
							var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();		
							var _normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0x3D5ACC));
							for (var j:int = 0; j < (obj as Mesh).numSurfaces; j++) {
								var surface:Surface = (obj as Mesh).getSurface(j);
								var material:ParserMaterial = surface.material as ParserMaterial;
								var currentDiffuse:ExternalTextureResource=new ExternalTextureResource("");
								if (material != null) {
									var diffuse:ExternalTextureResource = material.textures["diffuse"];
									
									if (diffuse != null) {
										
										currentDiffuse.url = diffuse.url;
										
										currentDiffuse.url=diffuse.url;
										currentDiffuse.url=String(currentDiffuse.url).substring(String(currentDiffuse.url).lastIndexOf("/")+1);
										currentDiffuse.url = "assets/" + currentDiffuse.url;
										currentDiffuse.url =String(currentDiffuse.url).substring(0, String(currentDiffuse.url).lastIndexOf("."))+".jpg";
										
										trace(diffuse.url,currentDiffuse.url);
										textures.push(currentDiffuse);
										
										
										if(diffuse.url.lastIndexOf('Grass_')!=-1
											||diffuse.url.lastIndexOf('Sidewalk_')!=-1
											//||diffuse.url.lastIndexOf('Indoor_')!=-1
											||diffuse.url.lastIndexOf('Ground')!=-1)
										{
											//var _normalLevel:ExternalTextureResource = new ExternalTextureResource("");
											surface.material=new StandardMaterial(currentDiffuse,_normal);
										}else
										{
										
											var currentOpacity:ExternalTextureResource=new ExternalTextureResource("");
											currentOpacity.url=diffuse.url;
											currentOpacity.url=String(currentDiffuse.url).substring(String(currentDiffuse.url).lastIndexOf("/")+1);
											currentOpacity.url = "assets/" + currentDiffuse.url;
											currentOpacity.url =String(currentDiffuse.url).substring(0, String(currentDiffuse.url).lastIndexOf("."))+".jpg";
											currentOpacity.url =String(currentDiffuse.url).replace("_D","_A");
											//textures.push(currentDiffuse);
											textures.push(currentOpacity);
											var texture:TextureMaterial=new TextureMaterial(currentDiffuse,null,.35);
											texture.alphaThreshold=.1;								
											texture.transparentPass=true;
											texture.opaquePass=true;
											surface.material = texture
										}
										//follows add transparency texture 
										
									}
								}else
								{
									currentDiffuse.url = "assets/testNormal/T_MC_church_terrain01_D.jpg";
									var currentNormal:ExternalTextureResource=new ExternalTextureResource("");
									currentNormal.url="assets/testNormal/T_MC_church_terrain01_N.jpg"
									textures.push(currentNormal);
									textures.push(currentDiffuse);
									var s:StandardMaterial=new StandardMaterial(currentDiffuse,currentNormal);
									//model[_modelName].setMaterialToAllSurfaces(s);
									//surface.material=
								}
							}
							var texturesLoader:TexturesLoader = new TexturesLoader(GlobalValue.context3D);
							texturesLoader.loadResources(textures);      
						materialIndex++;
					}                                   
				}                       
			}
			onParserComplete();
		}
		private function onParserComplete():void
		{
			modelIndex++;
			if(modelIndex<modelNumber)
			{
				loadLoop();
			}
			else
			{
				if (_urlXML == resourceXML)
				{
					this.dispatchEvent(new Event(loadOver));
				}
				
				/*if (_urlXML == enemyXML)
				{
					this.dispatchEvent(new Event(loadEnemyOver));
				}*/
				
				this.removeEventListener(ProgressEvent.PROGRESS,progressEvent);
			}
			_animationLoad=false;
			trace((getTimer()-start));
		}
		
		public function getClass(name:String, info:LoaderInfo = null):Class 
		{
			try 
			{
				if (info == null) 
				{
					return ApplicationDomain.currentDomain.getDefinition(name) as Class;
				}
				return info.applicationDomain.getDefinition(name) as Class;
			} 
			catch (e:ReferenceError) 
			{
				return null;
			}
			return null;
		}
		
		/**
		 * @private
		 * 监听加载事件
		 * 
		 * @param info加载对象的LoaderInfo
		 */
		private function initLoadEvent(info : *):void 
		{
			info.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
			info.addEventListener(Event.COMPLETE, this.onComplete);
			info.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
			info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
		}
		
		/**
		 * @private
		 * 移除加载事件
		 * 
		 * @param inft加载对象的LoaderInfo
		 */
		private function removeLoadEvent(info:*):void 
		{
			info.removeEventListener(Event.COMPLETE,onComplete);
			info.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			info.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
		}
		
		/** 加载事件 */
		private function onComplete(e:Event):void 
		{
			var info:* = e.currentTarget;
			removeLoadEvent(info);
			if(loadMaterial){
				//创建材质
				btr = new BitmapTextureResource(e.target.content.bitmapData);
				m_loadinfo = info;
			}
			else if(loadParser)
			{
				var __byte:ByteArray = new ByteArray();
				this.loaderCollada.readBytes(__byte);
				_parserData[_modelName]=new Object();
				_parserData[_modelName]= __byte;
			}                             
			this.dispatchEvent(e);
		}
		
		/** åŠ è½½ï¿*/
		private function onProgress(e:ProgressEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		/** 出错事件 */
		private function onError(e:Event):void 
		{
			this.dispatchEvent(e);
		}
	}
	
}