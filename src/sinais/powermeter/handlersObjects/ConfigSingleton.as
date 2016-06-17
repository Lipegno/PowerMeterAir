package sinais.powermeter.handlersObjects
{
	public class ConfigSingleton
	{
		
		private static var instance:ConfigSingleton;
		private static var allowInstantiation:Boolean;
		
		private  var maxPowerExpected5min:int;
		private  var maxPowerExpectedHour:int;
		private  var maxPowerExpectedDay:int;
		private  var maxPowerExpectedMonth:int;
		private  var pathToGoalsBD:String;
		private  var pathToBD:String;
		private  var installationid:int;
		private  var streamingSocketPort:int;
		private  var requestReplySocketPort:int;
		private  var maxEventRadius:int;
		private  var eventGap:Number;
		private var _maxEvent:Number;
		private  var houseHoldInfo:XML;
		private  var stepGreenGoals:XML;
		private  var appliances:XML;
		private  var _soundEnabled:Boolean;
		private  var _historicalSound:Boolean; 
		private  var _soundAmp:int;

		public function get soundAmp():int
		{
			return _soundAmp;
		}

		public function set soundAmp(value:int):void
		{
			_soundAmp = value;
		}

		public function get historicalSound():Boolean
		{
			return _historicalSound;
		}

		public function set historicalSound(value:Boolean):void
		{
			_historicalSound = value;
		}

		public function get soundEnabled():Boolean
		{
			return _soundEnabled;
		}

		public function set soundEnabled(value:Boolean):void
		{
			_soundEnabled = value;
		}

		public static function getInstance():ConfigSingleton {
			if (instance == null) {
				allowInstantiation = true;
				instance = new ConfigSingleton();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function ConfigSingleton():void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
			}
		}
		
		public function setMaxPower5m(power:int):void{
		
			this.maxPowerExpected5min=power;
			
		}
		
		public function getMaxPower5m():int{
		
			return this.maxPowerExpected5min;
			
		}
		
		public function setMaxPowerHour(power:int):void{
			
			this.maxPowerExpectedHour=power;
			
		}
		
		public function getMaxPowerHour():int{
			
			return this.maxPowerExpectedHour;
			
		}
		
		public function setMaxPowerDay(power:int):void{
			
			this.maxPowerExpectedDay=power;
			
		}
		
		public function getMaxPowerDay():int{
			
			return this.maxPowerExpectedDay;
			
		}

		public function setMaxPowerMonth(power:int):void{
			
			this.maxPowerExpectedMonth=power;
			
		}
		
		public function getMaxPowerMonth():int{
			
			return this.maxPowerExpectedMonth;
			
		}

		
		public function setpathToBD(value:String):void{
			
			this.pathToBD=value;
			
		}
		
		public function getpathToBD():String{
			
			return this.pathToBD;
			
		}
		public function setinstallationid(value:int):void{
			
			this.installationid=value;
			
		}
		
		public function getinstallationid():int{
			
			return this.installationid;
			
		}
		
		public function setpathToGoalsBD(value:String):void{
			
			this.pathToGoalsBD=value;
			
		}
		
		public function getpathToGoalsBD():String{
			
			return this.pathToGoalsBD;
			
		}
		
		public function setHouseHoldInfo(data:XML):void{
			this.houseHoldInfo=data;
		}
		
		public function getHouseHoldInfo():XML{
			return this.houseHoldInfo;
		}
		
		public function setStepGreenGoals(data:XML):void{
			this.stepGreenGoals=data;
		}
		
		public function getStepGreenGoals():XML{
			return this.stepGreenGoals;
		}
		
		public function setAppliances(data:XML):void{
			this.appliances=data;
		}
		
		public function getAppliances():XML{
			return this.appliances;
		}
		
		public function setstreamingSocketPort(port:int):void{
			this.streamingSocketPort=port;
		}
		
		public function getstreamingSocketPort():int{
			return this.streamingSocketPort;
		}
		
		public function setrequestReplySocketPort(port:int):void{
			this.requestReplySocketPort=port;
		}
		
		public function getrequestReplySocketPort():int{
			return this.requestReplySocketPort;
		}
		
		public function setmaxEventRadius(radius:int):void{
			this.maxEventRadius=radius;
		}
		
		public function getmaxEventRadius():int{
			return this.maxEventRadius;
		}
		
		public function setEventGap(value:Number):void{
			this.eventGap=value;
		}
		
		public function getEventGap():Number{
			return this.eventGap;
		}

		public function get maxEvent():Number
		{
			return _maxEvent;
		}

		public function set maxEvent(value:Number):void
		{
			_maxEvent = value;
		}

		
	}
	
}