package sinais.powermeter.proxy
{
	import flash.events.TimerEvent;
	import flash.utils.Proxy;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class PowerMeterProxy extends org.puremvc.as3.patterns.proxy.Proxy
	{
		public static const NAME:String 	       = "PowerMeterProxy";
		public static const QUERY:String	       = NAME+"/notes/query";
		public static const CHANGEVIEWDAY:String   = "day_view";
		public static const CHANGEVIEWHOUR:String  = "hour_view";
		public static const CHANGEVIEWWEEK:String  = "week_view";
		public static const CHANGEVIEWMONTH:String = "month_view";
		public static const CHANGEVIEWYEAR:String  = "year_view";

		public function PowerMeterProxy()
		{
			super(NAME);
		}
		
		public function executeQuery():void{
			sendNotification( QUERY, "Sucsess" );
		}
		
		public function changeView(view:String):void{
			sendNotification(view);			
		}
	}
}