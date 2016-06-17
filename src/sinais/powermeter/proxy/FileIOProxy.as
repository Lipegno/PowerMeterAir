package sinais.powermeter.proxy
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	
	public class FileIOProxy extends org.puremvc.as3.patterns.proxy.Proxy
	{
		public static const RECOMEND:String	  	= NAME+"/notes/recomendations";
		public static const NAME:String 			= "FileIOProxy";
	
		public var myFile:File;
		public var xmlSettings:File;
		
		public function FileIOProxy(filepath:String)
		{	
		 // this.myFile= File.desktopDirectory.resolvePath(filepath);
		 this.myFile= File.applicationDirectory.resolvePath(filepath);
			
			super(NAME);
		}
		
		public function getRecomendations():void{
			
			var fileStream:FileStream = new FileStream(); // Create our file stream
			fileStream.open(myFile, FileMode.READ);
			var fileContents:String = fileStream.readUTFBytes(fileStream.bytesAvailable); // Read the contens of the 
			fileStream.close();
			
			////// TIRAR UMA FRASE AO CALHAS DO CONJUNTO
			var index:int = Math.round(Math.random()*12);			
			sendNotification( RECOMEND, fileContents.split('.')[index]);
		}
		
		public function readConfigurations():void{

			var file:File = File.applicationDirectory.resolvePath("config.xml");

			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var configData:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			
			ConfigSingleton.getInstance().setpathToBD(configData.pathToBD[0].@value);
			ConfigSingleton.getInstance().setpathToGoalsBD(configData.pathToGoalsBD[0].@value)
			ConfigSingleton.getInstance().setMaxPower5m(configData.maxPowerExpected5min[0].@value);
			ConfigSingleton.getInstance().setMaxPowerHour(configData.maxPowerExpectedHour[0].@value);
			ConfigSingleton.getInstance().setMaxPowerDay(configData.maxPowerExpectedDay[0].@value);
			ConfigSingleton.getInstance().setMaxPowerMonth(configData.maxPowerExpectedMonth[0].@value);
			ConfigSingleton.getInstance().setrequestReplySocketPort(configData.requestreplySocletPort[0].@value);
			ConfigSingleton.getInstance().setstreamingSocketPort(configData.streamingSocketPort[0].@value);
			ConfigSingleton.getInstance().setmaxEventRadius(configData.maxEventRadius[0].@value);
			ConfigSingleton.getInstance().setEventGap(configData.eventsGap[0].@value);
			ConfigSingleton.getInstance().soundEnabled=(configData.soundEnabled[0].@value=="true");
			ConfigSingleton.getInstance().historicalSound=(configData.historicalSound[0].@value=="true");
			ConfigSingleton.getInstance().soundAmp=(configData.soundAmp[0].@value);
			ConfigSingleton.getInstance().maxEvent=(configData.maxEvent[0].@value);
			fileStream.close();
			
			trace("* 	SYSTEM SETTINGS 	*");
			trace("");
			trace("path to bd "+ConfigSingleton.getInstance().getpathToBD());
			trace("path to goals bd "+ConfigSingleton.getInstance().getpathToGoalsBD());
			trace("max power expected 5m "+ConfigSingleton.getInstance().getMaxPower5m());
			trace("max power expected 1h "+ConfigSingleton.getInstance().getMaxPowerHour());
			trace("max power expected one day "+ConfigSingleton.getInstance().getMaxPowerDay());
			trace("max power expected one month "+ConfigSingleton.getInstance().getMaxPowerMonth());
			trace("requests reply socket port "+ConfigSingleton.getInstance().getrequestReplySocketPort());
			trace("streaming socket port "+ConfigSingleton.getInstance().getstreamingSocketPort());
			trace("max event radius "+ConfigSingleton.getInstance().getmaxEventRadius());
			trace("max event detected: "+ConfigSingleton.getInstance().maxEvent);
			trace("event gap "+ConfigSingleton.getInstance().getEventGap());
			trace("Sound enabled: "+ ConfigSingleton.getInstance().soundEnabled);
			trace("historic sound comp: "+ConfigSingleton.getInstance().historicalSound);
			trace("sound amp: "+ConfigSingleton.getInstance().soundAmp);
			trace("");
			trace("***************************");

		}
		
		public function readHouseHoldInfo():void{
			var test:Array = File.getRootDirectories();
			var file:File = File.getRootDirectories()[0].resolvePath("\My Dropbox\\houseHoldTESTE.xml");
		//	var file:File = File.userDirectory.resolvePath("Dropbox/houseHoldTESTE.xml");
		//	var file:File = File.desktopDirectory.resolvePath("houseHoldTESTE.xml");

			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file, FileMode.READ);
			var houseInfo:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			ConfigSingleton.getInstance().setHouseHoldInfo(houseInfo);
			fileStream.close();
			
		}
		
		public function readStepGreenGoals():void{
		//	var file:File = File.applicationDirectory.resolvePath("stepGreenGoals.xml");
			var file:File = File.applicationStorageDirectory.resolvePath("stepGreenGoals.xml");
			
			if(file.exists){
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var stepGreenGoals:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				ConfigSingleton.getInstance().setStepGreenGoals(stepGreenGoals);
				fileStream.close();
				trace("step green goals loaded");
			}
		}
		
		protected function file_error_handler(evt:Event):void{
			trace(evt);
		}
		
	
		
	}
}