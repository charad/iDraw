package be.arnordhaenens.mvc.controller
{
	/**
	 * Imports
	 **/
	import be.arnordhaenens.events.ApplicationEvent;
	import be.arnordhaenens.events.CameraEvent;
	import be.arnordhaenens.mvc.model.iDrawModel;
	import be.arnordhaenens.mvc.view.iDrawScreenshotSavedView;
	import be.arnordhaenens.mvc.view.iDrawView;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Class	iDrawController
	 * @author	D'Haenens Arnor
	 * @see 	flash.display.Sprite
	 **/
	public class iDrawController extends Sprite
	{
		/**
		 * Variables
		 **/
		private var view:iDrawView;
		private var model:iDrawModel;
		private var _notificationView:iDrawScreenshotSavedView;
		
		private var _cameraSupported:Boolean;
		private var _addBitmapDataSupport:Boolean;
		
		/**
		 * Constructor
		 **/
		public function iDrawController(cameraSupported:Boolean, addBitmapDataSupport:Boolean)
		{
			this._cameraSupported = cameraSupported;
			this._addBitmapDataSupport = addBitmapDataSupport;
			
			super();
			
			//call init function
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Initializer
		 **/
		private function init(evt:Event=null):void
		{
			//create new view
			view = new iDrawView(this._cameraSupported, this._addBitmapDataSupport);
			
			view.addEventListener(CameraEvent.SHOW_INTERFACE, handleCameraClicked);
			view.addEventListener(CameraEvent.SAVE, handleScreenshotSave);
			view.addEventListener(ApplicationEvent.CLOSE, handleApplicationClose);
			
			this.stage.addChild(view);
			
			//create new model
			model = new iDrawModel();
			
			// Start the MonsterDebugger
			MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, "Hello World!");
		}
		
		/**
		 * Set the chosen image
		 **/
		public function handleImageChosen(url:String):void
		{
			this.view.handleImageChosen(url);
		}
		
		/**
		 * Handle image saved
		 **/
		public function handleImageSaved():void
		{
			this.view.handleScreenshotSaved();
		}
		
		/**
		 * Handle clicking the camera button
		 **/
		private function handleCameraClicked(evt:CameraEvent):void
		{
			dispatchEvent(new CameraEvent(CameraEvent.SHOW_INTERFACE));
		}
		
		/**
		 * Handle screenshot save
		 **/
		private function handleScreenshotSave(evt:CameraEvent):void
		{
			dispatchEvent(new CameraEvent(CameraEvent.SAVE));
		}
		
		/**
		 * Handling request for closing the application
		 **/
		private function handleApplicationClose(evt:ApplicationEvent):void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE));
		}
	}
}