package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FileIOProxy;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;

	public class StartExecution extends SimpleCommand
	{
		public function StartExecution()
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			proxy.start();
			
			var file_proxy:FileIOProxy = FileIOProxy (facade.retrieveProxy(FileIOProxy.NAME));
			file_proxy.readConfigurations();
			
		}
	}
}