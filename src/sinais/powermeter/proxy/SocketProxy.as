package sinais.powermeter.proxy
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SocketProxy extends org.puremvc.as3.patterns.proxy.Proxy
	{		
		public static const NAME:String 			= "SocketProxy";

		public static const SOCKETRESULT:String  	= NAME+"/notes/queryresult";
		
		private pSocket:PowerSocket;
		public var item:XML;

		public function SocketProxy()
		{
			initSocket();
			super(NAME);
		}
		
		private function initSocket():void{
			pSocket = new PowerSocket("127.0.0.1", 7112);		
		}
		
	}
}