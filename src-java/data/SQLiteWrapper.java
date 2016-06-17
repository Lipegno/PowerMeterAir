package data;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.GoalSampleDTO;
import model.PowerSampleDTO;
import model.VoteSampleDTO;


/**
 *
 * @author lucaspereira
 */
public class SQLiteWrapper{

    // function to insert a powersampleDTO in the db

    Connection dbConn = null;
    
    public SQLiteWrapper(String bdPath){
        // register the driver
        String sDriverName = "org.sqlite.JDBC";
        try {
            Class.forName(sDriverName);
        }
        catch(Exception e)
        {
            System.err.println(e);

        }
        String sJDBC = "jdbc:sqlite:"+bdPath;
        try {
       
        	//Set connection timeout in milliseconds:
            dbConn = DriverManager.getConnection(sJDBC);
        }
        catch(SQLException e)
        {
            // connection failed.
            System.err.println(e);
        }
    }

    public boolean InsertPowerSample(PowerSampleDTO powerSample) {
        int vcc = (powerSample.UseConstantVoltage())? 1 : 0;
        String q = "INSERT INTO power_sample (iRMS, vRMS, powerAngle, timestamp, sampleIndex, constantVoltage) VALUES (" ;
        q += powerSample.GetIRMS();
        q += ", " + powerSample.GetVRMS() + ", " + powerSample.GetPowerAngle();
        q += ", '" + powerSample.GetTimeStamp() + "', " + powerSample.GetSampleIndex();
        q += ", " + vcc + ")";
        
        if(dbConn != null) {
            try {
                Statement stmt = dbConn.createStatement();
               // System.out.println(q);
                stmt.executeUpdate( q );
                
            } catch (SQLException ex) {
                Logger.getLogger(SQLiteWrapper.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        return false;
    }

    public boolean InsertEvent(String eventType, int eventID,int instID,long timestamp) throws SQLException {
    	
        boolean resultNew = false;
        PreparedStatement pStmt;
        String q = "INSERT INTO webcam_event (timestamp, type,event_id,installation_id) VALUES (?,?,?,?)" ;
        	try{
        		
        		dbConn.setAutoCommit(false);
    			pStmt = dbConn.prepareStatement(q);
    			pStmt.setString(1, new Timestamp(timestamp).toString());
    			pStmt.setString(2, eventType);
    			pStmt.setInt(3, eventID);
    			pStmt.setInt(4, instID);

    			resultNew  = pStmt.execute();
    		    pStmt.close();
    		    dbConn.commit();
    		
			} catch (SQLException e1) {
				e1.printStackTrace();
				try {
					dbConn.rollback();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			return resultNew;
    }
    
    public PowerSampleDTO[] GetHourlyPowerAverageByDay(String theDate) throws SQLException {

        String query =  "SELECT AVG(pAvg) as _power, strftime('%s', timestamp) as time_,timestamp, strftime('%H:00',timestamp)"+
        					"FROM (SELECT * FROM average_power_sample ORDER BY id DESC LIMIT 2880) WHERE Date(timestamp) = '"+theDate+"' GROUP BY strftime('%H',timestamp)";
        
        Statement stmt=null; 
        PowerSampleDTO ps;
        PowerSampleDTO[] result=null;

			stmt = dbConn.createStatement();
		 
        ResultSet rs = stmt.executeQuery(query);  
       

        List _power = new ArrayList();

        while(rs.next()) {
            double power = Double.valueOf(rs.getString("_power"));
            
            Timestamp timestamp = Timestamp.valueOf(rs.getString("timestamp"));
            ps = new PowerSampleDTO(power, timestamp);

            _power.add(ps);
        }
        result = new PowerSampleDTO[_power.size()];

        Iterator samples = _power.iterator();
        while( samples.hasNext() ) {
            ps = (PowerSampleDTO) samples.next();
            result[_power.indexOf(ps)] = ps;   
        }
		
		stmt.close();

        return result;
    }

    public PowerSampleDTO[] GetLastNHoursAverage(int n, String dia)  {
    	 
    	  Statement stmt=null; 
          PowerSampleDTO ps;
          PowerSampleDTO[] result=null;
          boolean resultNew = false;
          PreparedStatement pStmt;
		  String query = "SELECT AVG(iRMS) as iRMS, AVG(vRMS) as vRMS, strftime('%H',timestamp) as hour, strftime('%d',timestamp) as dia, timestamp FROM power_sample WHERE dia=? GROUP BY strftime('%H',timestamp) ORDER BY strftime('%',timestamp) DESC LIMIT 0,8";

		try { 
			dbConn.setAutoCommit(false);
			pStmt = dbConn.prepareStatement(query);
			pStmt.setString(1, dia);

        ResultSet rs = pStmt.executeQuery(query);
        pStmt.close();
        dbConn.commit();
        
		        List _power = new ArrayList();
		        while(rs.next()) {
		            double iRMS = Double.valueOf(rs.getString("iRMS"));
		            double vRMS = Double.valueOf(rs.getString("vRMS"));
		            Timestamp timestamp = Timestamp.valueOf(rs.getString("timestamp"));
		            ps = new PowerSampleDTO(iRMS, vRMS, 0, timestamp);
		            _power.add(ps);
		        }
		        result = new PowerSampleDTO[_power.size()];
		        Iterator samples = _power.iterator();
		        while( samples.hasNext() ) {
		            ps = (PowerSampleDTO) samples.next();
		            result[_power.indexOf(ps)] = ps;
		        }
        
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
				try{
					dbConn.rollback();
				}
				catch(SQLException e2){
					e2.printStackTrace();
				}
		} 
		//stmt.close();

        return result;


    }

    public PowerSampleDTO[] GetWeekAverageByDay(int week) throws SQLException {
  	  
   	 Statement stmt=null; 
        PowerSampleDTO ps;
        PowerSampleDTO[] result=null;
         
     
	   stmt = dbConn.createStatement();
		

       String query = "SELECT SUM(pAvg)/120 as _power, timestamp as _time, strftime('%w',timestamp) as weekday, strftime('%m',timestamp) as monthday,  strftime('%d',timestamp),strftime('%d',timestamp) as day"+
       		"FROM (SELECT * FROM average_power_sample ORDER BY id DESC LIMIT 20160) WHERE strftime('%W',timestamp)='"+week+"' GROUP BY strftime('%d',timestamp) ORDER BY monthday";
       
       ResultSet rs = stmt.executeQuery(query);


       List _power = new ArrayList();

       while(rs.next()) {
           
    	   
           double power = Double.valueOf(rs.getString("_power"));

           Timestamp timestamp = Timestamp.valueOf(rs.getString("_time"));
           ps = new PowerSampleDTO(power, timestamp);

           _power.add(ps);
       }
       result = new PowerSampleDTO[_power.size()];

       Iterator samples = _power.iterator();
       while( samples.hasNext() ) {
           ps = (PowerSampleDTO) samples.next();
           result[_power.indexOf(ps)] = ps;
       }
       
		stmt.close();

       return result;
   }

      public PowerSampleDTO[] GetMonthByDayPower(String theDate, String hourLimit, String minutesLimit) throws SQLException {
    	 
    	 Statement stmt=null; 
         PowerSampleDTO ps;
         PowerSampleDTO[] result=null;
         String day = theDate.split("-")[2];
         String month = theDate.split("-")[1];
         String year = theDate.split("-")[0];
           
    	 stmt = dbConn.createStatement();
	

        String query = "SELECT AVG(pAvg) as _power, strftime('%s', timestamp) as time_, datetime(timestamp) as datetime, strftime('%H',timestamp) as hour, timestamp, strftime('%H:00',timestamp) " +
        			"FROM average_power_sample WHERE   strftime('%d',timestamp)='"+day+"' AND strftime('%m',timestamp)='"+month+"' AND strftime('%Y',timestamp)='"+year+"' " +
        					"AND timestamp<'"+theDate+" "+hourLimit+":"+minutesLimit+"' GROUP BY hour";


//        String query = "SELECT AVG(iRMS) as iRMS, AVG(vRMS) as vRMS, strftime('%s', timestamp) as time_, datetime(timestamp) as datetime, strftime('%H',timestamp) as hour,  strftime('%M',timestamp) as minuto, timestamp, strftime('%H:00',timestamp) " +
//		"FROM power_sample WHERE "+
//				" Date(timestamp)='"+theDate+" "+hourLimit+":"+minutesLimit+"' ";

        
        ResultSet rs = stmt.executeQuery(query);
        
        List _power = new ArrayList();

        while(rs.next()) {
            double power  = Double.valueOf(rs.getString("_power"));
            double angle = 0.0;

            Timestamp timestamp = Timestamp.valueOf(rs.getString("timestamp"));
            ps = new PowerSampleDTO(power, timestamp);

            _power.add(ps);
        }
        result = new PowerSampleDTO[_power.size()];

        Iterator samples = _power.iterator();
        while( samples.hasNext() ) {
            ps = (PowerSampleDTO) samples.next();
            result[_power.indexOf(ps)] = ps;
        }
    	
		stmt.close();

        return result;
    }

      public int GetIID() throws SQLException {
     	 
     	 Statement stmt=null; 
         int instID=0;
            
     	
 		 stmt = dbConn.createStatement();
 	

         String query = "SELECT installation_id as instID, id as id FROM average_power_sample WHERE id=1";
         ResultSet rs = stmt.executeQuery(query);
         

         while(rs.next()) {
              instID  = Integer.valueOf(rs.getString("instID"));
         }
       
     
         return instID;
     }
      
       public PowerSampleDTO[] GetCurrentPower() throws SQLException {
      	
    	Statement stmt=null; 
        PowerSampleDTO ps;
        PowerSampleDTO[] result=null;
         
		stmt = dbConn.createStatement();
		

        String query = "SELECT iRMS as iRMS, vRMS as vRMS, timestamp as time_ FROM power_sample ORDER BY id DESC LIMIT 0, 1";

        ResultSet rs = stmt.executeQuery(query);


        List _power = new ArrayList();

        while(rs.next()) {
            double iRMS = Double.valueOf(rs.getString("iRMS"));
            double vRMS = Double.valueOf(rs.getString("vRMS"));
            double angle = 0.0;

            Timestamp timestamp = Timestamp.valueOf(rs.getString("time_"));
            ps = new PowerSampleDTO(iRMS, vRMS, 0, timestamp);

            _power.add(ps);
        }
        result = new PowerSampleDTO[_power.size()];

        Iterator samples = _power.iterator();
        while( samples.hasNext() ) {
            ps = (PowerSampleDTO) samples.next();
            result[_power.indexOf(ps)] = ps;
        }
      
		stmt.close();

       
        return result;
    }
       public long GetNumEventsN(String date, String hourLimit, String minuteslimit) throws SQLException {
         	
       	Statement stmt=null; 

           long numEvent=0;
           String day = date.split("-")[2];
           String month = date.split("-")[1];
           String year = date.split("-")[0];
           
         
   		   stmt = dbConn.createStatement();
           String query = "SELECT COUNT(id) as num"+
          "	FROM power_event WHERE deltaPMean<0 AND" +
          " strftime('%d',timestamp)='"+day+"' AND strftime('%m',timestamp)='"+month+"' AND strftime('%Y',timestamp)='"+year+"'AND timestamp<'"+date+" "+hourLimit+":"+minuteslimit+"' ";
          		
          
           ResultSet rs = stmt.executeQuery(query);

           while(rs.next()) {
                numEvent = Long.valueOf(rs.getString("num"));

           }

         
			stmt.close();

           return numEvent;
       }
     
       public long GetNumEventsP(String date, String hourLimit,String minuteslimit) throws SQLException {
        	
          	Statement stmt=null; 

          	long numEvent=0;
            String day = date.split("-")[2];
            String month = date.split("-")[1];
            String year = date.split("-")[0];
            
          
    		stmt = dbConn.createStatement();
            String query = "SELECT COUNT(id) as num"+
           "	FROM power_event WHERE deltaPMean>0 AND" +
           " strftime('%d',timestamp)='"+day+"' AND strftime('%m',timestamp)='"+month+"' AND strftime('%Y',timestamp)='"+year+"'AND timestamp<'"+date+" "+hourLimit+":"+minuteslimit+"' ";
           	
              ResultSet rs = stmt.executeQuery(query);

              while(rs.next()) {
                   numEvent = Long.valueOf(rs.getString("num"));

              }

             
  			stmt.close();

              return numEvent;
          }
       
     public String getDayEvents(String date, String hourLimit,String minuteslimit) throws SQLException {
    	 
    	 Statement stmt=null; 
    	  String day = date.split("-")[2];
          String month = date.split("-")[1];
          String year = date.split("-")[0];
         String numEvent="";
       
 		 stmt = dbConn.createStatement();
         String query = "SELECT COUNT(id) as num,strftime('%M',timestamp) as minuto, Date(timestamp) as day, strftime('%H',timestamp) as hora " +
         		" FROM power_event WHERE strftime('%d',timestamp)='"+day+"' AND strftime('%m',timestamp)='"+month+"' AND strftime('%Y',timestamp)='"+year+"' " +
        					"AND timestamp<'"+date+" "+hourLimit+":"+minuteslimit+"' GROUP BY hora";

         ResultSet rs = stmt.executeQuery(query);
         int i=0;
         int hora=0;
         while(rs.next()) {
        	 hora=(Integer.valueOf(rs.getString("hora")));
        	// System.out.println(hora);


        	 if(hora==i){
              numEvent = numEvent+Integer.valueOf(rs.getString("num"))+"|";

        	 }
        	 else{
        		 
        		 while(i<hora){
        			 
        			 numEvent = numEvent+"0|";
        			 i++;
        		 }
        	 }
        	 i++;

         }

       
			stmt.close();

         return numEvent;
    	 
     }
     
     public double getLastEvent(String date ,String hourLimit, String minuteslimit) throws SQLException {
    	 
    	 Statement stmt=null; 
    	 String day = date.split("-")[2];
         String month = date.split("-")[1];
         String year = date.split("-")[0];
         double result=0;

         stmt = dbConn.createStatement();
         String query = " SELECT deltaPMean as deltaP, id ,strftime('%M',timestamp) as minuto ,strftime('%H',timestamp) as hora FROM" +
         		" power_event WHERE strftime('%d',timestamp)='"+day+"' AND strftime('%m',timestamp)='"+month+"' AND strftime('%Y',timestamp)='"+year+"' " +
        					"AND timestamp<'"+date+" "+hourLimit+":"+minuteslimit+"' ORDER BY id DESC LIMIT 0,1";

         ResultSet rs = stmt.executeQuery(query);

         while(rs.next()) {
              result = Double.valueOf(rs.getString("deltaP"));

         }

        
			stmt.close();

         return result;
    	 
     }
     
     
     public String getWeekCom(String date, String hourLimit, String minutesLimit,int lastweek, int lastweekday) throws SQLException {
    	 
    	 Statement stmt=null; 
    	 String day = date.split("-")[2];
         String month = date.split("-")[1];
         String year = date.split("-")[0];
         
         String totalCons="";
         stmt = dbConn.createStatement();
         String query = "SELECT SUM(pAvg) as thisWeektotal, timestamp as time,  strftime('%H',timestamp) as hour"+
         			"FROM (SELECT pAvg,timestamp FROM average_power_sample ORDER BY id DESC LIMIT 89280)"+
         			"WHERE  strftime('%W',timestamp)='"+lastweek+1+"'"+ 
         				"UNION ALL"+ 
         				"SELECT SUM(pAvg) as thisWeektotal, timestamp as time,  strftime('%H',timestamp) as hour"+
         				"FROM (SELECT pAvg,timestamp FROM average_power_sample ORDER BY id DESC LIMIT 178560) WHERE hour<'"+hourLimit+"' AND strftime('%W',timestamp)='"+lastweek+"'  AND strftime('%w',timestamp)<"+lastweekday+"'";
        
         ResultSet rs = stmt.executeQuery(query);

         while(rs.next()) {
              totalCons = totalCons+Double.valueOf(rs.getString("thisWeektotal"))+"|";

         }
		stmt.close();

         return totalCons;
    	 
     }
     
     public String getEventsByhour(String date, String hourLimit) throws SQLException {
    	 
    	 Statement stmt=null; 
    	 
         
         String totalCons="";
         stmt = dbConn.createStatement();
         String query = "SELECT deltaPMean as delta, strftime('%s',timestamp) as ts, strftime('%H',timestamp) as hour,strftime('%M',timestamp) as minute, strftime('%S',timestamp) as second " +
         				"FROM power_event WHERE (delta>200 OR delta<-200) AND Date(timestamp)='"+date+"' AND hour='"+hourLimit+"' ";
         ResultSet rs = stmt.executeQuery(query);

         while(rs.next()) {
              totalCons = totalCons+Double.valueOf(rs.getString("delta"))+"|"+(Integer.valueOf(rs.getString("minute")))+":"+(Integer.valueOf(rs.getString("second")));
              totalCons+="\n";
         }
			stmt.close();

         return totalCons;
    	 
     }

     public double[] getMonthComp(String date1, String month1, String date2, String month2) throws SQLException {
    	 double[] test  = {0,0};
    	 Statement stmt=null; 
    	 
         
         String totalCons="";
 		 stmt = dbConn.createStatement();
         String query = "SELECT SUM(pAvg) as thisMonthTotal, timestamp as time, Date(timestamp) as time1, strftime('%m',timestamp) as month, strftime('%d') as day " +
         		"FROM average_power_sample WHERE month='"+month1+"' and time1<'"+date1+"'" +
         		" UNION ALL " +
         		"SELECT SUM(pAvg) as thisMonthTotal, timestamp as time, Date(timestamp) as time1, strftime('%m',timestamp) as month, strftime('%d') as day " +
         		"FROM average_power_sample WHERE month='"+month2+"' and time1<'"+date2+"'";

         ResultSet rs = stmt.executeQuery(query);
         int i=0;
         while(rs.next()) {
        	 if(rs.getString("thisMonthTotal")!=null){
              test[i] = Double.valueOf(rs.getString("thisMonthTotal"));
              i++;
        	 }
         	}
			stmt.close();

         return test;
    	 
     }
     
     public PowerSampleDTO[] getMonthtotal(String month,String day) throws SQLException {

         String query = "SELECT AVG(pAvg) as _power, strftime('%s', timestamp) as time_, datetime(timestamp) as datetime, strftime('%H',timestamp) as hour, timestamp " +
         				"FROM (SELECT pAvg,timestamp FROM average_power_sample ORDER BY id DESC LIMIT 89280) WHERE strftime('%m',timestamp)='"+month+"' AND strftime('%d',timestamp)<='"+day+"' GROUP BY strftime('%m%d%H',timestamp)";

         
         Statement stmt=null; 
         PowerSampleDTO ps;
         PowerSampleDTO[] result=null;
         stmt = dbConn.createStatement();
 		 
         ResultSet rs = stmt.executeQuery(query);  
        

         List _power = new ArrayList();

         while(rs.next()) {
             double power = Double.valueOf(rs.getString("_power"));
             
             Timestamp timestamp = Timestamp.valueOf(rs.getString("timestamp"));
             ps = new PowerSampleDTO(power,timestamp);

             _power.add(ps);
         }
         result = new PowerSampleDTO[_power.size()];

         Iterator samples = _power.iterator();
         while( samples.hasNext() ) {
             ps = (PowerSampleDTO) samples.next();
             result[_power.indexOf(ps)] = ps;   
         }
		stmt.close();

         return result;
     }
     
     public PowerSampleDTO[] getMonthByDay(String month) throws SQLException {
    	//HACK HACK HACK
         String query = "SELECT  _time, SUM(_power) as _power   FROM ( SELECT AVG(pAvg) as _power, strftime('%s', timestamp) as time_, timestamp as _time, datetime(timestamp) as datetime, strftime('%H',timestamp) as hour, timestamp "+
          	 "FROM (SELECT pAvg,timestamp FROM average_power_sample ORDER BY id DESC LIMIT 89280) WHERE strftime('%m',timestamp)='"+month+"'  GROUP BY strftime('%m%d%H',timestamp)) GROUP BY strftime('%d',_time)";
         //HACK HACK HACK
         Statement stmt=null; 
         PowerSampleDTO ps;
         PowerSampleDTO[] result=null;
 	     stmt = dbConn.createStatement();
         ResultSet rs = stmt.executeQuery(query);  
         List _power = new ArrayList();

         while(rs.next()) {
             double power = Double.valueOf(rs.getString("_power"));
             
             Timestamp timestamp = Timestamp.valueOf(rs.getString("_time"));
             ps = new PowerSampleDTO(power, timestamp);

             _power.add(ps);
         }
         result = new PowerSampleDTO[_power.size()];

         Iterator samples = _power.iterator();
         while( samples.hasNext() ) {
             ps = (PowerSampleDTO) samples.next();
             result[_power.indexOf(ps)] = ps;   
         }
		stmt.close();

         return result;
     }
     
     public PowerSampleDTO[] getYearByMonth(String year) throws SQLException {
         
    	 String query = "SELECT SUM(_power) as _power, timestamp as _time FROM (SELECT AVG(pAvg) as _power, strftime('%s', timestamp) as time_, timestamp as timestamp, datetime(timestamp) as datetime, strftime('%H',timestamp) as hour, timestamp"+ 
         	" FROM average_power_sample WHERE strftime('%Y',timestamp)='"+year+"' GROUP BY strftime('%m%d%H',timestamp)) GROUP BY strftime('%m',timestamp)";
         			
    	  Statement stmt=null; 
          PowerSampleDTO ps;
          PowerSampleDTO[] result=null;
  		  stmt = dbConn.createStatement();
  		 
          ResultSet rs = stmt.executeQuery(query);  
          List _power = new ArrayList();

          while(rs.next()) {
              double power = Double.valueOf(rs.getString("_power"));
              
              Timestamp timestamp = Timestamp.valueOf(rs.getString("_time"));
              ps = new PowerSampleDTO(power, timestamp);

              _power.add(ps);
          }
          result = new PowerSampleDTO[_power.size()];

          Iterator samples = _power.iterator();
          while( samples.hasNext() ) {
              ps = (PowerSampleDTO) samples.next();
              result[_power.indexOf(ps)] = ps;   
          }
 		stmt.close();
 		return result;
      }
           

 /**
  * Returns the average of every 5 minutes of an hour
  * @param day   |
  * @param month | -> date of the day
  * @param year  |
  * @param hour - hour to calculate the average
  * @return
  * @throws SQLException
  */
     public PowerSampleDTO[] getHourbyMinute(String day, String month, String year,String hour) throws SQLException{
    	 
    	String query = "SELECT SUM(pAvg)/120 as _power, strftime('%s', timestamp) as time_, timestamp as _time, datetime(timestamp) as datetime, strftime('%M',timestamp) as minute, timestamp, strftime('%H:00',timestamp)"+
						"FROM (SELECT * FROM average_power_sample ORDER BY id DESC LIMIT 120) WHERE   strftime('%d',timestamp)='"+day+"' AND strftime('%m',timestamp)='"+month+"' AND strftime('%Y',timestamp)='"+year+"' AND strftime('%H',timestamp)='"+hour+"'"+
					 	  "GROUP BY minute/5";

    	 Statement stmt=null; 
         PowerSampleDTO ps;
         PowerSampleDTO[] result=null;
         
         stmt = dbConn.createStatement();
  		 
         ResultSet rs = stmt.executeQuery(query);  
        

         List _power = new ArrayList();

         while(rs.next()) {
             double power = Double.valueOf(rs.getString("_power"));
             
             Timestamp timestamp = Timestamp.valueOf(rs.getString("_time"));
             ps = new PowerSampleDTO(power, timestamp);

             _power.add(ps);
         }
         result = new PowerSampleDTO[_power.size()];

         Iterator samples = _power.iterator();
         while( samples.hasNext() ) {
             ps = (PowerSampleDTO) samples.next();
             result[_power.indexOf(ps)] = ps;   
         }
         return result;
    	 
     }
     
     /**
      * queries the db for the consumption of a given week, the consumption is grouped by day
      * @param week_number - the id (number) of the week
      * @return
      * @throws SQLException
      */
     public PowerSampleDTO[] getWeekByDay(String week_number) throws SQLException{
    	 
    	 String year = "2011";
    	 String query =  "SELECT  _time, SUM(_power) as _power   FROM ( " +
    	 		"SELECT pAvg as _power, timestamp as _time "+ 
         		"FROM average_power_sample WHERE strftime('%W',timestamp)='09' and strftime('%Y',timestamp)='"+year+"' GROUP BY strftime('%m%d%H',timestamp) )" +
         		"GROUP BY strftime('%d',_time)";
         
         Statement stmt=null; 
         PowerSampleDTO ps;
         PowerSampleDTO[] result=null;

 			stmt = dbConn.createStatement();
 		 
         ResultSet rs = stmt.executeQuery(query);  
        

         List _power = new ArrayList();

         while(rs.next()) {
             double power = Double.valueOf(rs.getString("_power"));
             
             Timestamp timestamp = Timestamp.valueOf(rs.getString("_time"));
             ps = new PowerSampleDTO(power, timestamp);

             _power.add(ps);
         }
         result = new PowerSampleDTO[_power.size()];

         Iterator samples = _power.iterator();
         while( samples.hasNext() ) {
             ps = (PowerSampleDTO) samples.next();
             result[_power.indexOf(ps)] = ps;   
         }
 		
 		stmt.close();

         return result;
    	 
     }
     
     
     /**
      * Creates a Goal Sample array based on the result from the query
      * @param Date - date of the goals to be searched 
      * @return - Array with all the goals(DTOObjects) in that date
      * @throws SQLException
      */
     public GoalSampleDTO[] getDailyGoals(String Date) throws SQLException{
    	 
    	 String query		    = "SELECT Goal as _goal, Date as _date FROM daily_goals";
    	 Statement stmt 		= null;
    	 GoalSampleDTO temp;
    	 GoalSampleDTO[] result = null;
    	 stmt = dbConn.createStatement();
   		 
           ResultSet rs = stmt.executeQuery(query);  
           List _power = new ArrayList();

           while(rs.next()) {
               String goal = (rs.getString("_goal"));
               
               Timestamp timestamp = Timestamp.valueOf(rs.getString("_date"));
               temp = new GoalSampleDTO(goal, timestamp);

               _power.add(temp);
           }
           result = new GoalSampleDTO[_power.size()];

           Iterator samples = _power.iterator();
           while( samples.hasNext() ) {
        	   temp = (GoalSampleDTO) samples.next();
               result[_power.indexOf(temp)] = temp;   
           }
   		
  		stmt.close();
    	return result;
     }
     
     public GoalSampleDTO[] getWeekGoals(String Date) throws SQLException{
    	 
    	 String query		    = "SELECT Goal as _goal, Date as _date FROM weekly_goals";
    	 Statement stmt 		= null;
    	 GoalSampleDTO temp;
    	 GoalSampleDTO[] result = null;
    	 stmt = dbConn.createStatement();
   		 
         ResultSet rs = stmt.executeQuery(query);  
         List _power = new ArrayList();

           while(rs.next()) {
               String goal = (rs.getString("_goal"));
               
               Timestamp timestamp = Timestamp.valueOf(rs.getString("_date"));
               temp = new GoalSampleDTO(goal, timestamp);

               _power.add(temp);
           }
           result = new GoalSampleDTO[_power.size()];

           Iterator samples = _power.iterator();
           while( samples.hasNext() ) {
        	   temp = (GoalSampleDTO) samples.next();
               result[_power.indexOf(temp)] = temp;   
           }
   		
  		stmt.close();
    	return result;
     }
     
     public GoalSampleDTO[] getMonthGoals(String Date) throws SQLException{
    	 
    	 String query		    = "SELECT Goal as _goal, Date as _date FROM monthly_goals";
    	 Statement stmt 		= null;
    	 GoalSampleDTO temp;
    	 GoalSampleDTO[] result = null;
    	 try {
   			stmt = dbConn.createStatement();
   		 
           ResultSet rs = stmt.executeQuery(query);  
          

           List _power = new ArrayList();

           while(rs.next()) {
               String goal = (rs.getString("_goal"));
               
               Timestamp timestamp = Timestamp.valueOf(rs.getString("_date"));
               temp = new GoalSampleDTO(goal, timestamp);

               _power.add(temp);
           }
           result = new GoalSampleDTO[_power.size()];

           Iterator samples = _power.iterator();
           while( samples.hasNext() ) {
        	   temp = (GoalSampleDTO) samples.next();
               result[_power.indexOf(temp)] = temp;   
           }
   		}
   		catch (SQLException e) {
   			// TODO Auto-generated catch block
   			e.printStackTrace();    
   			stmt.close();

   		}
  		stmt.close();
    	return result;
     }
     
     public boolean insertGoal(String goal, String inst_id, String mode){

    	 String q		    = "INSERT INTO ? (Goal,Date,installation_id ) VALUES (?,?,?)";

    	 if(mode.equals("weekly_goals")){
    		      q 	    = "INSERT INTO weekly_goals (Goal,Date,installation_id ) VALUES (?,?,?)";
    	 }
	   	 else if(mode.equals("daily_goals")){
	     		  q		    = "INSERT INTO daily_goals (Goal,Date,installation_id ) VALUES (?,?,?)";		 
	   	 }
	   	 else if(mode.equals("monthly_goals")){
	     		  q		    = "INSERT INTO monthly_goals (Goal,Date,installation_id ) VALUES (?,?,?)";		 
	   	 } 
    	 
 		Calendar test= Calendar.getInstance();
        boolean resultNew = false;
        PreparedStatement pStmt;
        
 		try{
	 		dbConn.setAutoCommit(false);
			pStmt = dbConn.prepareStatement(q);
			pStmt.setString(1, goal);
			pStmt.setString(2, new Timestamp(test.getTimeInMillis()).toString());
			pStmt.setString(3, inst_id);	
	 		
			resultNew  = pStmt.execute();
		    pStmt.close();
		    dbConn.commit();
 		}
 		catch(SQLException e1){
 			e1.printStackTrace();
			try {
				dbConn.rollback();
			} catch (SQLException e) {
				e.printStackTrace();
			}
 		}
 		return resultNew;
}
     
     public boolean insertVoting(String goal, String role,int vote, int installation_id){
    	
    	String q		    = "INSERT INTO voting_count (goal_name,timestamp,role_associated,vote, installation_id) VALUES (?,?,?,?,?)";
 		Calendar test= Calendar.getInstance();
        boolean resultNew = false;
        PreparedStatement pStmt;
        
 		try{
	 		dbConn.setAutoCommit(false);
			pStmt = dbConn.prepareStatement(q);
			pStmt.setString(1, goal);
			pStmt.setString(2, new Timestamp(test.getTimeInMillis()).toString());
			pStmt.setString(3, role);
			pStmt.setInt(4, vote);	
	 		pStmt.setInt(5, installation_id);
			
			resultNew  = pStmt.execute();
		    pStmt.close();
		    dbConn.commit();
 		}
 		catch(SQLException e1){
 			e1.printStackTrace();
			try {
				dbConn.rollback();
			} catch (SQLException e) {
				e.printStackTrace();
			}
 		}
 		return resultNew;
}
     
 public VoteSampleDTO[] getDayVote(String date) throws SQLException{
    	 
    	 String query		    = "SELECT role_associated as _role, vote as _vote, timestamp as time,  goal_name as _name " +
    	 						  "FROM voting_count WHERE strftime('%Y-%m-%d',time)='"+date+"'";
    	 Statement stmt 		= null;
    	 VoteSampleDTO temp;
    	 VoteSampleDTO[] result = null;
    	 stmt = dbConn.createStatement();
   		 
         ResultSet rs = stmt.executeQuery(query);  
         List _power = new ArrayList();

           while(rs.next()) {
	              int vote = (rs.getInt("_vote"));
	              String role = (rs.getString("_role"));
	              String goal = (rs.getString("_name"));

             temp = new VoteSampleDTO(vote, role, goal);

               _power.add(temp);
           }
           result = new VoteSampleDTO[_power.size()];

           Iterator samples = _power.iterator();
           while( samples.hasNext() ) {
        	   temp = (VoteSampleDTO) samples.next();
               result[_power.indexOf(temp)] = temp;   
           }
   		
  		stmt.close();
    	return result;
     }
    
    
     public boolean removeGoal(String goal, String mode){
    	 String q="";
    	
    	 if(mode.equals("weekly_goals")){
    		  q		    = "DELETE FROM weekly_goals WHERE goal = ?";
    	 }
    	 else if(mode.equals("daily_goals")){
      		  q		    = "DELETE FROM daily_goals WHERE goal = ?";		 
    	 }
    	 else if(mode.equals("monthly_goals")){
      		  q		    = "DELETE FROM monthly_goals WHERE goal = ?";		 
    	 }
    	 
         boolean resultNew = false;
         PreparedStatement pStmt;
         
  		try{
  		dbConn.setAutoCommit(false);
 		pStmt = dbConn.prepareStatement(q);
 		pStmt.setString(1, goal);
  		
 		resultNew  = pStmt.execute();
 	    pStmt.close();
 	    dbConn.commit();
    		 
  		}
  		catch(SQLException e1){
  			e1.printStackTrace();
 			try {
 				dbConn.rollback();
 			} catch (SQLException e) {
 				e.printStackTrace();
 			}
  		}
  		return resultNew;
 }
     
}
