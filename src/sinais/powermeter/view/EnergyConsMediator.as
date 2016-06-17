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
	import sinais.powermeter.handlersObjects.WeekHandler;
	import sinais.powermeter.handlersObjects.XML_Handlers;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.view.components.EnergyCons;
	
	public class EnergyConsMediator extends Mediator implements IMediator
	{
		public static const NAME:String	= "EnergyConsMediator";
		
		public var dayTotalCons:Number;
		public var yearTotalCons:Number;
		public var monthTotalCons:Number;
		public var weekTotalCons:Number;
		
		private var months:Array = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];

		public function EnergyConsMediator( viewComponent:Object)
		{
			super(NAME,viewComponent);
		}
		
		override public function onRegister( ):void
		{
			energyCons.addEventListener(EnergyCons.GETMONTHTOTAL, handleEvent );
		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
				case EnergyCons.GETMONTHTOTAL:
					sendNotification (ApplicationFacade.GETMONTHTOTAL, null, event.type );
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [FlerryProxy.MONTHTOTAL, FlerryProxy.DAYCONS, FlerryProxy.YEARCONS, FlerryProxy.WEEKCONS,
				PowerMeterProxy.CHANGEVIEWDAY, PowerMeterProxy.CHANGEVIEWHOUR,
				PowerMeterProxy.CHANGEVIEWMONTH, PowerMeterProxy.CHANGEVIEWWEEK, PowerMeterProxy.CHANGEVIEWYEAR];
		}
		
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case FlerryProxy.MONTHTOTAL:
					calculateMonthEnergy(new XML(note.getBody()));
					break;	
				
				case FlerryProxy.DAYCONS:
					calculateDayEnergy(new XML(note.getBody()));
					break;
				
				case FlerryProxy.YEARCONS:
				    calculateYearEnergy(new XML(note.getBody()));
					break;
				
				case FlerryProxy.WEEKCONS:
					calculateWeekEnergy(new XML(note.getBody()));
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
		
		private function calculateMonthEnergy(data:XML):void{
			var i:int=0;
			var totalEnergy:Number=0.0;
			while(data.powerSample[i]!=null){
				totalEnergy = totalEnergy+Number(data.powerSample[i].@pA)/1000;
				i++;
			}
			monthTotalCons=totalEnergy;
		}
		
		private function calculateDayEnergy(data:XML):void{
		
			var i:int=0;
			var totalEnergy:Number=0.0;
			while(data.powerSample[i]!=null){
				totalEnergy = totalEnergy+Number(data.powerSample[i].@pA)/1000;
				i++;
			}
			dayTotalCons=totalEnergy;
			energyCons.consumo.text = Math.round(dayTotalCons)+" KWh";
			energyCons.preco.text	= (Math.round(dayTotalCons*0.09*100))/100+" €";
			energyCons.id_label.text= 'Hoje ate ao momento:';
		}
		
		private function calculateYearEnergy(data:XML):void{
			
			var i:int=0;
			var totalEnergy:Number=0.0;
			while(data.powerSample[i]!=null){
				totalEnergy = totalEnergy+Number(data.powerSample[i].@pA)/1000;
				i++;
			}
			yearTotalCons=totalEnergy;
		
		}
		
		private function calculateWeekEnergy(data:XML):void{
			var i:int=0;
			var totalEnergy:Number=0.0;
			while(data.powerSample[i]!=null){
				totalEnergy = totalEnergy+Number(data.powerSample[i].@pA)/1000;
				i++;
			}
			
			weekTotalCons=totalEnergy;
		}
		
		private function updateConsLabels(view:String):void{
		
			switch(view){
			
				case "Day":
					energyCons.consumo.text = Math.round(dayTotalCons)+" KWh";
					energyCons.preco.text	= (Math.round(dayTotalCons*0.09*100))/100+" €";
					energyCons.id_label.text= 'Hoje até ao momento:';
					break;
				
				case "Year":
					energyCons.consumo.text = Math.round(yearTotalCons)+" KWh";
					energyCons.preco.text	= (Math.round(yearTotalCons*0.09*100))/100+" €";
					energyCons.id_label.text= new Date().fullYearUTC+' até ao momento:';
					break;
				
				case "Week":
					energyCons.consumo.text = Math.round(weekTotalCons)+" KWh";
					energyCons.preco.text	= (Math.round(weekTotalCons*0.09*100))/100+" €";
					energyCons.id_label.text= 'Esta semana até ao momento:';
					break;
				
				case "Month":
					energyCons.consumo.text  = Math.round(monthTotalCons)+" KWh";
					energyCons.preco.text	 = (Math.round(monthTotalCons*0.09*100))/100+" €";
					energyCons.id_label.text = months[new Date().month]+' até ao momento:';
					break;
			}
		}
		
		public function get energyCons():EnergyCons
		{ 
			return viewComponent as EnergyCons; 
		}
		
	}
	
}