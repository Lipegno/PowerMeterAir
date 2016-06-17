package sinais.powermeter.view
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.facade.*;
	import org.puremvc.as3.patterns.mediator.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.*;
	
	import sinais.powermeter.ApplicationFacade;
	import sinais.powermeter.handlersObjects.XML_Handlers;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.view.components.Week_gauge;
	import sinais.powermeter.proxy.PowerSocket;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	
	public class WeekGaugeMediator extends Mediator implements IMediator
	{
		public static const NAME:String	= "WeekGaugeMediator";

		public function WeekGaugeMediator(viewComponent:Object)
		{				
			super(NAME,viewComponent);
		}
		
		override public function onRegister( ):void
		{
			weekGauge.addEventListener(Week_gauge.MONTHSCONS, handleEvent );
			weekGauge.addEventListener(Week_gauge.MONTHSCONS_STARTUP, handleEvent );

		}
		
		override public function listNotificationInterests():Array
		{
			return [FlerryProxy.MONTHBYDAY, PowerSocket.CURRENTCONS];
		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
			
				case Week_gauge.MONTHSCONS:
					sendNotification (ApplicationFacade.GETMONTHSCONS, 1, event.type );
					break;
				
				case Week_gauge.MONTHSCONS_STARTUP:
					sendNotification(ApplicationFacade.GETMONTHSCONS,2,event.type);
					break;
			}
		}
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case FlerryProxy.MONTHBYDAY:
					 weekGauge.wg.days = setColorsMonth(new XML(note.getBody()));
					 weekGauge.wg.fillColors();
					 weekGauge.wg.consump = setConsumpArray(new XML(note.getBody()));
					 break;	
				
				case PowerSocket.CURRENTCONS:
					 weekGauge.wg.consumo.text =  Math.round(Number(note.getBody())).toString()+" W";
					 break;	

				
			}
			
		}
		
		public function setColorsMonth(monthCons:XML):Array{
		
			var maxPowerExpected:int = ConfigSingleton.getInstance().getMaxPowerDay();
			var result:Array 		 = new Array();
			var xmlhandler:XML_Handlers = new XML_Handlers();
			var resultLength:int;
			var i:int;
			var dayCons:XML =  xmlhandler.buildMonthXML(monthCons);
			weekGauge.monthCons = dayCons;    // passa o valor para lá podia ter sido feito em cima mas para não ter de construir o XML outra vez 
			var length:int   		 = xmlhandler.calculatesXMLSize(dayCons);  // faço aqui
			
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
			var monthCons:XML = xmlhandler.buildMonthXML(dayCons);
			var length:int   		 = xmlhandler.calculatesXMLSize(monthCons);
			 var test:Number = 0;
			for(i=0;i<length;i++){
				
				var cons:Number = (Math.round(monthCons.powerSample[i].@pA));
			
				result.push(cons);
				
			}
			trace(test);
			return result;
			
		}
		
		public function get weekGauge():Week_gauge
		{ 
			return viewComponent as Week_gauge; 
		}
	}
}