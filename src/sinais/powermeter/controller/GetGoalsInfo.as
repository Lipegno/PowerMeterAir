package sinais.powermeter.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import sinais.powermeter.proxy.FlerryProxy;
	
	public class GetGoalsInfo extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			var data:Date      = new Date();
			switch(Number(note.getBody())){
				
				case 0:
					proxy.getGoalsByDay(data.toString());
					break;
				
				case 1:
					proxy.getGoalsByWeek(data.toString());
					break;
				
				case 2:
					proxy.getGoalsByMonth(data.toString());
					break;
			
			}
			
			
		}
	}
}