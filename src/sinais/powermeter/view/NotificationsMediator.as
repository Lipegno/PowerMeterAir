package sinais.powermeter.view
{
	import flash.events.Event;
	
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	import mx.graphics.Stroke;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sinais.powermeter.proxy.PowerSocket;
	import sinais.powermeter.view.components.Notifications;
	
	public class NotificationsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "NotificationsMediator";
		
		public var unclassifiedEvents:ArrayCollection = new ArrayCollection();
		
		
		public function NotificationsMediator(viewComponent:Object)
		{
			super(NAME,viewComponent);
		}
		
		override public function onRegister( ):void
		{
			//notificationMed.addEventListener(Notifications.CLASSIFICATIONCOMPLETE, handleEvent );
			
		}
		
//		override public function listNotificationInterests():Array
//		{
//			//return [PowerSocket.LASTEVENT];
//		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
				
				case Notifications.CLASSIFICATIONCOMPLETE:
					 uptadeClassificationArray();
					 break;
				
			}
		}
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case PowerSocket.LASTEVENT:
				trace(note.getBody());
				notificationMed.unclassifiedEvents.addItem(new XML(note.getBody()));
				notificationMed.changeNotLabel();

				break;
			}
			
		}
		
		private function uptadeClassificationArray():void{
		
			var i:int;
			
			for(i=0;i<notificationMed.unclassifiedEvents.length;i++){
				
				notificationMed.events.addItem(notificationMed.unclassifiedEvents.getItemAt(i));
			}
			notificationMed.unclassifiedEvents.removeAll();
			notificationMed.series=[];
			notificationMed.actSeries();
			notificationMed.changeNotLabel();
		}
		
		private function actEvents():void{
			
			var ls:LineSeries;
			ls = new LineSeries(); 
			var index:int = notificationMed.unclassifiedEvents.length;
			var data:XML = new XML( notificationMed.unclassifiedEvents.getItemAt(length-1));
			ls.dataProvider = data..pSignature..p;
			var colorhex:String = "0xdd00dd";
			ls.setStyle("lineStroke", new Stroke(Number(colorhex), 3, 2));
			ls.setStyle("form", "curve");
			notificationMed.series.push(ls) ;
			notificationMed.changeNotLabel();
		
		}
		
		public function get notificationMed():Notifications
		{
			return viewComponent as Notifications;
		}
	}
}