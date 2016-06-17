package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;

	import sinais.powermeter.proxy.FlerryProxy;

	public class GetHourByMinuteCons extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );	
			
			if(note.getBody()==0){
				proxy.getHourCons();
			}
			else{
				proxy.gethourconsumption();				
			}
		}
	}
}