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
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.view.components.Day_Gauge;
	import sinais.powermeter.proxy.PowerSocket;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	
	public class GaugeMediator extends Mediator implements IMediator
	{
		public static const NAME:String	= "GaugeMediator";
		
		public function GaugeMediator(viewComponent:Object)
		{
			super(NAME,viewComponent)
		}
		
		override public function onRegister( ):void
		{
			gauge.addEventListener(Day_Gauge.DAYCONSUMP, handleEvent );
			gauge.addEventListener(Day_Gauge.CURRENTPOWER, handleEvent );
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [FlerryProxy.DAYCONS, PowerSocket.CURRENTCONS];
		}
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case FlerryProxy.DAYCONS:
					gauge.test.fills =  setColorsDay(new XML(note.getBody()));
					gauge.test.cons  = setConsumpArray(new XML(note.getBody()));
					gauge.test.fillColors();
					break;	
				
				case PowerSocket.CURRENTCONS:
					gauge.test.consumo.text =  Math.round(Number(note.getBody())).toString()+" W";
					break;	
				
			
			}
			
		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{

				case Day_Gauge.DAYCONSUMP:
					sendNotification (ApplicationFacade.GETDAYCONS, null, event.type );
					break;
				 
				case Day_Gauge.CURRENTPOWER:
					sendNotification (ApplicationFacade.GETCURRENTPOW, null, event.type );
					break;
			}
		}
		
		private function setColorsDay(dayCons:XML):Array{
			var maxPowerExpected:int = ConfigSingleton.getInstance().getMaxPowerHour();
			var result:Array 		 = new Array();
			var xmlhandler:XML_Handlers = new XML_Handlers();
			var resultLength:int;
			var i:int;
			dayCons = xmlhandler.buildDayXML(dayCons);
			var length:int   		 = xmlhandler.calculatesXMLSize(dayCons);

			for(i=0;i<length;i++){
				var color:Number;
				
				if(dayCons.powerSample[i].@pA==0){
					color = 0xFFFFFF;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.083)){
					color = 0x80BF54;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.166)){
					color = 0xB3CF56;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.249)){
					color = 0xC2CF63;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.35)){
					color = 0xE4D847;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.45)){
					color = 0xE9F43A;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.52)){
					color = 0xF4EB00;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.6)){
					color = 0xF4C339;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.664)){
					color = 0xC9A12F;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*0.747)){
					color = 0xC94E28;
				}
				else if(dayCons.powerSample[i].@pA<(maxPowerExpected*1)){
					color = 0xC9000D;
				}
				else if(dayCons.powerSample[i].@pA>(maxPowerExpected)){
					color = 0x330000;
				}
				
				resultLength = (result.push(color));
				
				}
 
				return result;

			 }
			
		
		private function setConsumpArray(dayCons:XML):Array{

			var result:Array = new Array();
			var xmlhandler:XML_Handlers = new XML_Handlers();
			var resultLength:int;
			var i:int;
			dayCons = xmlhandler.buildDayXML(dayCons);
			var length:int   		 = xmlhandler.calculatesXMLSize(dayCons);
			
			for(i=0;i<length;i++){
			
				var cons:Number = (Math.round(dayCons.powerSample[i].@pA));
				result.push(cons);
				
			}
			
			return result;
			
		}
		
		public function get gauge():Day_Gauge
		{ 
			return viewComponent as Day_Gauge; 
		}
	}
}