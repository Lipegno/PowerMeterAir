package sinais.powermeter.proxy.stepgreen
{
	//import StepGreenDataEvent.*;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.stepgreen.accesscontrol.*;
	import org.stepgreen.accesscontrol.events.*;
	import org.stepgreen.accesscontrol.utils.ApiService;
	
	public class StepGreenClientWrapper extends EventDispatcher
	{
		private static const CONSUMER_KEY:String = "wUofrX4ymeUE3GiOHrCh";
		private static const CONSUMER_SECRET:String = "p3U3SfDXtXjIl36m8k0gNxEgQNORn78VWgJVfsuq";
		private var _consumer:OAuthConsumer;
		private var _userInfo:Timer = new Timer(500);

		
		public function StepGreenClientWrapper(){
			Utils.SITE='sinais';
			_consumer = new OAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
		}
		
		public function getOAuthAuthorization():void{
			if(_consumer.recallAccessToken()){
				trace( "Access Token recalled");
				
			}else{
				trace( "Cant find a saved Access Token... ask user to authorize" );
				_consumer.authorize();
			}
			//_userInfo.addEventListener(TimerEvent.TIMER, getAccessToken);
			//_userInfo.start();
		}
		
		public function getAccessToken():void{
			trace("aqui token");
			_consumer.addEventListener(AccessTokenEvent.GRANTED, accessTokenGranted);
			_consumer.addEventListener(AccessTokenEvent.DENIED, accessTokenDenied);				
			_consumer.addEventListener(AccessTokenEvent.FAULT, accessTokenFault);
			_consumer.getAccessToken();

		}
		
		public function accessTokenGranted(event:AccessTokenEvent):void{
			trace("AccessTokenGranted");
			//Alert.show("AccessTokenGranted","AccessTokenGranted");

			getUsersActions();
		}
		
		
		public function accessTokenDenied(event:AccessTokenEvent):void{
			trace("AccessTokenDenied");
			Alert.show("AccessTokenDenied","AccessTokenDenied");
		}
		
		public function accessTokenFault(event:AccessTokenEvent):void{
			trace("accessTokenFault");
		}
		
		
		public function postOAuthComment_Click(event:MouseEvent):void{
			postOAuthComment("test");
		}
		
		public function postOAuthComment(comment:String):void{
			var new_comment:String;
			new_comment = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><user_comment>Testing this Flex Client - OAuth post (SINAIS) Thanks Robert</user_comment>";
			var api_url:String = "actions/1/comments";
			var apiCall:ApiService = _consumer.postAPI(api_url, null, new_comment );
			apiCall.addEventListener(ResultEvent.RESULT, postOAuthCommentResult);
			
			apiCall.addEventListener(FaultEvent.FAULT, postOAuthCommentFault);
			apiCall.send();			
		}
		
		public function postOAuthCommentResult(event:ResultEvent):void{
			trace("postOAuthCommentResult(): \n\n" + event.result);
		}
		
		public function postOAuthCommentFault(event:FaultEvent):void{
			trace("postOAuthCommentFault(): " + event.fault.message);
			trace("postOAuthCommentFault() message: " + event.toString);
			trace("postOAuthCommentFault() statusCode: " + event.statusCode);
			if( event.statusCode == 401 ){
				// access denied. need to re-get credentials
			}else{
				// some other fault
			}
		}
		
		public function getUsersActions():void{
			//Alert.show("get commitment","get commitment");
			
			var api_url:String = "users/" + _consumer.userId+"/user_actions";
			var apiCall:ApiService = _consumer.getAPI(api_url);
			apiCall.addEventListener(ResultEvent.RESULT, getUserActionsResultHandler);
			apiCall.addEventListener(FaultEvent.FAULT, getUsersActionsFaultHandler);
			apiCall.send();		
		}
		
		public function getUserActionsResultHandler(event:ResultEvent):void{
			trace("getOAuthCommitment(): \n\n"+event.result);
			var xmlNode:XML = new XML(event.result);	
			var outputFile:File = File.applicationStorageDirectory.resolvePath("stepGreenGoals.xml");
			//Alert.show(outputFile.nativePath+"",outputFile.nativePath+"");
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += xmlNode.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			var outputStream:FileStream = new FileStream();
			outputStream.open(outputFile, FileMode.WRITE);
			outputStream.writeUTFBytes(outputString);
			outputStream.close();
			//handles the data and sends it to the mediator
			var returnEvt:StepGreenDataEvent = new StepGreenDataEvent("actions",xmlNode.toXMLString(),true,false);
			this.dispatchEvent(returnEvt);
		}
		
		public function getUsersActionsFaultHandler(event:FaultEvent):void{
			trace("getOAuthCommitmentFault():\n\n"+event.fault.message);
		}
	}
}