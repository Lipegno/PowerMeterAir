package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	
	public class GetMonthTotal extends SimpleCommand
	{
		public function GetMonthTotal()
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			var data:Date      = new Date();
			var mes:String    = (data.month+1)>=10 ? (data.month+1).toString():"0"+(data.month+1).toString();				
			var dia:String 	   = data.dateUTC>=10?data.dateUTC-1+"":"0"+(data.dateUTC);

			proxy.getMonthTotal(mes,dia);
			//proxy.getMonthTotal(mes,dia);
		}
	}
}