package be.arnordhaenens.events
{
	/**
	 * Imports
	 **/
	import flash.events.Event;
	
	/**
	 * Class	ApplicationEvent
	 * @author	D'Haenens Arnor
	 * @since	14 June 2011, 00:09:00
	 * @see		flash.events.Event
	 **/
	public class ApplicationEvent extends Event
	{
		/**
		 * Variables
		 **/
		public static const CLOSE:String = "applicationEventClose";
		
		/**
		 * Constructor
		 **/
		public function ApplicationEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * override clone
		 **/
		override public function clone():Event
		{
			return new ApplicationEvent(type, bubbles, cancelable);
		}
	}
}