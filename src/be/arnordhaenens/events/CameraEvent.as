package be.arnordhaenens.events
{
	/**
	 * Imports
	 **/
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * Class	CameraEvent
	 * @author	D'Haenens Arnor
	 * @see 	flash.events.Event
	 **/
	public class CameraEvent extends Event
	{
		/**
		 * Variables
		 **/
		public static const SHOW_INTERFACE:String = "cameraEventShowInterface";
		public static const SAVE:String = "cameraEventSave";
		public static const SAVED:String = "cameraEventSaved";
		
		public var bitmapData:BitmapData;
		
		/**
		 * Constructor	CameraEvent
		 * 
		 * Change the bubbles boolean to true!
		 * Main application can detect this event
		 **/
		public function CameraEvent(type:String, bitmapData:BitmapData=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			this.bitmapData = bitmapData;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * override clone
		 **/
		override public function clone():Event
		{
			return new CameraEvent(type, bitmapData, bubbles, cancelable);
		}
	}
}