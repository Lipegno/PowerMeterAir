package model;

public class VoteSampleDTO {
	
	private int _vote;
	private String _role;
	private String _goal;
	
	public VoteSampleDTO(int vote, String role, String goal){
		
		set_vote(vote);
		set_role(role);
		set_goal(goal);
	}

	public void set_role(String _role) {
		this._role = _role;
	}

	public String get_role() {
		return _role;
	}

	public void set_goal(String _goal) {
		this._goal = _goal;
	}

	public String get_goal() {
		return _goal;
	}

	public void set_vote(int _vote) {
		this._vote = _vote;
	}

	public int get_vote() {
		return _vote;
	}
}