package sinais.powermeter.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	
	public class GetMonthByDay extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );	
			var data:Date 		  = new Date();
			var mes:String 	   = (data.month+1)>9 ?  (data.month+1).toString() : "0"+ (data.month+1).toString();
			
			switch(note.getBody()){
				
				case 1:
					proxy.getMonthByDay(mes);
					break;
				
				case 2:
					proxy.startupMonthCons();
					break;
			}
				
			proxy.getMonthByDay(mes);
		}
		
	}
}