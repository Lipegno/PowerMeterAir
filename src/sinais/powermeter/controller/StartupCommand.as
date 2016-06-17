package sinais.powermeter.controller
{
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.observer.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	
	import sinais.powermeter.*;
	import sinais.powermeter.controller.*;
	import sinais.powermeter.proxy.*;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.view.*;
	
	/**
	 * Create and register <code>Proxy</code>s with the <code>Model</code>.
	 */
	public class StartupCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			
			var app:PowerMeter5 = note.getBody() as PowerMeter5;
			facade.registerProxy( new PowerMeterProxy());	
			facade.registerProxy( new FileIOProxy("recomendations.txt"));
			
			var file_proxy:FileIOProxy = FileIOProxy (facade.retrieveProxy(FileIOProxy.NAME));
			file_proxy.readConfigurations();
			file_proxy.readHouseHoldInfo();
			file_proxy.readStepGreenGoals();
			
			facade.registerProxy( new MotionDetectorProxy());
			//facade.registerProxy( new PowerSocket("127.0.0.1", 7112));
			facade.registerProxy( new FlerryProxy());
			facade.registerProxy( new StepGreenProxy());
			facade.registerMediator( new ApplicationMediator( app ) );
			sendNotification( DesktopCitizenConstants.WINDOW_OPEN, app.stage ); 

		}
	}
}