package sinais.powermeter.proxy
{
	import fl.motion.Motion;
	import fl.motion.MotionEvent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sinais.powermeter.motion_detection.MotionEvent;
	import sinais.powermeter.motion_detection.MotionTrackerDemo;
	
	public class MotionDetectorProxy extends org.puremvc.as3.patterns.proxy.Proxy
	{
		public static const NAME:String 			= "MotionDetectorProxy";

		public static const MOTIONEVT:String  		    = NAME+"/notes/motionevt";
		
		private var motionDetector:MotionTrackerDemo;
		
		public function MotionDetectorProxy()
		{
			super(NAME);
			initMotionDetector();
		}
		
		private function initMotionDetector():void{
		
			motionDetector = new MotionTrackerDemo();
			motionDetector.initTracking();
			motionDetector.addEventListener("motion",_motionEventHandler);	
			trace("init Motion Detector");
		}
		
		private function _motionEventHandler(event:sinais.powermeter.motion_detection.MotionEvent):void{
			sendNotification( MOTIONEVT, event.type );
		}
	}
}


//SIMEAS P50 7kG7750