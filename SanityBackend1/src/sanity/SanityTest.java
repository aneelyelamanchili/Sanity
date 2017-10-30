package sanity;

import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.websocket.Session;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import junit.framework.Assert;

public class SanityTest {
	Application sanity;
	Connection conn;
	Statement st;

	@Before
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
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM TotalUsers WHERE Email = 'will@usc.edu';");
			boolean next = rs.next();
			assertEquals(true, next);
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testChangePassword() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "changePassword");
			t1.put("email", "will@usc.edu");
			t1.put("newPassword", "test");
			JSONObject r1 = sanity.editProfile(t1, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM TotalUsers WHERE Email = 'will@usc.edu';");
			if (rs.next()) {
				assertEquals(sanity.hash("test"), rs.getInt("Password"));
			}
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testMakeBudget() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets WHERE userID = 1;");
			assertEquals(true, rs.next());
		}  catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testMakeCategory() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID = 1;");
			assertEquals(true, rs.next());
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testDeleteBudget() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "deleteBigBudget");
			t2.put("userID", 1);
			t2.put("bigBudgetID", 1);
			JSONObject r2 = sanity.deleteBigBudget(t2, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets;");
			assertEquals(false, rs.next());
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testDeleteCategory() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "deleteBudget");
			t3.put("budgetID", 1);
			t3.put("userID", 1);
			JSONObject r3 = sanity.deleteBudget(t3, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets");
			assertEquals(false, rs.next());
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testAddTransaction() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "addTransaction");
			t3.put("budgetID", 1);
			t3.put("userID", 1);
			t3.put("amountToAdd", 40);
			JSONObject r3 = sanity.addTransaction(t3, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM Transactions;");
			assertEquals(true, rs.next());
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testPasswordHash() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM TotalUsers");
			if (rs.next()) {
				assertEquals(sanity.hash("will"), rs.getInt("Password"));
			}
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testLoginPasswordFail() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "login");
			t1.put("email", "will@usc.edu");
			t1.put("password", "wang");
			JSONObject r2 = sanity.signIn(t1, null, conn);
			assertEquals("loginfail", r2.getString("message"));
		} catch (JSONException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testLoginEmailFail() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "login");
			t1.put("email", "wang@usc.edu");
			t1.put("password", "will");
			JSONObject r2 = sanity.signIn(t1, null, conn);
			assertEquals("loginfail", r2.getString("message"));
		} catch (JSONException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testLoginSuccess() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "login");
			t1.put("email", "will@usc.edu");
			t1.put("password", "will");
			JSONObject r2 = sanity.signIn(t1, null, conn);
			assertEquals("loginsuccess", r2.getString("message"));
		} catch (JSONException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testNotification() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		JSONObject t4 = new JSONObject();
		JSONObject t5 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "addTransaction");
			t3.put("budgetID", 1);
			t3.put("userID", 1);
			t3.put("amountToAdd", 40);
			JSONObject r3 = sanity.addTransaction(t3, null, conn);
			t4.put("message", "createBudget");
			t4.put("bigBudgetID", 1);
			t4.put("userID", 1);
			t4.put("budgetAmount", 50);
			t4.put("budgetName", "More fun");
			JSONObject r4 = sanity.createBudget(t4, null, conn);
			t5.put("message", "addTransaction");
			t5.put("budgetID", 1);
			t5.put("userID", 1);
			t5.put("amountToAdd", 41);
			JSONObject r5 = sanity.addTransaction(t5, null, conn);
			assertEquals("yes", r5.getString("notification"));
		} catch (JSONException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testEditBudget() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "editBigBudget");
			t2.put("budgetID", 1);
			t2.put("budgetName", "Edited");
			t2.put("budgetAmount", 300);
			JSONObject r2 = sanity.editBigBudget(t2, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets;");
			if (rs.next()) {
				assertEquals("Edited", rs.getString("BigBudgetName"));
			}
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testEditCategory() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "editBudget");
			t3.put("userID", 1);
			t3.put("budgetID", 1);
			t3.put("budgetName", "Less Fun");
			t3.put("budgetAmount", 100);
			JSONObject r3 = sanity.editBudget(t3, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets;");
			if (rs.next()) {
				assertEquals("Less Fun", rs.getString("BudgetName"));
			}
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testTransactionBudget() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "addTransaction");
			t3.put("budgetID", 1);
			t3.put("userID", 1);
			t3.put("amountToAdd", 40);
			JSONObject r3 = sanity.addTransaction(t3, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets;");
			if (rs.next()) {
				assertEquals(Double.toString(40), Double.toString(rs.getDouble("TotalAmountSpent")));
			}
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
	@Test
	public void testTransactionCategory() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "addTransaction");
			t3.put("budgetID", 1);
			t3.put("userID", 1);
			t3.put("amountToAdd", 40);
			JSONObject r3 = sanity.addTransaction(t3, null, conn);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets;");
			if (rs.next()) {
				assertEquals(Double.toString(40), Double.toString(rs.getDouble("TotalAmountSpent")));
			}
		} catch (JSONException | SQLException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
	@Test
	public void testGetData() {
		sanity.deleteAll(conn);
		JSONObject t = new JSONObject();
		JSONObject t1 = new JSONObject();
		JSONObject t2 = new JSONObject();
		JSONObject t3 = new JSONObject();
		try {
			t.put("message", "signup");
			t.put("firstname", "Will");
			t.put("lastname", "Wang");
			t.put("email", "will@usc.edu");
			t.put("password", "will");
			JSONObject r = sanity.signUp(t, conn);
			t1.put("message", "createBigBudget");
			t1.put("userID", 1);
			t1.put("bigBudgetAmount", 100);
			t1.put("bigBudgetName", "Fun");
			JSONObject r1 = sanity.createBigBudget(t1, null, conn);
			t2.put("message", "createBudget");
			t2.put("bigBudgetID", 1);
			t2.put("userID", 1);
			t2.put("budgetAmount", 50);
			t2.put("budgetName", "More fun");
			JSONObject r2 = sanity.createBudget(t2, null, conn);
			t3.put("message", "addTransaction");
			t3.put("budgetID", 1);
			t3.put("userID", 1);
			t3.put("amountToAdd", 40);
			JSONObject r3 = sanity.addTransaction(t3, null, conn);
			JSONObject result = sanity.getData(conn, 1);
			if (result.getInt("numBudgets") > 0) {
				JSONObject budget = new JSONObject();
				JSONObject category = new JSONObject();
				category.put("categoryAmount", 50);
				category.put("categoryName", "More fun");
				budget.put("category1", category);
				budget.put("size", 1);
				budget.put("budgetAmount", 100);
				budget.put("budgetName", "Fun");
				System.out.println(budget.toString() + result.getJSONObject("budget1").toString());
				assertEquals(budget.toString(), result.getJSONObject("budget1").toString());
			}
		} catch (JSONException | NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}

}
