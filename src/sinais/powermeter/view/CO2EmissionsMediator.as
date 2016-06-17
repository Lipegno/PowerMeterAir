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
	import sinais.powermeter.view.components.CO2Emissions;
	
	public class CO2EmissionsMediator extends Mediator implements IMediator
	{
		public static const NAME:String	= "CO2EmissionsMediator";
		
		public var C02day:String ="";
		public var C02week:String ="";
		public var C02month:String ="";
		public var C02year:String ="";
		
		private var months:Array = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];

		
		public function CO2EmissionsMediator(viewComponent:Object)
		{
			super(NAME,viewComponent)
		}
		
		override public function onRegister( ):void
		{
			emissionsMed.addEventListener(CO2Emissions.GETMONTHCOMP, handleEvent );

 		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
				
				case CO2Emissions.GETMONTHCOMP:
					sendNotification(ApplicationFacade.GETMONTHCOMP, null, event.type );
					break;
			
		}
		}
		
		override public function listNotificationInterests():Array
		{
			return [FlerryProxy.MONTHCOMP, FlerryProxy.DAYCONS, FlerryProxy.MONTHTOTAL, FlerryProxy.DAYCONS, FlerryProxy.YEARCONS, FlerryProxy.WEEKCONS, PowerMeterProxy.CHANGEVIEWHOUR,
				PowerMeterProxy.CHANGEVIEWMONTH, PowerMeterProxy.CHANGEVIEWDAY, PowerMeterProxy.CHANGEVIEWWEEK, PowerMeterProxy.CHANGEVIEWYEAR];
		}
		
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case FlerryProxy.MONTHCOMP:
					roundMonthComp(note.getBody().toString());
					break;	
				
				case FlerryProxy.DAYCONS:
					C02day =  calculateCO2emission(new XML(note.getBody()));
					break;
				
				case FlerryProxy.YEARCONS:
					C02year =  calculateCO2emission(new XML(note.getBody()));
					break;
				
				case FlerryProxy.WEEKCONS:
					C02week =  calculateCO2emission(new XML(note.getBody()));
					break;
				
				case FlerryProxy.MONTHTOTAL:
					C02month =  calculateCO2emission(new XML(note.getBody()));
					break;	
				
				case PowerMeterProxy.CHANGEVIEWDAY:
					updateConsLabels("Day");
					break;
				
				case PowerMeterProxy.CHANGEVIEWYEAR:
					updateConsLabels("Year");
					break;
				
				case PowerMeterProxy.CHANGEVIEWWEEK:
					updateConsLabels("Week");
					break;
				
				case PowerMeterProxy.CHANGEVIEWMONTH:
					updateConsLabels("Month");
					break;
			}
		}
		
		private function roundMonthComp(comp:String):void{
			var ratio:Number = Number(comp);
			if(ratio < 0){
				emissionsMed.sobe.visible	= false;
				emissionsMed.desce.visible	= true;
				emissionsMed.igual.visible	= false;
			} 
			else if(ratio ==0){
				emissionsMed.sobe.visible	= false;
				emissionsMed.desce.visible	= false;
				emissionsMed.igual.visible	= true;
			}
			else if(ratio>0){
				emissionsMed.sobe.visible	= true;
				emissionsMed.desce.visible	= false;
				emissionsMed.igual.visible	= false;
			}
			emissionsMed.percent.text=((Math.round(ratio*100))/100)+"%";
		}
		
		private function calculateCO2emission(data:XML):String{
			var i:int;
			var totalCO2:Number=0;
			var xmlhandler:XML_Handlers = new XML_Handlers();		
			var length:int = xmlhandler.calculatesXMLSize(data);
			var temp:Number=0;
			
			for(i=0;i<length;i++){
			
				temp = data.powerSample[i].@pA
				totalCO2 = totalCO2+temp;
				
			}
			totalCO2=totalCO2/1000;
			return ((Math.round(totalCO2*0.527*100))/100)+"";
		} 
		
		private function updateConsLabels(view:String):void{
			
			switch(view){
				
				case "Day":
					emissionsMed.CO2.text = C02day+" gCO2";
					emissionsMed.id_label.text = "Hoje até ao momento";
					break;
				
				case "Year":
					emissionsMed.CO2.text = C02year+" gCO2";
					emissionsMed.id_label.text= new Date().fullYearUTC+' até ao momento:';
					break;
				
				case "Week":
					emissionsMed.CO2.text = C02week +" gCO2";
					emissionsMed.id_label.text= 'Esta semana até ao momento:';
					break;
				
				case "Month":
					emissionsMed.CO2.text  = C02month+" gCO2";
					emissionsMed.id_label.text = months[new Date().month]+' até ao momento:';
					break;
			}
		}
		
		public function get emissionsMed():CO2Emissions
		{ 
			return viewComponent as CO2Emissions; 
		}
		
		
		
	}
}