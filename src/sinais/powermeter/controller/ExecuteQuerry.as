package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.proxy.FlerryProxy;

	public class ExecuteQuerry extends SimpleCommand
	{
		public function ExecuteQuerry()
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			proxy.start();
		}
	}
}