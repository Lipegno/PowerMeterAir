package sinais.powermeter.proxy
{
	import flash.net.Socket;
	
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	
	public class ClassificationSocketProxy extends org.puremvc.as3.patterns.proxy.Proxy
	{
		private var client:Socket;
		//private static var appModel:ApplicationModel;
		public var item:XML;
		public var appliance:XML;
		private var port:int;
		public static const NAME:String="Classification proxy";
		
		
		public function ClassificationSocketProxy() {
			super(NAME);
			client = new Socket();
			port = ConfigSingleton.getInstance().getrequestReplySocketPort();
			sendData("loadAppliances");
		}
		
		public function sendData(request:String) : void {
			
			client.connect("127.0.0.1", port);
			client.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			client.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
 			client.writeUTF(request);
			client.flush();
		}
		
		private function onIOError(event:IOErrorEvent) : void {
			mx.controls.Alert.show(event.toString(), "Request / Reply Socket");
		}
		
		private function onData(event:ProgressEvent) : void {
			var res:String = client.readUTF();
			var xmlResult:XML = new XML(res);
			var request:String = xmlResult.@request;
			var result:String = xmlResult.result;
			
			if(request == "loadAppliances") {
				
				ConfigSingleton.getInstance().setAppliances(new XML(xmlResult.child("appliances")));	
			}
			if(request == "insert-and-update") {
				//this.item.appliance.@id = xmlResult.result.@appliance_id;
				//this.item.classified = result;
				// get the last index of the appliances and changes it's id attribute
				//appModel.appliances.children()[appModel.appliances.children().length() - 1].@id = xmlResult.result.@appliance_id;
				//this.appliance.@id = xmlResult.result.@appliance_id;
				trace(xmlResult.result);
			}
			if(request == "update") {
				trace(request);
				trace(xmlResult.result);
				//this.item.classified = result;
			}
			if(request == "reset") {
				if(result == "true")
					trace("classified");
			}
			
		}
	}
}