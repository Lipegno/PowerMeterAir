package sinais.powermeter.proxy
	
{
	import flash.events.ErrorEvent;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import net.riaspace.flerry.*;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sinais.powermeter.handlersObjects.ConfigSingleton;
	import sinais.powermeter.handlersObjects.WeekHandler;
	import sinais.powermeter.handlersObjects.semaphore.FlerrySemaphore;
	
	public class FlerryProxy extends org.puremvc.as3.patterns.proxy.Proxy
		
	{
		
		public static const QUERY:String  		    = NAME+"/notes/query";
		public static const QUERYRESULT:String  	= NAME+"/notes/queryresult";
		public static const DAYCONS:String  		= NAME+"/notes/dayconsumption";
		public static const CURRENTCONS:String  	= NAME+"/notes/currentCons";
		public static const MONTHCOMP:String	  	= NAME+"/notes/monthComp";
		public static const MONTHTOTAL:String	  	= NAME+"/notes/monthTotal";
		public static const MONTHBYDAY:String		= NAME+"/notes/monthByDay";
		public static const HOURCONS:String			= NAME+"/notes/HourCons";
		public static const WEEKTOTAL:String		= NAME+"/notes/weekTotal";
		public static const YEARCONS:String			= NAME+"/notes/yearTotal";
		public static const DAYSGOALS:String		= NAME+"/notes/DaysGoals";
		public static const WEEKSGOALS:String		= NAME+"/notes/WeeksGoals";
		public static const MONTHGOALS:String		= NAME+"/notes/MonthGoals";
		public static const WEEKCONS:String			= NAME+"/notes/weekByDayCons";
		public static const INSERTVOTE:String	    = NAME+"/notes/insertActionVote";
		public static const VOTERESULTS:String	    = NAME+"/notes/getVoteResults";
		public static const STARTUPCOMPLETE:String  = NAME+"/notes/StartupComplete";
		public static const NEW_BD_PATH:String		= ConfigSingleton.getInstance().getpathToGoalsBD();
		
		
		public static const NAME:String 	= "FlerryProxy";
		public var flerryObj:NativeObject;
		public var 	init:int		= 0;
		
		
		public var installationID:int;
		public var monthConsump:XML;
		public var yearConsump:XML;
		public var weekConsump:XML;
		public var hourConsump:XML;
		public var flerrySem:FlerrySemaphore;
		public var weekHandler:WeekHandler = new WeekHandler();
		
		
		
		public function FlerryProxy()
			
		{
			
			initFlerryObj();
			
			super(NAME);
			
		}
		
		
		
		public function initFlerryObj():void{
			
			
			trace("###########################");
			trace("FLERRY OBJECT CREATED");
			trace("###########################");

			flerryObj = new NativeObject();
			flerryObj.addEventListener(ErrorEvent.ERROR,test);
			flerryObj.singleton = false;
			flerryObj.source 	= "sinais.main.FacadeClass";
			
			
			
			flerrySem = new FlerrySemaphore(flerryObj,"semaphore used to prevent multiple access to the flerry object that cause deserializing errors");
			
			flerrySem.lock();
			
			flerryObj.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var setDBpath:NativeMethod = new NativeMethod();
			
			setDBpath.name="setDBpath";
			
			setDBpath.addEventListener(ResultEvent.RESULT, setDBpath_resultHandler);
			
			setDBpath.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getIID:NativeMethod = new NativeMethod();
			
			getIID.name="getIID";
			
			getIID.addEventListener(ResultEvent.RESULT, getIID_resultHandler);
			
			getIID.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getEventsByHour:NativeMethod = new NativeMethod();
			
			getEventsByHour.name="getEventsByHour";
			
			getEventsByHour.addEventListener(ResultEvent.RESULT, getEventsByHour_resultHandler);
			
			getEventsByHour.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getDayCons:NativeMethod = new NativeMethod();
			
			getDayCons.name="getDayCons";
			
			getDayCons.addEventListener(ResultEvent.RESULT, getDayCons_resultHandler);
			
			getDayCons.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getMonthComp:NativeMethod = new NativeMethod();
			
			getMonthComp.name="getMonthComp";
			
			getMonthComp.addEventListener(ResultEvent.RESULT, getMonthComp_resultHandler);
			
			getMonthComp.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getMonthtotal:NativeMethod = new NativeMethod();
			
			getMonthtotal.name="getMonthtotal";
			
			getMonthtotal.addEventListener(ResultEvent.RESULT, getMonthtotal_resultHandler);
			
			getMonthtotal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getMonthByDay:NativeMethod = new NativeMethod();
			
			getMonthByDay.name="getMonthByDay";
			
			getMonthByDay.addEventListener(ResultEvent.RESULT, getMonthByDay_resultHandler);
			
			getMonthByDay.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var insertEvent:NativeMethod = new NativeMethod();
			
			insertEvent.name="insertEvent";
			
			insertEvent.addEventListener(ResultEvent.RESULT, insertEvent_resultHandler);
			
			insertEvent.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getYearByMonth:NativeMethod = new NativeMethod();
			
			getYearByMonth.name="getYearByMonth";
			
			getYearByMonth.addEventListener(ResultEvent.RESULT, getYearByMonth_resultHandler);
			
			getYearByMonth.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getHourByMinute:NativeMethod = new NativeMethod();
			
			getHourByMinute.name="getHourByMinute";
			
			getHourByMinute.addEventListener(ResultEvent.RESULT, getHourByMinute_resultHandler);
			
			getHourByMinute.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getGoalsByDay:NativeMethod = new NativeMethod();
			
			getGoalsByDay.name="getGoalsByDay";
			
			getGoalsByDay.addEventListener(ResultEvent.RESULT, getGoalsByDay_resultHandler);
			
			getGoalsByDay.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getGoalsByWeek:NativeMethod = new NativeMethod();
			
			getGoalsByWeek.name="getGoalsByWeek";
			
			getGoalsByWeek.addEventListener(ResultEvent.RESULT, getGoalsByWeek_resultHandler);
			
			getGoalsByWeek.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getGoalsByMonth:NativeMethod = new NativeMethod();
			
			getGoalsByMonth.name="getGoalsByMonth";
			
			getGoalsByMonth.addEventListener(ResultEvent.RESULT, getGoalsByMonth_resultHandler);
			
			getGoalsByMonth.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var insertDailyGoal:NativeMethod = new NativeMethod();
			
			insertDailyGoal.name="insertDailyGoal";
			
			insertDailyGoal.addEventListener(ResultEvent.RESULT, insertDailyGoal_resultHandler);
			
			insertDailyGoal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var insertWeeklyGoal:NativeMethod = new NativeMethod();
			
			insertWeeklyGoal.name="insertWeeklyGoal";
			
			insertWeeklyGoal.addEventListener(ResultEvent.RESULT, insertWeeklyGoal_resultHandler);
			
			insertWeeklyGoal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var insertMonthlyGoal:NativeMethod = new NativeMethod();
			
			insertMonthlyGoal.name="insertMonthlyGoal";
			
			insertMonthlyGoal.addEventListener(ResultEvent.RESULT, insertMonthlyGoal_resultHandler);
			
			insertMonthlyGoal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var removeDailyGoal:NativeMethod = new NativeMethod();
			
			removeDailyGoal.name = "removeDailyGoal";
			
			removeDailyGoal.addEventListener(ResultEvent.RESULT, removeDailyGoal_resultHandler);
			
			removeDailyGoal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var removeWeeklyGoal:NativeMethod = new NativeMethod();
			
			removeWeeklyGoal.name = "removeWeeklyGoal";
			
			removeWeeklyGoal.addEventListener(ResultEvent.RESULT, removeWeeklyGoal_resultHandler);
			
			removeWeeklyGoal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var removeMonthlyGoal:NativeMethod = new NativeMethod();
			
			removeMonthlyGoal.name = "removeMonthlyGoal";
			
			removeMonthlyGoal.addEventListener(ResultEvent.RESULT, removeMonthlyGoal_resultHandler);
			
			removeMonthlyGoal.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getWeekByDayCons:NativeMethod = new NativeMethod();
			
			getWeekByDayCons.name = "getWeekByDayCons";
			
			getWeekByDayCons.addEventListener(ResultEvent.RESULT, getWeekByDayCons_resultHandler);
			
			getWeekByDayCons.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var insertVoting:NativeMethod = new NativeMethod();
			
			insertVoting.name = "insertVoting";
			
			insertVoting.addEventListener(ResultEvent.RESULT, insertActionVote_resultHanlder);
			
			insertVoting.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			var getVotes:NativeMethod = new NativeMethod();
			
			getVotes.name = "getVotes";
			
			getVotes.addEventListener(ResultEvent.RESULT, getVotes_resultHanlder);
			
			getVotes.addEventListener(FaultEvent.FAULT, faultResultHandler);
			
			
			
			flerryObj.methods = [setDBpath,getIID,getEventsByHour,getDayCons,getGoalsByDay,getGoalsByWeek
				
				,insertDailyGoal, insertWeeklyGoal, insertMonthlyGoal,getHourByMinute,getWeekByDayCons
				
				,removeDailyGoal,removeWeeklyGoal,removeMonthlyGoal,insertVoting,getVotes
				
				,getGoalsByMonth,getMonthComp,getMonthtotal,getMonthByDay,insertEvent,getYearByMonth];
			
			flerrySem.unlock();
			if(init==0)
				this.setBDpath();
			else
				trace("BUILDING NEW FLERRY OBJECT");
		}
		
		
		
		public function start():void{
			
			trace("starting queries");
			
			if(init==0){
				var data:Date	   = new Date();
				var mes:String 	   = (data.month+1)>9 ? (data.month+1).toString() : "0"+(data.month+1).toString();
				var minutos:String = (data.minutes)>=10 ? (data.minutes).toString() : "0"+(data.minutes).toString();
				var hora:String    = (data.hours)>=10 ? (data.hours).toString():"0"+(data.hours).toString();				
				var dia:String 	   = data.dateUTC>=10?data.dateUTC+"":"0"+(data.dateUTC);
				getDayConsumption(data.fullYear+"-"+mes+"-"+dia, hora,minutos);	
			}	
				
			else{
				
				trace("ja iniciou");
				
			}
			
		}
		
		
		
		//HANDLERS
		
		
		
		private function faultResultHandler(event:FaultEvent):void{
			
		trace(event);
			
		}
		
		
		
		private function setDBpath_resultHandler(event:ResultEvent):void{
			
			
			
			trace(event.result);
			
			sendNotification( QUERY, event.result.toString() );
			
			flerryObj.getIID();
			
			
			
		}
		
		private function getIID_resultHandler(event:ResultEvent):void{
			
			
			
			this.installationID = (int(event.result));
			
			ConfigSingleton.getInstance().setinstallationid(installationID);
			
			trace("$$$$"+event.result);
			
			start();
			
			
			
		}
		
		
		
		
		
		private function getEventsByHour_resultHandler(event:ResultEvent):void{
			
			
			
			trace(event.result);
			
			sendNotification( QUERYRESULT, event.result.toString() );
			
		}
		
		
		
		private function getDayCons_resultHandler(event:ResultEvent):void{
			
			trace("day cons recieved");
			sendNotification( DAYCONS, event.result.toString());
			flerrySem.unlock();
			if(init==0){
				var data:Date = new Date();
				var mes:String 	   = (data.month+1)>9 ? (data.month+1).toString() : "0"+(data.month+1).toString();
				var minutos:String = (data.minutes)>=10 ? (data.minutes).toString() : "0"+(data.minutes).toString();
				var hora:String    = (data.hours)>=10 ? (data.hours).toString():"0"+(data.hours).toString();				
				var dia:String 	   = data.dateUTC>=10?data.dateUTC+"":"0"+(data.dateUTC);
				var mes2:String    = (data.month)>9 ? (data.month).toString() : "0"+(data.month).toString();
				getMonthComp(data.fullYear+"-"+mes+"-"+dia,mes,data.fullYear+"-"+mes2+"-"+dia,mes2);
			}
			
			if(init==1){
				//gethourconsumption();
				//trace("hour cons query");
			}	
			
		}
		
		private function getMonthComp_resultHandler(event:ResultEvent):void{
			
			flerrySem.unlock();
			trace("month comp query recived");
			if(init==0){
				var data:Date = new Date();
				var mes:String    = (data.month+1)>=10 ? (data.month+1).toString():"0"+(data.month+1).toString();	
				var dia:String 	   = data.dateUTC>=10?data.dateUTC+"":"0"+(data.dateUTC);
				getMonthTotal(mes,dia);
			}
			
			trace(event.result.toString())
			sendNotification( MONTHCOMP, event.result.toString());
		}
		
		
		
		private function getMonthtotal_resultHandler(event:ResultEvent):void{
			
			trace("month total recived");
			
			flerrySem.unlock();
			
			if(init==0){
				var data:Date = new Date();
				var mes:String    = (data.month+1)>=10 ? (data.month+1).toString():"0"+(data.month+1).toString();				
				getMonthByDay(mes);
			}
			sendNotification( MONTHTOTAL, event.result.toString());
		}
		
		private function getMonthByDay_resultHandler(event:ResultEvent):void{
			trace("month by day cons recived");
			flerrySem.unlock();
			monthConsump= new XML(event.result);
			var data:Date = new Date();
			if(init==0){
				getYearByMonthCons(data.fullYear.toString());
			}
			sendNotification( MONTHBYDAY, event.result.toString());
		}
		
		
		
		private function insertEvent_resultHandler(event:ResultEvent):void{
			trace(event.result);
			flerrySem.unlock();
		}	
		
		
		
		private function getYearByMonth_resultHandler(event:ResultEvent):void{
			
			trace("year by month recived");
			flerrySem.unlock();
			sendNotification( YEARCONS, event.result.toString());
			yearConsump=new XML(event.result);
			var data:Date = new Date();
			var week_number:int = weekHandler.calculateISO8601WeekNumber(data);
			var week_id:String = week_number>9?week_number.toString():"0"+week_number;
			flerrySem.lock();
			flerryObj.getWeekByDayCons(week_id);
		}
		
		
		
		private function getHourByMinute_resultHandler(event:ResultEvent):void{
			
			try{	
				trace("hour cons recived");
			flerrySem.unlock();
			hourConsump = new XML(event.result);
			sendNotification( HOURCONS, hourConsump.toString());
			if(init==0){
				sendNotification(STARTUPCOMPLETE,null);
				init=1;
			}
			}catch(e:Error){
				trace("teste testes teste");
			}
		}
		
		
		
		private function getWeekByDayCons_resultHandler(event:ResultEvent):void{
			
			trace("year by week cons recived");
		
			flerrySem.unlock();
			sendNotification(WEEKCONS, event.result.toString()); 
			weekConsump=new XML(event.result);
			
			if(init==0)
				gethourconsumption();
		}
		
		private function getGoalsByDay_resultHandler(event:ResultEvent):void{
			
			
			
			//trace(event.result);
			
			sendNotification(DAYSGOALS, event.result.toString());
			
			//getGoalsByWeek("");
			
		}
		
		private function getGoalsByWeek_resultHandler(event:ResultEvent):void{
	
			sendNotification(WEEKSGOALS, event.result.toString());
		
		}
		
		private function getGoalsByMonth_resultHandler(event:ResultEvent):void{
			
			
			
			//trace(event.result);
			
			sendNotification(MONTHGOALS, event.result.toString());
			
		}
		
		private function insertDailyGoal_resultHandler(event:ResultEvent):void{
		}
		
		private function insertWeeklyGoal_resultHandler(event:ResultEvent):void{
		}	
		
		private function insertMonthlyGoal_resultHandler(event:ResultEvent):void{
		}
		
		private function removeDailyGoal_resultHandler(event:ResultEvent):void{
		}
		
		private function removeMonthlyGoal_resultHandler(event:ResultEvent):void{
		}	
		
		private function removeWeeklyGoal_resultHandler(event:ResultEvent):void{
		}	
		private function insertActionVote_resultHanlder(event:ResultEvent):void{
			trace(event.result);
			flerrySem.unlock();
		}
		///////////////////
		//// FUNCTIONS////
		//////////////////
		public function setBDpath():void{
			trace("###############------>"+ConfigSingleton.getInstance().getpathToBD());
			flerryObj.setDBpath(ConfigSingleton.getInstance().getpathToBD());
		}
		
		public function getEventsByHour():void{
			flerryObj.getEventsByHour("/Users/admin/Documents/sinais/bds/SINAIS02.db","2010-10-26","12");
		}
		
		public function getDayConsumption(Date:String, hourLimit:String, minutesLimit:String):void{	
			trace("requesting day consumption");
			if(!flerrySem.isLocked){
				try{
					flerrySem.lock();
					flerryObj.getDayCons(Date,hourLimit,minutesLimit);
				}catch(error:Error){
					//mx.controls.Alert.show(error.toString(), "Erro Flery");
					initFlerryObj();
				}
			}
		}
		
		public function getMonthComp(date1:String, month1:String, date2:String, month2:String):void{
			trace("requesting month comp consumption");
			if(!flerrySem.isLocked){
				try{
					flerrySem.lock();
					flerryObj.getMonthComp(date1, month1, date2, month2);
				}catch(error:Error){
				//	mx.controls.Alert.show(error.toString(), "Erro Flery");
					initFlerryObj();
				}
			}
		}
		
		public function getMonthTotal(month:String,day:String):void{
			trace("requesting month total consumption");
			if(!flerrySem.isLocked){
				
				try{
					flerrySem.lock();
					flerryObj.getMonthtotal(month,day);
				}catch(error:Error){
					
				//	mx.controls.Alert.show(error.toString(), "Erro Flery");
					initFlerryObj();
					
				}
				
			}
			
		}
		
		public function getMonthByDay(mes:String):void{
			trace("requesting mnonth by day consumption");
			if(!flerrySem.isLocked){
				try{
					flerrySem.lock();
					flerryObj.getMonthByDay(mes);
					
				}catch(error:Error){
			//		mx.controls.Alert.show(error.toString(), "Erro Flery");
					initFlerryObj();
				}
			}
		}
		
		public function insertEvent(eventName:String,type:int):void{
			
			if(!flerrySem.isLocked){
				try{
					if(installationID!=0){
						flerrySem.lock();
						flerryObj.insertEvent(type.toString(),eventName,installationID.toString());
						trace("inseri evento: "+eventName+" "+type+" "+installationID);
					}
					
				}catch(error:Error){
				//	mx.controls.Alert.show(error.toString(), "Erro Flery");
					initFlerryObj();
				}
				
			}
		}
		
		public function getYearByMonthCons(year:String):void{
			
			if(!flerrySem.isLocked){
				trace("requesting year by month consumption");
				try{
					flerrySem.lock();
					flerryObj.getYearByMonth(year);
				}catch(error:Error){
					//mx.controls.Alert.show(error.toString(), "Erro Flery");	
					initFlerryObj();
				}
			}
		}
		
		public function getHourCons():void{
			sendNotification( HOURCONS, hourConsump.toString());
		}
		
		
		
		// STARTUP FUNCTIONS
		
		public function startupYearConsump():void{
			sendNotification( YEARCONS, yearConsump.toString());
		}
		
		public function startupMonthCons():void{
			sendNotification( MONTHBYDAY, monthConsump.toString());
		}
		
		
		
		//GOALS FUNCITIONS
		
		public function getGoalsByDay(date:String):void{
			flerryObj.getGoalsByDay(date,NEW_BD_PATH);
		}
		
		public function getGoalsByWeek(date:String):void{
			flerryObj.getGoalsByWeek(date, NEW_BD_PATH);
		}
		
		public function getGoalsByMonth(date:String):void{
			flerryObj.getGoalsByMonth(date,NEW_BD_PATH);
		}
		
		public function insertDailyGoal(goal:String):void{
			if(installationID!=0)
				flerryObj.insertDailyGoal(goal, installationID.toString(),NEW_BD_PATH);
		}
		
		public function insertWeeklyGoal(goal:String):void{
			if(installationID!=0)				
				flerryObj.insertWeeklyGoal(goal, installationID.toString(),NEW_BD_PATH);
		}
		
		public function insertMonthlyGoal(goal:String):void{
			if(installationID!=0)				
				flerryObj.insertMonthlyGoal(goal, installationID.toString(),NEW_BD_PATH);
		}
		
		public function removeDailyGoal(goal:String):void{
			
			flerryObj.removeDailyGoal(goal,NEW_BD_PATH);			
		}
		
		public function removeWeeklyGoal(goal:String):void{
			flerryObj.removeWeeklyGoal(goal,NEW_BD_PATH);			
		}
		
		public function removeMonthlyGoal(goal:String):void{
			flerryObj.removeMonthlyGoal(goal,NEW_BD_PATH);			
		}
		
		
		
		//VOTING FUNCTIONS
		
		
		
		private function getVotes_resultHanlder(evt:ResultEvent):void{
			trace(evt.result);			
			flerrySem.unlock();			
			sendNotification(VOTERESULTS, evt.result.toString());
		}
		
		public function getVotes():void{
			var data:Date	   = new Date();			
			var mes:String 	   = (data.month+1)>9 ? (data.month+1).toString() : "0"+(data.month+1).toString();			
			var dia:String 	   = data.dateUTC>=10?data.dateUTC+"":"0"+(data.dateUTC);			
			trace("bd path ->"+NEW_BD_PATH);			
			if(!flerrySem.isLocked){				
				if(installationID!=0){					
					try{
						flerrySem.lock();
						flerryObj.getVotes(data.fullYear+"-"+mes+"-"+dia, NEW_BD_PATH);	
					}catch(error:Error){
						//mx.controls.Alert.show(error.toString(), "Erro Flery");
						initFlerryObj();
					}					
				}				
			}
			
		}
		
		public function insertVoting(goal:String, role:String,vote:int):void{
			
			if(!flerrySem.isLocked){
				if(installationID!=0){
					try{
						flerrySem.lock();
						flerryObj.insertVoting(goal,role,vote.toString(),installationID.toString(),NEW_BD_PATH);
					}catch(error:Error){
						//mx.controls.Alert.show(error.toString(), "Erro Flery");
						initFlerryObj();						
					}				
				}
			}
		}
		
		public function test(evt:ErrorEvent):void{
			trace(evt);
		}
	
		//AUX FUNCTIONS
		
		public function gethourconsumption():void{
			if(!flerrySem.isLocked){
				trace("requesting hour consumption");
				try{
					var data:Date 		  = new Date();
					var day:String		  = (data.date)>9 ?  (data.date).toString() : "0"+ (data.date).toString();
					var month:String 	   	  = (data.month+1)>9 ?  (data.month+1).toString() : "0"+ (data.month+1).toString();
					var year:String		  = data.getFullYear().toString();
					var hour:String 	  = (data.hours)>9 ?  (data.hours).toString() : "0"+ (data.hours).toString();
					flerrySem.lock();
					flerryObj.getHourByMinute(day,month,year,hour);					
				}catch(error:Error){
					//mx.controls.Alert.show(error.toString(), "Erro Flery");
					initFlerryObj();
				}
				
			}
	
		}	
		
	}
	
}