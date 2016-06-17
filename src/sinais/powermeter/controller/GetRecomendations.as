package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FileIOProxy;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	
	public class GetRecomendations extends SimpleCommand
	{
		public function GetRecomendations()
		{
			var proxy:FileIOProxy = FileIOProxy( facade.retrieveProxy( FileIOProxy.NAME ) );
			proxy.getRecomendations();
		}
	}
}