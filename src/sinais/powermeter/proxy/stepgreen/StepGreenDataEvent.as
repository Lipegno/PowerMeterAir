package sinais.powermeter.proxy.stepgreen
{
	import flash.events.Event;

	public class StepGreenDataEvent extends Event
	{
		public var data:String;
		public function StepGreenDataEvent(type:String, data:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type,bubbles,cancelable);
			this.data=data;
		}
	}
}