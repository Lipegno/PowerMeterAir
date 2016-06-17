package sinais.powermeter.view.components
{
	import flash.events.Event;
	
	public class ClassificationEvent extends Event
	{
		public var data:String;
		public function ClassificationEvent(type:String, data:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type,bubbles,cancelable);
			this.data=data;
		}
	}
}