package sinais.powermeter.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sinais.powermeter.ApplicationFacade;
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	import sinais.powermeter.handlersObjects.XML_Handlers;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerSocket;
	import sinais.powermeter.view.components.Hour_Gauge;
	import sinais.powermeter.proxy.ClassificationSocketProxy;
	import sinais.powermeter.view.components.ClassificationEvent;
	
	public class HourGaugeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "HourGaugeMediator";
		private var last_hourData:Date;
		public function HourGaugeMediator(viewComponent:Hour_Gauge)
		{
			super(NAME,viewComponent);
			last_hourData = new Date();
		}
		
		override public function onRegister( ):void
		{
			hourGauge.addEventListener(Hour_Gauge.GETHOURCONS,handleEvent);
			hourGauge.addEventListener(Hour_Gauge.STARTUPHOURCONS,handleEvent);
			hourGauge.addEventListener(Hour_Gauge.CLASSIFIED_EVT, handleEvent);
		}
		
		override public function listNotificationInterests():Array
		{
 			return[FlerryProxy.HOURCONS, PowerSocket.CURRENTCONS];
		}
		
		override public function handleNotification(note:INotification):void{		
			switch ( note.getName() )
			{
				case FlerryProxy.HOURCONS:
					hourGauge.HGauge.hours=handleHourConsump(new XML(note.getBody()));
					hourGauge.HGauge.fillColors();
					hourGauge.HGauge.fillLabels();
					break;
				 
				case PowerSocket.CURRENTCONS:
					hourGauge.HGauge.consumo.text =  Math.round(Number(note.getBody())).toString()+" W";
					break;	
				
				case PowerSocket.LASTEVENT:
					var test:XML = new XML(note.getBody());
					updateEventsArray(test);
					break;
			}			
		}
		
		private function handleEvent( event:Event ):void
		{
		 switch ( event.type ) 
			{
			 	case Hour_Gauge.GETHOURCONS:
					sendNotification(ApplicationFacade.GETHOURBYMINUTE,1,event.type);
					break;
				
				case Hour_Gauge.CURRENTPOWER:
					sendNotification (ApplicationFacade.GETCURRENTPOW, null, event.type );
					break;
				
				case Hour_Gauge.STARTUPHOURCONS:
					sendNotification(ApplicationFacade.GETHOURBYMINUTE,0,event.type);
					break;
				
				case Hour_Gauge.CLASSIFIED_EVT:
					var proxy:ClassificationSocketProxy = ClassificationSocketProxy( facade.retrieveProxy( ClassificationSocketProxy.NAME ) );
					proxy.sendData(ClassificationEvent(event).data);
					trace("mandei pedido");
					break;
		 	}
		}
		
		public function handleHourConsump(hour:XML):Array{
			
			var xmlhandler:XML_Handlers = new XML_Handlers();
			var hour_data:Array = xmlhandler.buildHourXML(hour);
			var result:Array = new Array();
			var i:int;
			var maxPowerExpected:int = ConfigSingleton.getInstance().getMaxPower5m();
			var consump:Array = new Array();
			
			for(i=0;i<hour_data.length;i++){
				var color:Number;
				var cons:Number = hour_data[i];
				consump.push(cons);
				
				if(hour_data[i]==0){
					color = 0xFFFFFF;
				}
				else if(hour_data[i]<(maxPowerExpected*0.083)){
					color = 0x80BF54;
				}
				else if(hour_data[i]<(maxPowerExpected*0.166)){
					color = 0xB3CF56;
				}
				else if(hour_data[i]<(maxPowerExpected*0.249)){
					color = 0xC2CF63;
				}
				else if(hour_data[i]<(maxPowerExpected*0.35)){
					color = 0xE4D847;
				}
				else if(hour_data[i]<(maxPowerExpected*0.45)){
					color = 0xE9F43A;
				}
				else if(hour_data[i]<(maxPowerExpected*0.52)){
					color = 0xF4EB00;
				}
				else if(hour_data[i]<(maxPowerExpected*0.6)){
					color = 0xF4C339;
				}
				else if(hour_data[i]<(maxPowerExpected*0.664)){
					color = 0xC9A12F;
				}
				else if(hour_data[i]<(maxPowerExpected*0.747)){
					color = 0xC94E28;
				}
				else if(hour_data[i]<(maxPowerExpected*1)){
					color = 0xC9000D;
				}
				else if(hour_data[i]>(maxPowerExpected)){
					color = 0x330000;
				}
				result.push(color);
			}
			hourGauge.HGauge.hoursCons = consump;
			return result;
		}
		
		
		private function updateEventsArray(eventData:XML):void{
				
				var currentData:Date = new Date();
				
				if(!(currentData.hours==last_hourData.hours)){
					hourGauge.s1= new ArrayCollection();
					last_hourData=currentData;
				}
				
				var item:Object = new Object();
				item.r=10;
				var time:Number = eventData.timestamp;
				var data:Date = new Date(time);

				var minutes:int= data.minutes;
				var	angleRads:Number = calculate_angle(minutes);
				item.x = ((0*Math.cos(angleRads))-(-10*Math.sin(angleRads)));
				item.y = ((0*Math.sin(angleRads))+(-10*Math.cos(angleRads)));
				item.i = eventData.cluster;
				item.deltaPMean = eventData.deltaPMean;
				item.r=10;
				item.is_class = (Math.random()*2>1)?1:0;
				
				hourGauge.s1.addItem(item);       
				
				hourGauge.s1.refresh();
		}
		
		private function calculate_angle(minutes:int):Number{
			var angle:Number = (5.5273*minutes) + 8;
			return ( (angle*Math.PI)/180)*-1;
		}
		
		public function get hourGauge():Hour_Gauge{
			return viewComponent as Hour_Gauge;
		}
	}
}