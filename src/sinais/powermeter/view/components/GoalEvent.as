package sinais.powermeter.view.components
{
	import flash.events.Event;

	public class GoalEvent extends Event
	{
		public var data:String;
		public function GoalEvent(type:String, data:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type,bubbles,cancelable);
			this.data=data;
		}
	}
}