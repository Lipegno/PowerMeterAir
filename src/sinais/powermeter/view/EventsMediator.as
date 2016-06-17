package sinais.powermeter.view
{
	import flash.events.Event;
	
	import mx.charts.BubbleChart;
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	import sinais.powermeter.handlersObjects.DecisionTreeCalculator;
	import sinais.powermeter.handlersObjects.SoundGenerator;
	import sinais.powermeter.proxy.ClassificationSocketProxy;
	import sinais.powermeter.proxy.PowerSocket;
	import sinais.powermeter.view.components.ClassificationEvent;


	public class EventsMediator extends Mediator implements IMediator 
	{
		public static const NAME:String	= "EventsMediator";
		private var last_hourData:Date;
		public var lastminute:int=0;
		public var radiusIncrement:Number=1;
		public var soundEvent:SoundGenerator;
		private var lastMinutes:int =new Date().minutes;
		
		
		public function EventsMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);
			last_hourData = new Date();
			radiusIncrement = radiusIncrement+ConfigSingleton.getInstance().getEventGap();
			soundEvent= new SoundGenerator();
		}
						
		override public function listNotificationInterests():Array
		{
			return [PowerSocket.LASTEVENT];
		}
		
		override public function handleNotification(note:INotification):void{		
			switch ( note.getName() )
			{
				case PowerSocket.LASTEVENT:
					var test:XML = new XML(note.getBody());
					updateEventsArray(test);
					break;
			}			
		}
		
		private function updateEventsArray(eventData:XML):void{
			
			var currentData:Date = new Date();
			
			if(!(currentData.hours==last_hourData.hours)){
				app.eventsArray= new ArrayCollection();
				last_hourData=currentData;
			}
			//<knn k="3" votes="3" distance="14.79" certainty="1.0">	

			var item:Object = new Object();
			item.r=10;
			var time:Number = eventData.timestamp;
			var data:Date = new Date(time);
			var cluster:int = DecisionTreeCalculator.getCluster(eventData.alphaP, eventData.betaP, eventData.deltaPMean)[1];
			var minutes:int= data.minutes;
			var	angleRads:Number = calculate_angle(minutes);
			trace(lastminute+"  "+minutes);
			trace("event recieved "+eventData.deltaPMean);
			if((Math.abs(eventData.deltaPMean)>ConfigSingleton.getInstance().maxEvent) ){
				
			if(minutes!=lastminute){
				item.x = ((0*Math.cos(angleRads))-(-10*Math.sin(angleRads)));
				item.y = ((0*Math.sin(angleRads))+(-10*Math.cos(angleRads)));
				lastminute=minutes;
				radiusIncrement=1+ConfigSingleton.getInstance().getEventGap();;
			}
			else{
				item.x = ((0*Math.cos(angleRads))-(-10*radiusIncrement*Math.sin(angleRads)));
				item.y = ((0*Math.sin(angleRads))+(-10*radiusIncrement*Math.cos(angleRads)));
				radiusIncrement = radiusIncrement+ConfigSingleton.getInstance().getEventGap();
			}
			
			
			 
			item.i =cluster;
			item.deltaPMean = eventData.deltaPMean;
			item.event_id = eventData.id;
			item.appliance_id = eventData.appliance.@id;
			item.appliance_guess = eventData.knn.appliance;
			item.r=10;
			item.is_class = (eventData.classified==true);
			app.eventsArray.addItem(item);
			
			//check for the sound
			trace("->->"+ConfigSingleton.getInstance().soundEnabled);
			if(ConfigSingleton.getInstance().soundEnabled){
				var value:Number=eventData.deltaPmean;
				if(ConfigSingleton.getInstance().historicalSound){
					value = calculateTimestampDiff();
				}
			soundEvent.play(value);
			}
			}
		}  
		
	
		private function calculateTimestampDiff():Number{
			 
			var data:Date = new Date();
			var timeDiff:int = data.minutes - lastMinutes;
			
			
			trace("minutes - >"+ data.minutes);
			trace("last minutes - >"+ lastMinutes);

			trace("time diff val-> "+(timeDiff*1100)/20);
			lastMinutes=data.minutes;
			return ((timeDiff*1100)/20);
			    
			
		}
		
		private function calculate_angle(minutes:int):Number{
		
			minutes = minutes<=3?minutes+2:minutes;
			var angle:Number = (5.5273*minutes) + 12;
			return ( (angle*Math.PI)/180)*-1;
		} 
		
		public function get app():PowerMeter5
		{ 
			return viewComponent as PowerMeter5; 
		}
	}
}