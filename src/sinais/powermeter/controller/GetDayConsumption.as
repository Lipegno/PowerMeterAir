package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	
	public class GetDayConsumption extends SimpleCommand
	{
		public function GetDayConsumption()
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			var data:Date = new Date();
			
			var mes:String 	   = (data.month+1)>9 ? (data.month+1).toString() : "0"+(data.month+1).toString();
			var minutos:String = (data.minutes)>=10 ? (data.minutes).toString() : "0"+(data.minutes).toString();
			var hora:String    = (data.hours)>=10 ? (data.hours).toString():"0"+(data.hours).toString();				
			var dia:String 	   = data.dateUTC>=10?data.dateUTC+"":"0"+(data.dateUTC);

			proxy.getDayConsumption(data.fullYear+"-"+mes+"-"+dia, hora,minutos);
		}
	}
}