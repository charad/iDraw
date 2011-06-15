package be.arnordhaenens.mvc.model
{
	/**
	 * Imports
	 **/
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Class	iDrawModel
	 * @author	D'Haenens Arnor
	 * @see 	flash.events.EventDispatcher
	 * @see 	flash.events.IEventDispatcher
	 **/
	public class iDrawModel extends EventDispatcher
	{
		/**
		 * Variables
		 **/
		
		/**
		 * Constructor
		 **/
		public function iDrawModel(target:IEventDispatcher=null)
		{
			super(target);
			
			//call init
			init();
		}
		
		/**
		 * Initializer
		 **/
		private function init():void
		{
			
		}
	}
}