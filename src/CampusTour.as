package
{
	import com.jeff.managers.ResourceManager;
	import com.jeff.managers.ResourceManager2D;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.ui.ContextMenu;

	[SWF(frameRate="60", align="center", backgroundColor="#000000")] 
	public class CampusTour extends Sprite
	{
		private var _stage3D:Stage3D;
		private var _context3D:Context3D;
		private var _firstTime:Boolean = true;
		
		[Embed(source="assets/swf/LoadingPage.swf#LoadingPage")]
		private var Loading:Class;
		[Embed(source="assets/swf/TRC_installplayer.swf#TRC_String")]
		private var TrcInstallPlayer:Class;
		private var _loading:*;
		private var _contextMenu:ContextMenu;
		public function CampusTour()
		{
			if (stage != null)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{	
			//trace(flash.system.Capabilities.version)
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			
			if (GlobalValue.checkPlayerVersion())
			{
				try{					
					//stage.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick)
				}catch(e:Error){
					
				}
				stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
				stage.stage3Ds[0].requestContext3D();
				
				_contextMenu = new ContextMenu();
				_contextMenu.hideBuiltInItems();
			}
			else
			{
				var trcInstallPlayer:* = new TrcInstallPlayer();
				stage.addChild(trcInstallPlayer);
				trcInstallPlayer.x = (stage.stageWidth - trcInstallPlayer.width)/ 2;
				trcInstallPlayer.y = (stage.stageHeight - trcInstallPlayer.height) / 2;
			}
		}
		
		public function setProg(value:Number):void
		{
			//loading.bar.gotoAndStop(value);
			_loading.txtLoading.text="Loading..."+value+"%";	
		}
		
		private function onContext3DCreate(e:Event):void
		{
			_stage3D = e.target as Stage3D;
			_context3D = _stage3D.context3D;
			GlobalValue.setDisplayQuality(_context3D.driverInfo);
			
			if (!_firstTime)
				GlobalValue.refresh3DEnvironment(stage, _stage3D, _context3D);
			else
			{
				GlobalValue.init(this, stage, _stage3D, _context3D);
				_loading = new Loading();
				stage.addChild(_loading);
				_loading.x = (stage.stageWidth - _loading.width)/ 2;
				_loading.y = (stage.stageHeight - _loading.height) / 2;
				_loading.txtLoading.text="Loading..."+"0%"
				_loading.txtLoading.selectable=false;
				_loading.txtHints.selectable=false;
				stage.addEventListener(Event.RESIZE, resizeStageLoadingPhase);
				// load resource
				ResourceManager.getInstance().addEventListener(ResourceManager.loadOver, loadComplete3D);
				ResourceManager.getInstance().load(ResourceManager.resourceXML);
				_firstTime = false;
			}	
		}
		
		private function resizeStageLoadingPhase(e:Event):void
		{
			trace("resize")
			_loading.x = (stage.stageWidth - _loading.width) / 2;
			_loading.y = (stage.stageHeight - _loading.height) / 2;
		}
		
		private function loadComplete3D(event:Event):void
		{
			ResourceManager.getInstance().removeEventListener(ResourceManager.loadOver, loadComplete3D);
			
			ResourceManager2D.getInstance().addEventListener(Event.COMPLETE, loadComplete);
			ResourceManager2D.getInstance().load();
		}
		
		private function loadComplete(e:Event):void
		{
			stage.removeChild(_loading);
			stage.removeEventListener(Event.RESIZE, resizeStageLoadingPhase);
			
			// enter 3D scene directly
			GlobalValue.initilize3DEngine();
			GlobalValue.startUP3DEngine();
		}
		
	}
}