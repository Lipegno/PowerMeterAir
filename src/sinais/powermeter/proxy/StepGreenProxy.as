package sinais.powermeter.proxy
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import sinais.powermeter.proxy.stepgreen.*;
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	public class StepGreenProxy extends org.puremvc.as3.patterns.proxy.Proxy
	{
		public static const NAME:String = "STEPGREENPROXY";
		public static const SG_ACTIONS:String	  	= NAME+"/notes/stepGreenActions";
		public var sg_wrapper:StepGreenClientWrapper;
		public var state:int = 0;
		
		public function StepGreenProxy()
		{
			sg_wrapper = new StepGreenClientWrapper();
			sg_wrapper.addEventListener("actions",handle_stepGreenData);
			trace("criei proxy");
			super(NAME);
		}
		
		public function refreshAcctions():void{
			if(state==0){
				sg_wrapper.getOAuthAuthorization();
				state++;
			}
			else{
				if(state==1){
				sg_wrapper.getAccessToken();
				state++;
				}else{
					sg_wrapper.getUsersActions();
				}
				
			}
		}
		
		public function getActions():void{
			sendNotification(SG_ACTIONS,ConfigSingleton.getInstance().getStepGreenGoals().toXMLString());
		}
		
		public function handle_stepGreenData(evt:StepGreenDataEvent):void{
			sendNotification( SG_ACTIONS, evt.data);
		}
	}
}