package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	
	public class GetMonthComp extends SimpleCommand
	{
		public function GetMonthComp()
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			var data:Date = new Date();
			
			var mes:String 	   = (data.month+1)>9 ? (data.month+1).toString() : "0"+(data.month+1).toString();
			var minutos:String = (data.minutes)>=10 ? (data.minutes).toString() : "0"+(data.minutes).toString();
			var hora:String    = (data.hours)>=10 ? (data.hours).toString():"0"+(data.hours).toString();				
			var dia:String 	   = data.dateUTC-1>=10?data.dateUTC-1+"":"0"+(data.dateUTC-1);
			var mes2:String    = (data.month)>9 ? (data.month).toString() : "0"+(data.month).toString();

			
			proxy.getMonthComp(data.fullYear+"-"+mes+"-"+dia,mes,data.fullYear+"-"+mes2+"-"+dia,mes2);
			
		}
	}
}