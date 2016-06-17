package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	
	public class HandlesGoalsInterfaceChange extends SimpleCommand
	{
		public static const INTERFACE_CHANGED:String = "command/INTERFACE_CHANGED";
		
		override public function execute( note:INotification ) :void
		{
			if(note.getBody().toString()=="goalsStatus/actions/GETMOREINFO"){
				sendNotification(INTERFACE_CHANGED,"expand");
			}
			else{
				sendNotification(INTERFACE_CHANGED,"colapse");

			}
				
		}
	}
}