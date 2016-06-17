package sinais.powermeter.handlersObjects.semaphore
{
	import flash.events.Event;
	
	public class SemaphoreEvent extends Event
	{
		public static const AVAILABLE:String = "semaphoreAvailable";
		public static const UNAVAILABLE:String = "semaphoreUnavailable";
		
		public function SemaphoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}