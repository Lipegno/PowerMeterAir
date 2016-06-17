package sinais.powermeter.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	import sinais.powermeter.proxy.StepGreenProxy;

	public class HandleSGGoals extends SimpleCommand
	{
		public function HandleSGGoals()
		{
		var sg_proxy:StepGreenProxy = (StepGreenProxy)(facade.retrieveProxy(StepGreenProxy.NAME));
			if(ConfigSingleton.getInstance().getStepGreenGoals()==null){
				sg_proxy.refreshAcctions();
			}
			else{
				sg_proxy.refreshAcctions();
			}
		}
	}
}