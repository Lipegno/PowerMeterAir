package sinais.powermeter.handlersObjects.semaphore
{
	import flash.events.EventDispatcher;
	
	[Event(type="com.partlyhuman.semaphore.SemaphoreEvent", name="available")]
	[Event(type="com.partlyhuman.semaphore.SemaphoreEvent", name="unavailable")]
	
	public class Semaphore extends EventDispatcher
	{
		protected var _description:String;
		public function get description():String {return _description;}
		
		protected var _owner:Object;
		public function get owner():Object {return _owner;}
		
		public function Semaphore(owner:Object = null, description:String = null)
		{
			_owner = owner;
			_description = description;
			initialize();
		}
		
		protected function initialize():void
		{
			throw new Error("Abstract Method");
		}
		
		public function get locks():int
		{
			throw new Error("Abstract Method");
			return 0;
		}
		
		public function get isLocked():Boolean
		{
			throw new Error("Abstract Method");
			return false;
		}
		
		override public function toString():String
		{
			return "[Semaphore " + description + "]";
		}
	}
}