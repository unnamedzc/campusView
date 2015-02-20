package com.jeff.managers
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class ResourceManager2D extends EventDispatcher
	{
		private static const configFile:String = "xml/SWFResource.xml";
		private static var _instance:ResourceManager2D;
		private var _loadArray:Array = new Array();
		
		private var _loaderXML:URLLoader;
		private var _loadIndex:int = 0;
		private var _loaderSWF:Loader;
		private var _loaderContent:LoaderContext;
		
		public static function getInstance():ResourceManager2D
		{
			if (!_instance)
				_instance = new ResourceManager2D();
			return _instance;
		}
		
		public function load():void
		{
			_loaderXML = new URLLoader();
			_loaderXML.load(new URLRequest(configFile));
			_loaderXML.addEventListener(Event.COMPLETE, onXMLLoad);
		}
		
		private function onXMLLoad(event:Event):void
		{
			_loaderXML.removeEventListener(Event.COMPLETE, onXMLLoad);
			var xmlData:XML = XML(event.target.data);
			loadSWFFile(xmlData);
		}
		
		private function loadSWFFile(xmlData:XML):void
		{
			var xmls:XMLList = xmlData.children();
			for each(var item:XML in xmls)
			{
				var atts:XMLList = item.attributes();
				var swfPath:String = atts[1].toString();
				_loadArray.push(swfPath);
			}
			loadIntoGame(null);
		}
		
		private function loadIntoGame(e:Event):void
		{
			if (_loadArray.length >= ++_loadIndex)
			{
				_loaderSWF = new Loader();
				_loaderContent = new LoaderContext();
				_loaderContent.applicationDomain = ApplicationDomain.currentDomain;
				_loaderSWF.contentLoaderInfo.addEventListener(Event.COMPLETE, loadIntoGame);
				_loaderSWF.load(new URLRequest(_loadArray[_loadIndex - 1]), _loaderContent);
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}