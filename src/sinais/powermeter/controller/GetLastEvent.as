package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class GetLastEvent extends SimpleCommand
	{
		public function GetLastEvent()
		{
			var proxy:PowerSocket = PowerSocket( facade.retrieveProxy( PowerSocket.NAME ) );
			
			proxy.sendData("map|lastSampleRealPower","127.0.0.1", 8112);
			trace("mandei pedido");
		}
	}
}