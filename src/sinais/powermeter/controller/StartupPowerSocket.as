package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.proxy.PowerSocket;
	import sinais.powermeter.proxy.ClassificationSocketProxy;

	import spark.effects.easing.Power;
	
	public class StartupPowerSocket extends SimpleCommand
	{
		public function StartupPowerSocket()
		{
			facade.registerProxy( new PowerSocket("127.0.0.1", 7112));
			facade.registerProxy( new ClassificationSocketProxy());
		}
	}
}