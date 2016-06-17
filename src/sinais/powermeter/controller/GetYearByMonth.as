package sinais.powermeter.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;

	public class GetYearByMonth extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			var data:Date      = new Date();
			var year:String    = data.getFullYear().toString();
			switch(note.getBody()){
			
				case 1:
					proxy.getYearByMonthCons(year);
					break;
				
				case 2:
					proxy.startupYearConsump();
					break;

			}
		}
	}
}