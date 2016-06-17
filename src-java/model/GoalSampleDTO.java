package model;

import java.sql.Timestamp;

public class GoalSampleDTO {
	
	//variaveis do Goal
	private String _goal;
	private Timestamp _date;
 

	public GoalSampleDTO(String goal,Timestamp date){	
		_goal = goal;
		_date = date;
	}
	
	public String get_goal() {
		return _goal;
	}


	public Timestamp get_date() {
		return _date;
	}

}
