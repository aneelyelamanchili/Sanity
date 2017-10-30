package sanity;

import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Test;

import junit.framework.Assert;

public class SanityTest {
	Application sanity;
	Connection conn;
	Statement st;

	public void setUp() {
		sanity = new Application();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Sanity?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}	
	}
	
	@Test
	public void testMakeAccount() {
		JSONObject t = new JSONObject();
		try {
			t.put("message", "signup");
			t.put(", value)
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void testChangePassword() {
		
	}
	public void testMakeBudget() {
		
	}
	public void testMakeCategory() {
		
	}
	public void deleteBudget() {
		
	}
	public void deleteCategory() {
		
	}
	public void addTransaction() {
		
	}
	public void testPasswordHash() {
		
	}

}
