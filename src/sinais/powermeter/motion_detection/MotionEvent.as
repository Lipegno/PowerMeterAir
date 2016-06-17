package sinais.powermeter.motion_detection
{
	import flash.events.Event;

	public class MotionEvent extends Event
	{
		public function MotionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
		}
	}
}