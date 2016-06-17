package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import PowerMeter5;
	public class InsertEvent extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			if(note.getBody()==PowerMeter5.INSERTEVENTMOTION){
				proxy.insertEvent("motion",1);
			}
			else{
				trace("mandei evento rato");
				proxy.insertEvent(note.getBody().toString(),3);

			}
		}
	}
}