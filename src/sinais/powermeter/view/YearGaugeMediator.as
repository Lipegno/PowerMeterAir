package sinais.powermeter.view
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sinais.powermeter.ApplicationFacade;
	import sinais.powermeter.handlersObjects.XML_Handlers;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerSocket;
	import sinais.powermeter.view.components.Year_Gauge;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	
	public class YearGaugeMediator extends Mediator implements IMediator
	{
		private static const NAME:String = "YearGaugeMediator";
		
		public function YearGaugeMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);
		}
		
		override public function onRegister( ):void
		{
			yearGauge.addEventListener(Year_Gauge.YEARCONS, handleEvent );
			yearGauge.addEventListener(Year_Gauge.STARTUP_YEARCONS,handleEvent);
		}
		
		private function handleEvent(event:Event ):void{
			switch ( event.type ) 
			{
				
				case Year_Gauge.YEARCONS:
					sendNotification (ApplicationFacade.GETYEARCONS, 1, event.type );
					break;
				
				case Year_Gauge.STARTUP_YEARCONS:
					sendNotification(ApplicationFacade.GETYEARCONS,2,event.type);
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [FlerryProxy.YEARCONS, PowerSocket.CURRENTCONS];
		}
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case FlerryProxy.YEARCONS:
					yearGauge.yearG.months   =  setColorYear(new XML(note.getBody()));
					yearGauge.yearG.yearCons = setConsumpArray(new XML(note.getBody()));
					yearGauge.yearG.fillColors();
					break;	 
				
				case PowerSocket.CURRENTCONS:
					yearGauge.yearG.consumo.text =  Math.round(Number(note.getBody())).toString()+" W";
					break;	
				
			}
			 
		}
		
		private function setColorYear(year:XML):Array{
			var result:Array = new Array();
			var xmlhandler:XML_Handlers = new XML_Handlers();
			var maxPowerExpected:int   = ConfigSingleton.getInstance().getMaxPowerMonth();
			var yearCons:XML = xmlhandler.buildYearXML(year);
			var length:int   		 = xmlhandler.calculatesXMLSize(yearCons);
			var resultLength:int;
			var i:int;
			
			for(i=0;i<length;i++){
				var color:Number;
				
				if(yearCons.powerSample[i].@pA==0){
					color = 0xFFFFFF;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.083)){
					color = 0x80BF54;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.166)){
					color = 0xB3CF56;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.249)){
					color = 0xC2CF63;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.35)){
					color = 0xE4D847;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.45)){
					color = 0xE9F43A;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.52)){
					color = 0xF4EB00;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.6)){
					color = 0xF4C339;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.664)){
					color = 0xC9A12F;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*0.747)){
					color = 0xC94E28;
				}
				else if(yearCons.powerSample[i].@pA<(maxPowerExpected*1)){
					color = 0xC9000D;
				}
				else if(yearCons.powerSample[i].@pA>(maxPowerExpected)){
					color = 0x330000;
				}
				
				resultLength = (result.push(color));
				
			}
			
		
			return result;
		}
		
		private function setConsumpArray(year:XML):Array{
			var result:Array = new Array();
			var xmlhandler:XML_Handlers = new XML_Handlers();
			var resultLength:int;
			var i:int;
			var yearCons:XML = xmlhandler.buildYearXML(year);
			var length:int   		 = xmlhandler.calculatesXMLSize(yearCons);
			
			for(i=0;i<length;i++){
				
				var cons:Number = (Math.round(yearCons.powerSample[i].@pA));
				result.push(cons);
				
			}
			return result;
		}
		
		public function get yearGauge():Year_Gauge
		{ 
			return viewComponent as Year_Gauge; 
		}
		
		
	}
}