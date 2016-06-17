package sinais.powermeter.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.facade.*;
	import org.puremvc.as3.patterns.mediator.*;
	import org.puremvc.as3.patterns.observer.*;
	
	import sinais.powermeter.ApplicationFacade;
	import sinais.powermeter.controller.HandlesGoalsInterfaceChange;
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	import sinais.powermeter.handlersObjects.XML_Handlers;
	import sinais.powermeter.proxy.FlerryProxy;
	import sinais.powermeter.proxy.PowerMeterProxy;
	import sinais.powermeter.proxy.PowerSocket;
	import sinais.powermeter.proxy.StepGreenProxy;
	import sinais.powermeter.view.components.GoalEvent;
	import sinais.powermeter.view.components.GoalsStatus;
	import sinais.powermeter.view.components.StepGreenGoalsBox;
	import sinais.powermeter.view.components.ratting_components.rateGoalsComponent;
	
	public class GoalsMediator extends Mediator implements IMediator
	{
		public static const NAME:String	= "GoalsMediator";
		public static const CHANGEVIEWGOALS:String  = "goals_view";
		public static const STARTUPCOMPLETE:String ="startup_complete";
		
		public function GoalsMediator(viewComponent:Object)
		{
			super(NAME,viewComponent)

		}
		
		override public function onRegister( ):void
		{
			goalsComponent.addEventListener(GoalsStatus.GETMOREINFO, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.GETDAYSGOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.GETWEEKSGOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.GETMONTHGOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.ADDMONTHGOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.ADDWEEKSGOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.ADDDAYSGOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.REMOVEGOALDAY, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.REMOVEGOALWEEK, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.REMOVEGOALMONTH, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.GET_SG_GOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.ASK_SG_GOALS, handleEvent );
			goalsComponent.addEventListener(GoalsStatus.STARTUPCOMPLETE,handleEvent);

			goalsComponent.addEventListener(GoalsStatus.VOTING_MINUS, handleVote);
			goalsComponent.addEventListener(GoalsStatus.VOTING_PLUS, handleVote);
			goalsComponent.addEventListener(GoalsStatus.GETDAYS_VOTES, handleVote);
			
		}
		
			
		override public function listNotificationInterests():Array
		{
			return [HandlesGoalsInterfaceChange.INTERFACE_CHANGED,PowerSocket.CURRENTCONS,FlerryProxy.DAYCONS,
				PowerMeterProxy.CHANGEVIEWDAY, PowerMeterProxy.CHANGEVIEWHOUR, PowerMeterProxy.CHANGEVIEWMONTH
				,PowerMeterProxy.CHANGEVIEWWEEK, PowerMeterProxy.CHANGEVIEWWEEK, PowerMeterProxy.CHANGEVIEWYEAR
				,FlerryProxy.DAYSGOALS, FlerryProxy.WEEKSGOALS,FlerryProxy.MONTHGOALS, StepGreenProxy.SG_ACTIONS
				,FlerryProxy.VOTERESULTS, FlerryProxy.STARTUPCOMPLETE];
		}
		
		override public function handleNotification(note:INotification):void{
			
			switch ( note.getName() )
			{
				case HandlesGoalsInterfaceChange.INTERFACE_CHANGED:
					goalsComponent.currentState="detailedState";
					sendNotification("goals_view");
					break;
				
				case PowerSocket.CURRENTCONS:
					goalsComponent.currentCons= Math.round(Number(note.getBody())).toString()+" W";
					//var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
					//proxy.getVotes();
					break;	
			
				case FlerryProxy.DAYCONS:
					calculateDaytotal(new XML(note.getBody()));
					break;
				
				case FlerryProxy.DAYSGOALS:
					handleDGoals(new XML(note.getBody()));
					break;
				
				case FlerryProxy.WEEKSGOALS:
					handleWGoals(new XML(note.getBody()));
					break;
				
				case FlerryProxy.MONTHGOALS:
					handleMGoals(new XML(note.getBody()));
					break;
				
				case FlerryProxy.VOTERESULTS:
					handleVoting(new XML(note.getBody()));
					break;
				
				case StepGreenProxy.SG_ACTIONS:
					handleActions(new XML(note.getBody()));
					break;
				
				case FlerryProxy.STARTUPCOMPLETE:
					goalsComponent.starDummy();
					break;
				
				default:
					goalsComponent.currentState="initState";
					break;
			}
		}
		
		private function handleEvent( event:Event ):void
		{
			switch ( event.type ) 
			{
				
				case GoalsStatus.GETMOREINFO:
					sendNotification (ApplicationFacade.GOALSINTERFACECHANGE, GoalsStatus.GETMOREINFO, event.type );
					break;
				
				case GoalsStatus.GETDAYSGOALS:
					sendNotification(ApplicationFacade.GETGOALSINFO,0,event.type);
					break;
				
				case GoalsStatus.GETWEEKSGOALS:
					sendNotification(ApplicationFacade.GETGOALSINFO,1,event.type);
					break;
				
				case GoalsStatus.GETMONTHGOALS:
					sendNotification(ApplicationFacade.GETGOALSINFO,2,event.type);
					break;
				
				case GoalsStatus.ADDDAYSGOALS:
					sendNotification(ApplicationFacade.INSERTGOAL, 0,GoalEvent(event).data);
					break;
				
				case GoalsStatus.ADDWEEKSGOALS:
					sendNotification(ApplicationFacade.INSERTGOAL, 1,GoalEvent(event).data);
					break;
				
				case GoalsStatus.ADDMONTHGOALS:
					sendNotification(ApplicationFacade.INSERTGOAL, 2,GoalEvent(event).data);
					break;
				
				case GoalsStatus.REMOVEGOALDAY:
					sendNotification(ApplicationFacade.REMOVEGOAL,0,GoalEvent(event).data);
					break;
				
				case GoalsStatus.REMOVEGOALWEEK:
					sendNotification(ApplicationFacade.REMOVEGOAL,1,GoalEvent(event).data);
					break;
				
				case GoalsStatus.REMOVEGOALMONTH:
					sendNotification(ApplicationFacade.REMOVEGOAL,2,GoalEvent(event).data);
					break;
				
				case GoalsStatus.GET_SG_GOALS:
					sendNotification(ApplicationFacade.GET_SG_GOALS,null,event.type);
					break;
								
				case GoalsStatus.ASK_SG_GOALS:
					checkGoalsStatus();
					break;
				
				case GoalsStatus.STARTUPCOMPLETE:
					sendNotification(STARTUPCOMPLETE,null,null);
					sendNotification(ApplicationFacade.STARTUP_POWERSOCKET,null,null);
					break;
			}
		}
		
		private function handleVote(event:GoalEvent):void{
		
			var proxy:FlerryProxy = FlerryProxy( facade.retrieveProxy( FlerryProxy.NAME ) );
			var goal:String;
			var role:String;
			switch(event.type){
				
				case GoalsStatus.VOTING_PLUS:
					goal = event.data.split("/")[1];
					role = event.data.split("/")[0];		
					proxy.insertVoting(goal,role,1);
					break;
				
				case GoalsStatus.VOTING_MINUS:
					goal = event.data.split("/")[1];
					role = event.data.split("/")[0];		
					proxy.insertVoting(goal,role,-1);
					break;
				
				case GoalsStatus.GETDAYS_VOTES:
					proxy.getVotes();
					break;
			}
		}
		
		private function handleDGoals(data:XML):void{
			
			var goalsArray:ArrayCollection = new ArrayCollection();
			var xmlhandler:XML_Handlers = new XML_Handlers();		
			var length:int = xmlhandler.calculatesXMLSizeG(data);
			var i:int;
			
			for(i=0;i<length;i++){
				var temp:Object = new Object();
				temp.goal = data.goalSample[i].@goal;
				goalsArray.addItem(temp);
			}
			goalsComponent.dayGoals = goalsArray;
			goalsComponent.actGoalsSumary();	
			if(goalsComponent.currentState!="initState")
				goalsComponent.actGoalsBoxDay();

		}
		
		private function handleWGoals(data:XML):void{
			
			var goalsArray:ArrayCollection = new ArrayCollection();
			var xmlhandler:XML_Handlers = new XML_Handlers();		
			var length:int = xmlhandler.calculatesXMLSizeG(data);
			var i:int;
			
			for(i=0;i<length;i++){
				var temp:Object = new Object();
				temp.goal = data.goalSample[i].@goal;
				goalsArray.addItem(temp);
			}
			goalsComponent.weekGoals = goalsArray;
			if(goalsComponent.currentState!="initState")
				goalsComponent.actGoalsBoxWeek();

		}
		
		private function handleMGoals(data:XML):void{
			
			var goalsArray:ArrayCollection = new ArrayCollection();
			var xmlhandler:XML_Handlers = new XML_Handlers();		
			var length:int = xmlhandler.calculatesXMLSizeG(data);
			var i:int;
			
			for(i=0;i<length;i++){
				var temp:Object = new Object();
				temp.goal = data.goalSample[i].@goal;
				goalsArray.addItem(temp);
			}
			goalsComponent.monthGoals = goalsArray;
			if(goalsComponent.currentState!="initState")
				goalsComponent.actGoalsBoxMonth();

		}
		
		private function calculateDaytotal(data:XML):void{
			var i:int;
			var total:Number=0;
			var temp:Number=0;
			var xmlhandler:XML_Handlers = new XML_Handlers();		
			var length:int = xmlhandler.calculatesXMLSize(data);
		
			for(i=0;i<length;i++){
				temp=data.powerSample[i].@pA;
				total = total+temp;				
			}
			total=total/1000;
			goalsComponent.totalDay=((Math.round(total*100))/100)+" KWh / "+((Math.round(total*10*0.09))/10)+" €";
		}
		
		private function handleActions(xmlNode:XML):void{
		
			//builds the string with all the goals
			var data:String="";
			for each (var actions:XML in xmlNode.user_action)
			{
				//trace("Commitment body:\n"+commitment.action.@short_name);
				data+=(actions.action).@short_name+"\n";
			}
			
			// builds the box to each family member
			var houseInfo:XML = ConfigSingleton.getInstance().getHouseHoldInfo();
			goalsComponent.actions_containers.removeAllElements();
			for each( var family:XML in houseInfo.family){
				if(family.@id == ConfigSingleton.getInstance().getinstallationid()){
					for each (var member:XML in family.element){
						var box:StepGreenGoalsBox = new StepGreenGoalsBox();
						box.data = data;
						box.role=member.@role;
						goalsComponent.actions_containers.addElement(box);
						var test:rateGoalsComponent = new rateGoalsComponent();
						box.buildRating();
						box.buildList();
						box.addEventListener("plus",goalsComponent.handleVoting);
						box.addEventListener("minus",goalsComponent.handleVoting);

					}
				}
			}
			
		}
				
		private function checkGoalsStatus():void{
		
		if(goalsComponent.actions_containers.columnCount<=0){	// only build the list at the first time
			if(ConfigSingleton.getInstance().getStepGreenGoals()!=null){
				handleActions(ConfigSingleton.getInstance().getStepGreenGoals());
			}
			else{
				var data:String="Poupar energia \n";
				// builds the box to each family member
				var houseInfo:XML = ConfigSingleton.getInstance().getHouseHoldInfo();
				goalsComponent.actions_containers.removeAllElements();
				for each( var family:XML in houseInfo.family){
					if(family.@id == ConfigSingleton.getInstance().getinstallationid()){
						for each (var member:XML in family.element){
							var box:StepGreenGoalsBox = new StepGreenGoalsBox();
							box.data = data;
							box.role=member.@role;
							goalsComponent.actions_containers.addElement(box);
							var test:rateGoalsComponent = new rateGoalsComponent();
							box.buildRating();
							box.buildList();
							box.addEventListener("plus",goalsComponent.handleVoting);
							box.addEventListener("minus",goalsComponent.handleVoting);

						}
					}
				}
			}
		}
		}
		
		private function handleVoting(data:XML):void{

			for each( var vote:XML in data.goalSample){
				trace(vote.@goal);
				trace(vote.@role);
				trace(vote.@vote);
				checkVoting(vote.@role,vote.@goal,vote.@vote);
			}

			
		}
		
		// builds the goal list with the votes in the startup
		private function checkVoting(role:String, goal:String,  voting:int):void{
			
			
			for ( var i:int=0; i<goalsComponent.actions_containers.columnCount; i++){
				var test:StepGreenGoalsBox = (goalsComponent.actions_containers.getChildAt(i)) as StepGreenGoalsBox;
				
				if(test.role==role){
				
				for(var j:int=0; j<test.goalsData.length;j++){
					
					if(test.goalsData.getItemAt(j).label==goal){
						test.goalsData.getItemAt(j).voting=voting;
						test.plusVotes = test.goalsData.getItemAt(j).voting>0?test.plusVotes+1:test.plusVotes;
						test.minusVotes = test.goalsData.getItemAt(j).voting<0?test.minusVotes+1:test.minusVotes;

					}
					}
				}
				(test.goal_list.dataProvider as ArrayCollection).refresh();
			}
			
			goalsComponent.buildGoalsSumary();
		}
		
		public function get goalsComponent():GoalsStatus
		{ 
			return viewComponent as GoalsStatus; 
		}
	}
}