package sinais.powermeter.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import sinais.powermeter.proxy.FlerryProxy;
	
	public class InsertGoal extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			
			switch(Number(note.getBody())){
			
				case 0:
					proxy.insertDailyGoal(note.getType());
					break;
				case 1:
					proxy.insertWeeklyGoal(note.getType());
					break;
				case 2:
					proxy.insertMonthlyGoal(note.getType());
					break;
			
			}
			
		}
	}
}