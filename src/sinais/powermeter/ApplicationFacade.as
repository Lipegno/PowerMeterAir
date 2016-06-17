package sinais.powermeter
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import sinais.powermeter.controller.*;

	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String				= "startup";
		public static const START:String				= "start";
		public static const GETEVENTSBYHOUR:String		= "getEventsByHour";
		public static const GETDAYCONS:String			= "getDayConsumption";
		public static const GETCURRENTPOW:String		= "getCurrentPow";
		public static const GETMONTHCOMP:String			= "getMonthComp";
		public static const GETMONTHTOTAL:String		= "getMonthTotal";
		public static const GETRECOMENDATIONS:String	= "getRecomendations";
		public static const GETMONTHSCONS:String		= "getMonthsCons";
		public static const GETYEARCONS:String		    = "getYearCons";
		public static const GETGOALSINFO:String			= "getGoalInfo";
		public static const CHANGEVIEW:String			= "CHANGEVIEW";
		public static const INSERTEVT:String			= "insertEvent";
		
		public static const GETHOURBYMINUTE:String		= "GETHOURBYMINUTE";
		
		public static const GOALSINTERFACECHANGE:String = "handleGoalsInterfaceChange";
		public static const INSERTGOAL:String			= "insertGoal";
		public static const REMOVEGOAL:String			= "removeGoal";
		public static const GET_SG_GOALS:String			= "get_sg_goals";
		public static const STARTUP_POWERSOCKET:String	= "STARTUP_POWERSOCKET";

	

		
		public static function getInstance() : ApplicationFacade 
		{
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		public function startup ( app:PowerMeter5 ) : void
		{
			sendNotification( STARTUP, app );
		}
		
		
		override protected function initializeController () : void
		{
			super.initializeController();
			registerCommand( STARTUP, 		StartupCommand );
			registerCommand( START, StartExecution );
			registerCommand( GETEVENTSBYHOUR, GetEventsByHour );
			registerCommand( GETDAYCONS, GetDayConsumption );
			registerCommand( GETCURRENTPOW, GetCurrentPower );
			registerCommand( GETMONTHCOMP, GetMonthComp );
			registerCommand( GETMONTHTOTAL, GetMonthTotal );
			registerCommand( GETRECOMENDATIONS, GetRecomendations );
			registerCommand( CHANGEVIEW, NavigationBarControl );
			registerCommand( GETMONTHSCONS, GetMonthByDay );
			registerCommand( GETYEARCONS, GetYearByMonth );
			registerCommand( INSERTEVT, InsertEvent );
			registerCommand( GETGOALSINFO, GetGoalsInfo);
			registerCommand( GOALSINTERFACECHANGE, HandlesGoalsInterfaceChange );
			registerCommand( INSERTGOAL, InsertGoal);
			registerCommand( REMOVEGOAL,RemoveGoal);
			registerCommand( GET_SG_GOALS, HandleSGGoals);
			registerCommand(GETHOURBYMINUTE,GetHourByMinuteCons);
			registerCommand(STARTUP_POWERSOCKET,StartupPowerSocket);




		}	
		
	}
}