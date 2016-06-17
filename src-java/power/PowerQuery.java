/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package power;

import java.sql.SQLException;

import model.GoalSampleDTO;
import model.PowerSampleDTO;
import model.VoteSampleDTO;
import data.SQLiteWrapper;

/**
 *
 * @author lucaspereira
 */
public class PowerQuery {

	public static String bdPath;
	
    public static PowerSampleDTO[] GetAverage(String theDate) throws SQLException {
        SQLiteWrapper w = new SQLiteWrapper(bdPath);
        return w.GetHourlyPowerAverageByDay(theDate);
    }

    public static PowerSampleDTO[] GetLastNHoursAverage(int n, String dia) throws SQLException {

        SQLiteWrapper w = new SQLiteWrapper(bdPath);
        return w.GetLastNHoursAverage(n,dia);

    }

     public static PowerSampleDTO[] GetWeekAverageByDay(int week) throws SQLException {

        SQLiteWrapper w = new SQLiteWrapper(bdPath);
        return w.GetWeekAverageByDay(week);

    }

     public static PowerSampleDTO[] getMonthByDayPower(String theDate, String hourLimit,String minutesLimit) throws SQLException {

        SQLiteWrapper w = new SQLiteWrapper(bdPath);
        return w.GetMonthByDayPower(theDate,hourLimit,minutesLimit);

    }

     public static PowerSampleDTO[] getCurrentConsumption() throws SQLException {

        SQLiteWrapper w = new SQLiteWrapper(bdPath);
        return w.GetCurrentPower();

    }
     public static PowerSampleDTO[] getMonthTotal(String month, String day) throws SQLException {

         SQLiteWrapper w = new SQLiteWrapper(bdPath);
         return w.getMonthtotal(month,day);

     }
     
     public static boolean insertEvent(String event, int eventID ,int instID,long timestamp) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.InsertEvent(event, eventID, instID,timestamp);
    	 
     }
     public static int getIID() throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.GetIID();
    	 
     }
     public static long getEventN(String date, String hourLimit,String minutesLimit) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.GetNumEventsN(date,hourLimit,minutesLimit);
     }
     public static long getEventP(String date, String hourLimit,String minutesLimit) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.GetNumEventsP(date,hourLimit,minutesLimit);
     }
     public static String getDayEvents(String date, String hourLimit,String minutesLimit) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getDayEvents(date,hourLimit,minutesLimit);
     }
     public static String getWeekComp(String date, String hourLimit, String minutesLimit,int lastweek,int lastweekday) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getWeekCom(date, hourLimit, minutesLimit,lastweek, lastweekday);
     }
     public static double getLastEvent(String date,String hourLimit,String minutesLimit) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getLastEvent(date,hourLimit,minutesLimit);
     }
     public static String getEventsbyHour(String date,String hourLimit) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getEventsByhour(date, hourLimit);
     }
     
     public static double[] getMonthComp(String date1, String month1, String date2, String month2) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getMonthComp(date1, month1, date2, month2);
    	 
     }
     
     public static PowerSampleDTO[] getMonthByDay(String month) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getMonthByDay(month);
    	 
     }
     
     public static PowerSampleDTO[] getYearByMonth(String year) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getYearByMonth(year);
    	 
     }
     
     public static PowerSampleDTO[] getHourByMinute(String day,String month,String year, String hour) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getHourbyMinute(day, month, year, hour);
    	 
     }
     
     public static PowerSampleDTO[] getWeekByDay(String week_number) throws SQLException{
    	 
    	 SQLiteWrapper w = new SQLiteWrapper(bdPath);
    	 return w.getWeekByDay(week_number);
     }
     
     public static GoalSampleDTO[] getGoalsByDay(String date, String bd_path) throws SQLException{
    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
    	 return w.getDailyGoals(date);
     }
     
     public static GoalSampleDTO[] getWeekGoals(String date, String bd_path) throws SQLException{
    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
    	 return w.getWeekGoals(date);
     }

     
     public static GoalSampleDTO[] getMonthlyGoals(String date, String bd_path) throws SQLException{
    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
    	 return w.getMonthGoals(date); 
     }
     public static boolean insertVote(String goal, String role,int vote, int installation_id, String bd_path) throws SQLException{
    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
    	 return w.insertVoting(goal, role, vote, installation_id);
     }
     
     public static VoteSampleDTO[] getVotes(String date, String bd_path) throws SQLException{
    	 SQLiteWrapper w = new SQLiteWrapper(bd_path);
    	 return w.getDayVote(date);
    	 
     }
 
}
