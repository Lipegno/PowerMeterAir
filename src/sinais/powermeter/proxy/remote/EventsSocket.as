package sinais.powermeter.proxy.remote
{
	//import controller.EventsSocketController;
	
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import controller.DecisionTreeCalculator; 
	
	import model.ApplicationModel;

	public class EventsSocket
	{
		private var client:Socket;
		private static var appModel:ApplicationModel;
		//private var controller:EventsSocketController;

		public function EventsSocket(addr:String, port:int)
		{
			appModel = ApplicationModel.getInstance();
			//controller = new EventsSocketController();
			
			client = new Socket();
			client.connect(addr, port);
			client.addEventListener(IOErrorEvent.IO_ERROR, onError);
			client.addEventListener(ProgressEvent.SOCKET_DATA, onData);
		
		}
		
		private function onError(e:IOErrorEvent) : void {
			trace("erro: " + e.toString());
		}
		
		private function onData(Event:ProgressEvent) : void {
			while(client.bytesAvailable > 0) {
				handleResponse(client.readUTF());
			}
		}
		
		public function handleResponse(response:String):void {
			var xmlResult:XML = new XML(response);
			var newChild:XML = <cluster>{this.getCluster(xmlResult.deltaPEdge, xmlResult.alphaP, xmlResult.betaP)}</cluster>
			xmlResult.appendChild(newChild);
			newChild = <appliance id=''></appliance>;
			xmlResult.appendChild(newChild);
			newChild = <stored>false</stored>;
			xmlResult.appendChild(newChild);
			if(appModel.events.length < 60)
				appModel.events.addItem(xmlResult);
			else {
				appModel.events.removeItemAt(0);
				appModel.events.addItem(xmlResult);
			}
				
		}
		
		private function getCluster(deltaPMean:Number, alphaP:Number, betaP:Number):int {
			return DecisionTreeCalculator.getCluster(alphaP, betaP, deltaPMean)[1];
		}
		
	}
}