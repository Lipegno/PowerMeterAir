package sinais.powermeter.view
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.facade.*;
	import org.puremvc.as3.patterns.mediator.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.*;
	
	import sinais.*;
	import sinais.powermeter.ApplicationFacade;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.MotionDetectorProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.view.GoalsMediator;
	
	public class ApplicationMediator extends Mediator
	{
		public static const NAME:String	= "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:PowerMeter5)
		{
			super( NAME, viewComponent );
			facade.registerMediator( new GaugeMediator( app.Day_Gauge ) );	
			facade.registerMediator( new EventsMediator(app));
			facade.registerMediator( new CO2EmissionsMediator( app.CO2Emissions ) );	
			facade.registerMediator( new EnergyConsMediator( app.EnergyCons ) );	
			facade.registerMediator( new RecomendationsMediator( app.Recoms ) );	
			facade.registerMediator( new NavigationBarMediator( app.NavBar ) );	
			facade.registerMediator( new NotificationsMediator( app.Notifications));	
			facade.registerMediator(new GoalsMediator(app.GoalsStatus));

		}
		
		override public function onRegister( ):void
		{
			app.addEventListener(PowerMeter5.START, handleEvent );
			app.addEventListener(PowerMeter5.EVENTSBYHOUR, handleEvent );
			app.addEventListener(PowerMeter5.WEEKTOTAL, handleEvent );
			app.addEventListener(PowerMeter5.INSERTEVENTMOTION, handleEvent); 

		}
		
		override public function listNotificationInterests():Array
		{
			return [ PowerMeterProxy.QUERY, FlerryProxy.QUERY,GoalsMediator.CHANGEVIEWGOALS, GoalsMediator.STARTUPCOMPLETE,
					FlerryProxy.QUERYRESULT, PowerMeterProxy.CHANGEVIEWDAY, PowerMeterProxy.CHANGEVIEWHOUR, PowerMeterProxy.CHANGEVIEWMONTH
			, PowerMeterProxy.CHANGEVIEWWEEK, PowerMeterProxy.CHANGEVIEWWEEK, PowerMeterProxy.CHANGEVIEWYEAR, MotionDetectorProxy.MOTIONEVT];
		
			
		}
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case PowerMeterProxy.QUERY:
					trace(note.getBody());
					app.queryValue = note.getBody().toString();
					break;	
			
				case PowerMeterProxy.CHANGEVIEWDAY:
					trace(note.getBody());
					app.setState("day");
					break;
				
				case PowerMeterProxy.CHANGEVIEWHOUR:
					trace(note.getBody());
					app.setState("hour");
					break;
				
				case PowerMeterProxy.CHANGEVIEWMONTH:
					trace(note.getBody());
					app.setState("month");
					break;
				
				case PowerMeterProxy.CHANGEVIEWWEEK:
					trace(note.getBody());
					app.setState("week");
					break;
				
				case PowerMeterProxy.CHANGEVIEWYEAR:
					trace(note.getBody());
					app.setState("year");
					break;
				
				case GoalsMediator.STARTUPCOMPLETE:
					app.setState("day");
					break;
				
				case GoalsMediator.CHANGEVIEWGOALS:
					trace(note.getBody());
					app.setState("goals");
					app.GoalsStatus.currentState="detailedState";
					break;
				
				case MotionDetectorProxy.MOTIONEVT:
					app.checkUI();
					break;
				
			}
		
		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
     			case PowerMeter5.EVENTSBYHOUR:
					sendNotification (ApplicationFacade.GETEVENTSBYHOUR, null, event.type );
					break;
				case PowerMeter5.START:
					sendNotification (ApplicationFacade.START, null, event.type );
					break;
				case PowerMeter5.INSERTEVENTMOTION:
					sendNotification (ApplicationFacade.INSERTEVT, event.type.toString(), event.type );
					break;
				
				
			}
		}
		
		
		public function get app():PowerMeter5
		{ 
			return viewComponent as PowerMeter5; 
		}
	}
}