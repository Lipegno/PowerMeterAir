package sinais.powermeter.controller
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.observer.*;
	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	
	import sinais.powermeter.*;
	import sinais.powermeter.controller.*;
	import sinais.powermeter.proxy.*;
	import sinais.powermeter.view.*;
	import sinais.powermeter.ApplicationFacade;
	
	public class NavigationBarControl extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			var proxy:PowerMeterProxy = PowerMeterProxy( facade.retrieveProxy( PowerMeterProxy.NAME ) );			
			proxy.changeView(note.getBody().toString()); // changes the view
		}
	}
}