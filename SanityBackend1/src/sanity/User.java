package sanity;

import java.util.Map;

public class User {
	public String firstName;
	public String lastName;
	public String email;
	public String password;
	
	public Map<String, Budget> budgets;
	public User(String fname, String lname, String e, String p) {
		firstName = fname;
		lastName = lname;
		email = e;
		password = p;
	}
	
	public boolean addBudget() {
		return false;
	}
}
