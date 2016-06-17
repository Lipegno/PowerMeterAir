package sinais.powermeter.view
{
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.events.Event;
	import sinais.powermeter.view.components.NavigationBar; 
	import sinais.powermeter.ApplicationFacade;
	import PowerMeter5;
	
	public class NavigationBarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "NavigationBarMediator";
		public function NavigationBarMediator(viewComponent:NavigationBar)
		{
			super(NAME,viewComponent);
		}
		
		override public function onRegister():void{
			NavBar.addEventListener(NavigationBar.DAY,handleEvent);
			NavBar.addEventListener(NavigationBar.MONTH,handleEvent);
			NavBar.addEventListener(NavigationBar.YEAR,handleEvent);
			NavBar.addEventListener(NavigationBar.WEEK,handleEvent);
			NavBar.addEventListener(NavigationBar.HOUR,handleEvent);
			NavBar.addEventListener(NavigationBar.GOALSVIEW,handleEvent);
		}
		
		private function handleEvent( event:Event ):void
		{
			sendNotification(ApplicationFacade.CHANGEVIEW,event.type.toString(), event.type);		
			sendNotification(ApplicationFacade.INSERTEVT,event.type.toString(), event.type);

 		}
		
		public function get NavBar():NavigationBar
		{ 
			return viewComponent as NavigationBar; 
		}
		
	}
}