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
	import sinais.powermeter.handlersObjects.XML_Handlers;
	import sinais.powermeter.proxy.FileIOProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.view.components.Recomendations;
	
	public class RecomendationsMediator extends Mediator implements IMediator
	{
		public static const NAME:String	= "RecomendationsMediator";
		
		public function RecomendationsMediator(viewComponent:Object )
		{
			super(NAME,viewComponent) 
		}
		
		override public function onRegister( ):void
		{
			recomendation.addEventListener(Recomendations.RECOM, handleEvent );			
		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
				case Recomendations.RECOM:
					sendNotification (ApplicationFacade.GETRECOMENDATIONS, null, event.type );
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [FileIOProxy.RECOMEND];
		}
		
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case FileIOProxy.RECOMEND:
				recomendation.recomText.text=note.getBody().toString();
				break;					
			}
			
		}
		
		private function formatRecomendation(data:String):void{

			
		}
		
		public function get recomendation():Recomendations
		{ 
			return viewComponent as Recomendations; 
		}
	}
}