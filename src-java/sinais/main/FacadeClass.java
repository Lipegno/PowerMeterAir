package sinais.main;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;

import model.GoalSampleDTO;
import model.PowerSampleDTO;
import model.VoteSampleDTO;
import power.PowerQuery;
import socket.SocketDemo;
import data.SQLiteWrapper;
import data.XMLCreator;

public class FacadeClass {
	
	public SocketDemo skt;
	
	public FacadeClass() {
		
		skt = new SocketDemo("127.0.0.1", 7112);

		}
	
	public static String setDBpath(String path){
		
		PowerQuery.bdPath=path;
		return "sucess";
		//"C:/meter/data/daed.db";
		
	}
	
	public static String getDayCons(String date, String hourLimit, String minutesLimit){

		String qMessage="";
		
		StringWriter sw = new StringWriter();
        PrintWriter pw  = new PrintWriter(sw);
        
		try {
			PowerSampleDTO[] demo = PowerQuery.GetAverage(date);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			System.out.println("construindo Query Month By Day Average");
			xml.CreateXML(demo);
			qMessage = xml.getXMLString();
		} catch (Exception ex) {
			
			ex.printStackTrace(pw);
		}

		return qMessage;
	}
	
	public static String getEventNum(String date, String hourLimit,String minutesLimit){
		
		long evtN=0;
		long evtP=0;
		double lastevt=0;
		try {
			 evtN = PowerQuery.getEventN(date,hourLimit,minutesLimit);
		
		} catch (Exception ex) {
			
		}
		
		try {
			 evtP = PowerQuery.getEventP(date,hourLimit,minutesLimit);
		
		} catch (Exception ex) {
			
		}
		try {
			lastevt = PowerQuery.getLastEvent(date,hourLimit,minutesLimit);
		
		} catch (Exception ex) {
			
		}
		return evtP+"|"+evtN+"|"+lastevt;
	}
	
	public static String getDayEvents(String date, String hourLimit, String minutesLimit){
		String evt="";
		try {
			 evt = PowerQuery.getDayEvents(date,hourLimit,minutesLimit);
		
		} catch (Exception ex) {
			
		}
		
		return evt;
		
	}
	
	public static String getLastWeekComp(String date, String hourLimit,String minutesLimit, String lastweek, String lastweekday){
		
		String result=""; 
		StringWriter sw = new StringWriter();
        PrintWriter pw  = new PrintWriter(sw);
        
		try {
			result = PowerQuery.getWeekComp(date, hourLimit, minutesLimit,Integer.parseInt(lastweek), Integer.parseInt(lastweekday));
		
		} catch (Exception ex) {
			ex.printStackTrace(pw);

		}
		
		return result;
		
	}
	
	public static String getEventsByHour(String bdPath,String date, String hourLimit){
		
		String result = "";
		PowerQuery.bdPath = bdPath;
//		StringWriter sw = new StringWriter();
//        PrintWriter pw  = new PrintWriter(sw);
		try {
			result = PowerQuery.getEventsbyHour(date, hourLimit);
		
		} catch (Exception ex) {
			
			//ex.printStackTrace(pw);
		}
		return result;
	}
	
	public String getCurrentPower(){
		
		return skt.getPower()+"";
		
	}
	
	public static String getMonthComp(String date1, String month1, String date2, String month2){
		
		double[] result=null;
		StringWriter sw = new StringWriter();
        PrintWriter pw  = new PrintWriter(sw);
		try {
			result = PowerQuery.getMonthComp(date1, month1, date2, month2);
		
		} catch (Exception ex) {
		
System.out.println("erro");
		}
		if(result==null || result.length==1 || result[0]==0 || result[1]==0){
			return "0";
		}
		else{if(result[0]>result[1])
			return (result[0]/result[1])+"";
		else
			return (-1*result[0]/result[1])+"";
		}
		
	}
	
	public static String getMonthtotal(String month,String day){

		String qMessage="";
		
		StringWriter sw = new StringWriter();
        PrintWriter pw  = new PrintWriter(sw);
        
		try {
			PowerSampleDTO[] demo = PowerQuery.getMonthTotal(month,day);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			System.out.println("construindo Query Month By Day Average");
			xml.CreateXML(demo);
			qMessage = xml.getXMLString();
		} catch (Exception ex) {
			
			ex.printStackTrace(pw);
		}

		return qMessage;
	}
	
	public static String getMonthByDay(String month){
		String qMessage="";


		StringWriter sw = new StringWriter();
        PrintWriter pw  = new PrintWriter(sw);
		
		try {
			PowerSampleDTO[] demo = PowerQuery.getMonthByDay(month);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			System.out.println("construindo Query Month By Day Average");
			xml.CreateXML(demo);
			qMessage = xml.getXMLString();
		} catch (Exception ex) {
			
			ex.printStackTrace(pw);
		}

		return qMessage;
		
		
	}
	
	public static int getIID(){
		
		int iid=0;
		
		try {
			 iid = PowerQuery.getIID();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return iid;
	}

	public static String insertEvent(String eventID, String eventName, String instalationID){
		
		Calendar test= Calendar.getInstance();
		String result = "inserted event";
		try {
			PowerQuery.insertEvent(eventName, Integer.parseInt(eventID), Integer.parseInt(instalationID), test.getTimeInMillis());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "error inserting event";
		}
	
		return result;
		
	}
	
	public static String getYearByMonth(String year){
		String result="";
		
		try {
			PowerSampleDTO[] demo = PowerQuery.getYearByMonth(year);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			System.out.println("construindo Query Year By Month Average");
			xml.CreateXML(demo);
			result = xml.getXMLString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}
	
	public static String getHourByMinute(String day, String month, String year, String hour){
		
		String result = "";
		try{
			PowerSampleDTO[] demo = PowerQuery.getHourByMinute(day, month, year, hour);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			xml.CreateXML(demo);
			result = xml.getXMLString();
			
		}
		catch(Exception e){
			e.printStackTrace();

			System.out.println("erro query hour by minute"+new Date());
		}
		
		return result;
	}
	
	public static String getWeekByDayCons(String week_number){
		
		String result="";
		try{
			PowerSampleDTO[] demo = PowerQuery.getWeekByDay(week_number);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			xml.CreateXML(demo);
			result = xml.getXMLString();
		}
		catch(Exception e){
			e.printStackTrace();

			System.out.println("erro week hour by day"+new Date());
		}
		return result;
	}
	
	public static String getGoalsByDay(String date, String bd_path){
		String result="";
		try {
			
			GoalSampleDTO[] demo = PowerQuery.getGoalsByDay(date, bd_path);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			//System.out.println("construindo goals b");
			xml.CreateXML(demo);
			result = xml.getXMLString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static String getGoalsByWeek(String date, String bd_path){
		String result="";
		try {
			
			GoalSampleDTO[] demo = PowerQuery.getWeekGoals(date, bd_path);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			//System.out.println("construindo Query Year By Month Average");
			xml.CreateXML(demo);
			result = xml.getXMLString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static String getGoalsByMonth(String date, String bd_path){
		String result="";
		try {
			
			GoalSampleDTO[] demo = PowerQuery.getMonthlyGoals(date, bd_path);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			//System.out.println("construindo Query Year By Month Average");
			xml.CreateXML(demo);
			result = xml.getXMLString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static String insertDailyGoal(String goal, String instalationID,String bd_path){
		try{
	    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
	    	 w.insertGoal(goal, instalationID,"daily_goals"); 
	    	 return "success inserting daily goal";
		}
		catch(Exception e){
			e.printStackTrace();
			return "error inserting daily goal";
		}
		
	}
	
	public static String insertWeeklyGoal(String goal,String instalationID,String bd_path){
		try{
	    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
	    	 w.insertGoal(goal, instalationID,"weekly_goals"); 
	    	 return "success inserting weekly goal";

		}
		catch(Exception e){
			e.printStackTrace();
			return "error inserting weekly goal";
		}
	}
	
	public static String insertMonthlyGoal(String goal, String instalationID, String bd_path){
		try{
	    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
	    	 w.insertGoal(goal, instalationID,"monthly_goals");
	    	 return "success inserting monthly goal";
		}
		catch(Exception e){
			e.printStackTrace();
			return "error inserting weekly goal";
		}		
	}
	
	public static String removeDailyGoal(String goal,String bd_path){
		try{
	    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
	    	 w.removeGoal(goal,"daily_goals"); 
	    	 return "success removing daily goal";
		}
		catch(Exception e){
			e.printStackTrace();
			return "error removing daily goal";
		}
		
	}
	
	public static String removeWeeklyGoal(String goal,String bd_path){
		try{
	    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
	    	 w.removeGoal(goal,"weekly_goals"); 
	    	 return "success removing weekly goal";

		}
		catch(Exception e){
			e.printStackTrace();
			return "error removing weekly goal";
		}
	}
	
	public static String removeMonthlyGoal(String goal,String bd_path){
		try{
	    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
	    	 w.removeGoal(goal,"monthly_goals");
	    	 return "success removing monthly goal";
		}
		catch(Exception e){
			e.printStackTrace();
			return "error removing weekly goal";
		}		
	}
	
	public static String insertVoting(String goal, String role,String vote, String installation_id, String bd_path){
		try{
			PowerQuery.insertVote(goal, role, Integer.parseInt(vote), Integer.parseInt(installation_id), bd_path);
			return "vote inserted";
		}
		catch(Exception e){
			return "failed inserting vote";
		}
	}
	
	public static String getVotes(String date, String bd_path){
		String result="";
		try{
			VoteSampleDTO[] demo = PowerQuery.getVotes(date, bd_path);
			XMLCreator xml = new XMLCreator("daily_power_tpl.xml");
			//System.out.println("construindo Query Year By Month Average");
			xml.CreateXML(demo);
			result = xml.getXMLString();
			return result;
		}
		catch(Exception e){
			return "failed getting votes";
		}
		
	}
	
	public static void main(String[] args){
//		insertVoting("test goal","pai","1","2","goalsDB.sqlite");
//    	getVotes("","goalsDB.sqlite");
		setDBpath("C:/powermeter3/data/daed.db");	
		System.out.println(getIID());
//		System.out.println(getHourByMinute("20","01","2011","11"));
//		System.out.println(getYearByMonth("2010"));
		System.out.println(""+getMonthByDay("07"));
//		System.out.println(insertEvent("1","motion","12"));

//		System.out.println(getWeekByDayCons("09"));
//		System.out.println(removeWeeklyGoal("asdasd","/Users/admin/Documents/Adobe Flash Builder 4 Plug-in/PowerMeter5/goalsDB.sqlite"));
//		insertMonthlyGoal("objectivo2","/Users/admin/Documents/Adobe Flash Builder 4 Plug-in/PowerMeter5/goalsDB.sqlite");
//		
 	}
}
