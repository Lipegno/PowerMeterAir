package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.proxy.PowerSocket;
	
	import spark.effects.easing.Power;
	
	public class GetCurrentPower extends SimpleCommand
	{
		public function GetCurrentPower()
		{
			var proxy:PowerSocket = PowerSocket( facade.retrieveProxy( PowerSocket.NAME ) );
			if(proxy!=null){
			proxy.sendData("map|lastSampleRealPower","127.0.0.1");
			trace("mandei pedido");
			}
		}
	}
}