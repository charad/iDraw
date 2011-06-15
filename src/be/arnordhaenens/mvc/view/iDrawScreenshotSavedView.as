package be.arnordhaenens.mvc.view
{
	/**
	 * Imports
	 **/
	import be.arnordhaenens.events.CameraEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Class	iDrawScreenshotSavedView
	 * @author	D'Haenens Arnor
	 * @since	14 June 2011, 16:50:53
	 **/
	public class iDrawScreenshotSavedView extends Sprite
	{
		/**
		 * Variables
		 **/
		private var _notification:NotificationMC;
		private var _width:uint;
		private var _height:uint;
		
		/**
		 * Constructor
		 **/
		public function iDrawScreenshotSavedView(width:uint, height:uint)
		{
			super();
			
			//add event listener
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			//setting the variables for the width and height
			this._width = width;
			this._height = height;
		}
		
		/**
		 * Init function
		 **/
		private function init(evt:Event=null):void
		{
			//createNotification
			createNotification();
		}
		
		/**
		 * Creating the notification
		 **/
		private function createNotification():void
		{
			_notification = new NotificationMC();
			_notification.x = _notification.y = 0; 
			
			_notification.background.width = this._width;
			_notification.background.height = this._height;
			
			_notification.notification.x = (_notification.background.width - _notification.notification.width) * .5;
			_notification.notification.y = (_notification.background.height - _notification.notification.height) * .5;
			
			_notification.notification.btnNotification.addEventListener(MouseEvent.CLICK, handleButtonNotificationClick);
			_notification.notification.btnNotification.gotoAndStop(1);
			
			addChild(_notification);
		}
		
		/**
		 * Handle Button notification click
		 **/
		private function handleButtonNotificationClick(evt:MouseEvent):void
		{
			_notification.notification.btnNotification.gotoAndStop(5);
			_notification.notification.btnNotification.removeEventListener(MouseEvent.CLICK, handleButtonNotificationClick);
			this.parent.stage.removeChild(this);
			
			dispatchEvent(new CameraEvent(CameraEvent.SAVED));
		}
	}
}