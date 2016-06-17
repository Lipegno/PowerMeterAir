package sinais.powermeter.proxy
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.net.XMLSocket;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sinais.powermeter.handlersObjects.DecisionTreeCalculator;
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	//import model.ApplicationModel;
	
	public class PowerSocket extends org.puremvc.as3.patterns.proxy.Proxy
	{
		private var client:Socket;
		private var clientEvents:XMLSocket;
		private var requestReplysoketport:int;
		private var streamingsocketport:int;
		//private static var appModel:ApplicationModel;
		public var item:XML;
		
		public static const NAME:String 	    = "PowerSocket";
		public static const CURRENTCONS:String 	= "CURRENTCONS";
		public static const LASTEVENT:String    = "LASTEVENT";

		public function PowerSocket(addr:String, port:int)
		{
			
			trace("power socket created")
			requestReplysoketport = ConfigSingleton.getInstance().getrequestReplySocketPort();
			streamingsocketport   = ConfigSingleton.getInstance().getstreamingSocketPort();
			client 		 = new Socket();
			clientEvents = new XMLSocket();
			client.connect("127.0.0.1", requestReplysoketport);
			clientEvents.connect("127.0.0.1", streamingsocketport);
			clientEvents.addEventListener(IOErrorEvent.IO_ERROR, onsocketError);
			client.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			
			clientEvents.addEventListener(DataEvent.DATA, onEventData);

			client.addEventListener(IOErrorEvent.IO_ERROR, onsocketError);

			super(NAME);

		}
		
		public function onsocketError(evt:IOErrorEvent):void{
		
			trace(evt);
		
		}
		public function sendData(request:String,addr:String) : void {
			trace("aqui");
			client.connect(addr, requestReplysoketport);
			client.writeUTF(request);
			client.flush();
		}
 
		private function onEventData(event:DataEvent):void{

		var xmlData:XML = new XML(event.data);
		trace(xmlData.timestamp+" "+xmlData.deltaPMean+"-"+DecisionTreeCalculator.getCluster(xmlData.alphaP, xmlData.betaP, xmlData.deltaPMean)[1]);
//		var resultXML:XML = new XML('<data>'+
//									'<timestamp>'+xmlData.timestamp+'</timestamp>'+
//									'<deltaPMean>'+xmlData.deltaPMean+'</deltaPMean>'+
//									'<cluster>'+DecisionTreeCalculator.getCluster(xmlData.alphaP, xmlData.betaP, xmlData.deltaPMean)[1]+'</cluster>'+
//									'</data>');
		
		if(Math.abs(xmlData.deltaPMean)>20)
		sendNotification(LASTEVENT,xmlData);
		}
		
		
		
		private function onData(event:ProgressEvent) : void {
			var xmlResult:XML = new XML(client.readUTF());			
			client.close();
			sendNotification( CURRENTCONS,xmlResult.result[0].children());
		}
		
		private function closeHandler(event:Event):void {
			trace("Connection closed: " + event);


		}
		
	}
	
}