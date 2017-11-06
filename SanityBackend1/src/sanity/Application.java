package sanity;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;

import javax.websocket.Session;

import org.json.JSONException;
import org.json.JSONObject;



public class Application {
	/* 
	 * rideList is a map mapping rideID's to an ArrayList that holds the usernames that
	 * are going on that ride. rideSize is a map mapping rideID's to the size of that ride.
	 */
	private Map<Integer, User> users = new HashMap<Integer, User>();
//	private Map<>
	public Application() {
		/*
		 * Initially, any data in the database should be added into the maps when the
		 * application is first constructed. Typically, this shouldn't happen but it was
		 * used in testing functionality.
		 */
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Sanity?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}	
	}
	/*
	 * ParseMessage is the main method used for figuring out what to do with a JSONObject sent
	 * from the frontend app to the backend through the WebSocketEndpoint. Here, other functions
	 * are called based on the "message".
	 * Input JSON - "message",_____
	 * Output JSON - object sent back to frontend
	 */
	public void parseMessage(JSONObject message, Session session, WebSocketEndpoint wsep) {
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
	   
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Sanity?user=root&password=root&useSSL=false");
			st = conn.createStatement();
//			System.out.println(message.toString());
	        if (message.get("message").equals("signup")) {
				wsep.sendToSession(session, toBinary(signUp(message, conn)));
			}
	        else if (message.get("message").equals("refreshdata")) {
	        	wsep.sendToSession(session, toBinary(refreshData(message, session, conn)));
	        }
	        else if (message.get("message").equals("refreshdatacategory")) {
	        	wsep.sendToSession(session, toBinary(refreshDataCategory(message, session, conn)));
	        }
			else if (message.get("message").equals("login")) {
				wsep.sendToSession(session, toBinary(signIn(message, session, conn)));
			}
			else if (message.get("message").equals("createBigBudget")) {
				wsep.sendToSession(session, toBinary(createBigBudget(message, session, conn)));
			}
			else if (message.get("message").equals("createBudget")) {
				wsep.sendToSession(session, toBinary(createBudget(message, session, conn)));
			}
			else if (message.get("message").equals("editBigBudget")) {
				wsep.sendToSession(session, toBinary(editBigBudget(message, session, conn)));
			}
			else if (message.get("message").equals("editCategory")) {
				wsep.sendToSession(session, toBinary(editBudget(message, session, conn)));
			}
			else if (message.get("message").equals("deleteBigBudget")) {
				wsep.sendToSession(session, toBinary(deleteBigBudget(message, session, conn)));
			}
			else if (message.get("message").equals("deleteCategory")) {
				wsep.sendToSession(session, toBinary(deleteBudget(message, session, conn)));
			}
			else if (message.get("message").equals("editUser")) {
//				wsep.sendToSession(session, toBinary(refreshData(message, conn)));
			}
			else if (message.get("message").equals("changePassword")) {
				wsep.sendToSession(session, toBinary(editProfile(message, session, conn)));
//				wsep.sendToSession(session, toBinary(editProfile(message, conn)));
			}
			else if (message.get("message").equals("addTransaction")) {
				wsep.sendToSession(session, toBinary(addTransaction(message, session, conn)));
			}
			else if (message.get("message").equals("getAnalytics")) {
				
			}
	       
	        //clear database in each test function before running it
	        
			else if (message.get("message").equals("logintest")) {
				
				wsep.sendToSession(session, toBinary(signInTest(message, session, conn)));
			}
			else if (message.get("message").equals("signuptest")) { //return signupsuccesstest, signupfailtest
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(signUpTest(message, session, conn)));
			}
			else if (message.get("message").equals("changePasswordTest")) { //return passwordSuccessTest, passwordFailTest
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(changePasswordTest(message, session, conn)));
			}
			else if (message.get("message").equals("addToBudgetTest")) { //return addToBudgetSuccessTest/fail
				//creates budget, category and adds transaction
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(addToBudgetTest(message, session, conn)));
			}
			else if (message.get("message").equals("subtractFromBudgetTest")) { //return subtractFromBudgetSuccessTest, success when category/budget amount has decreased
				//same as addToBudgetTest, sends -100 in amountToAdd
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(subtractFromBudgetTest(message, session, conn)));
			}
			else if (message.get("message").equals("transactionHistoryTest")) { //return transactionHistorySuccessTest if pull from transaction table is not 0
				//create budget, create category, add transaction, check that it is not empty
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(transactionHistoryTest(message, session, conn)));
			}
			else if (message.get("message").equals("locationTest")) { //return locationSuccessTest if pull from transaction table is not 0
				//create budget, create category, add transaction with location    markerLatitude, markerLongitude
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(locationTest(message, session, conn)));
			}
			else if (message.get("message").equals("limitNotificationTest")) { //return limitNotificationSuccessTest if pull from transaction table is not 0
				//create budget, category, and transaction (if under 20% left, send successs notification message)
				//
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(limitNotificationTest(message, session, conn)));
			}
			else if (message.get("message").equals("createBigBudgetTest")) { //return createBigBudgetSuccessTest, passwordFailTest
				//return success if budget amount is negative, is over 1000000 and not created in database
				//success if exception caught
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(createBigBudgetTest(message, session, conn)));
			}
			else if (message.get("message").equals("createBudgetTest")) { //return createBudgetSuccessTest, passwordFailTest
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(createBudgetTest(message, session, conn)));
			}
			else if (message.get("message").equals("deleteBigBudgetTest")) { //return deleteBigBudgetSuccessTest, passwordFailTest
//				deleteAll(conn);
				createUser(conn, session);
				wsep.sendToSession(session, toBinary(deleteBigBudgetTest(message, session, conn)));
			}
	        
	        
	        
	        
	        
	        //budget: bigBudgetName, bigBudgetAmount, userID, totalAmountSpent, totalAmountAdded, resetFrequency, resetStartDate
	        //category: budgetName, budgetAmount, bigBudgetID
	        //transaction: amountToAdd, budgetID, markerLatitude, markerLongitude
		} catch (ClassNotFoundException | SQLException | JSONException e) {
			JSONObject response = new JSONObject();
			try {
				response.put("SQLFail", "SQL connection could not be made.");
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
			wsep.sendToSession(session, toBinary(response));
		} finally {
	    	try {
	    		if (rs != null) {
	    			rs.close();
	    		}
	    		if (st != null) {
	    			st.close();
	    		}
	    		if (conn != null) {
	    			conn.close();
	    		}
	    	} catch (SQLException sqle) {
	    		System.out.println(sqle.getMessage());
	    	}
		}
	}

	/*
	 * When a user enters all of their information and clicks sign up, the data is then sent here.
	 * Input - "message","signup"
	 * 		   "firstname",___
	 * 		   "lastname",___
	 * 		   "password",___
	 * 		   "age",___
	 * 		   "email",___
	 * 		   "picture",___
	 * Output - "message","signupsuccess"/"signupfail" 
	 * 			if signupfail --> "signupfail",reason
	 * 			User data returned along with feed data in JSON
	 */
	public JSONObject signUp(JSONObject message, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signupemail = (String) message.get("email");
			if (signupemail.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers");
				while (rs.next()) {
					if (rs.getString("Email").equals(signupemail)) {
						response = getData(conn, rs.getInt("userID"));
						response.put("message", "signupfail");
						response.put("signupfail", "Account already exists.");
						return response;
						//return failed sign up message
					}
				}
				
				String signupfirstname = message.getString("firstname");
				String signuplastname = message.getString("lastname");
				String signuppassword = (String)message.get("password");
				signuppassword.replaceAll("\\s+","");
				
				int s = hash(signuppassword);
				

				
				if (signupfirstname.equals("") || signuplastname.equals("") || signuppassword.equals("") || signupemail.equals("")) {
					response.put("message", "signupfail");
					response.put("signupfail", "Please fill in all of the fields.");
					return response;
					//return failed sign up message
				}

				
				//Account has successful inputs and is now entered into the database.
				
				String addUser = "('" + signupfirstname + "', '" + signuplastname + "', " + s + ", '" + signupemail + "')";
//				String addUser = "('" + signupfirstname + "', '" + signuplastname + "', " + signuppassword + "', '" + signupemail + "')";
				st.execute(Constants.SQL_INSERT_USER + addUser + ";");
				ResultSet rs3 = st.executeQuery("SELECT * FROM TotalUsers WHERE Email='" + signupemail + "';");
				

				if (rs3.next()) {
					int id = rs3.getInt("userID");
					response = getData(conn, id);
					response.put("userID", id);
				}
//				emailSessions.put(signupemail, session);
				response.put("message", "signupsuccess");
				response.put("signupsuccess", "Account was made.");
				response.put("email", signupemail);
				response.put("firstName", signupfirstname);
				response.put("lastName", signuplastname);
				
				
//				previousSearches.put(signupemail, new ArrayList<String>());
				
				//User details for front-end.
//				JSONObject userDetails = addUserToJSON(signupemail, conn);
//				for (String key : JSONObject.getNames(userDetails)) {
//					response.put(key, userDetails.get(key));
//				}
//				JSONObject feedDetails = addFeedToJSON(conn);
//				for (String key : JSONObject.getNames(feedDetails)) {
//					response.put(key, feedDetails.get(key));
//				}
				
				//return all of the details of user and whatever is needed on frontend
				return response;
			}
			else {
				response.put("message", "signupfail");
				response.put("signupfail", "Please enter an email.");
				return response;
				//return failed sign up message
			}
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "signupfail");
				response.put("signupfail", "Sign up failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e1) {
			e1.printStackTrace();
			return null;
		}
	}

	/*
	 * When a user signs in, this is the function that deals with correct/incorrect info.
	 * Input - "message","login"
	 * 		   "email",___
	 * 		   "password",___
	 * Output - "message","loginsuccess"/"loginfail"
	 * 			if loginsuccess --> all of user data and feed data returned in JSON
	 * 			if loginfail --> "loginfail",reason
	 */
	public JSONObject signIn(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signinemail = (String) message.get("email");
			String signinpassword = (String) message.get("password");
			signinpassword.replaceAll("\\s+","");
			int p = hash(signinpassword);
//			System.out.println();
			if (signinemail.length() > 0 && signinpassword.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers WHERE Email='" + signinemail + "';");
				if (rs.next()) {
					if (rs.getInt("Password")==p) {
						
						JSONObject r = getData(conn, rs.getInt("userID"));
						for (String key : JSONObject.getNames(r)) {
							response.put(key, r.get(key));
						}
						System.out.println(response.toString());
						response.put("message", "loginsuccess");
						response.put("loginsuccess", "Logged in.");
						response.put("email", rs.getString("Email"));
						response.put("firstName", rs.getString("FirstName"));
						response.put("lastName", rs.getString("LastName"));
//						int userID = rs.getInt("userID");
						
						
						
						return response;
					}
					else {
						response.put("message", "loginfail");
						response.put("loginfail", "Incorrect password.");
						return response;
					}
				}
				else {
					response.put("message", "loginfail");
					response.put("loginfail", "Email doesn't exist.");
					return response;
				}
			}
			else {
				response.put("message", "loginfail");
				response.put("loginfail", "Please fill in all of the fields.");
				return response;
			}
		} catch (SQLException sqle) {
			try {
				response.put("message", "loginfail");
				response.put("loginfailed", "Login failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		} return response;
	}
	public JSONObject signInTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signinemail = (String) message.get("email");
			String signinpassword = (String) message.get("password");
			signinpassword.replaceAll("\\s+","");
			int p = hash(signinpassword);
//			System.out.println();
			if (signinemail.length() > 0 && signinpassword.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers WHERE Email='" + signinemail + "';");
				if (rs.next()) {
					if (rs.getInt("Password")==p) {
						response.put("message", "loginsuccesstest");
						response.put("loginsuccesstest", "Logged in.");
						response.put("email", rs.getString("Email"));
						response.put("firstName", rs.getString("FirstName"));
						response.put("lastName", rs.getString("LastName"));
//						int userID = rs.getInt("userID");
						
//						return response;
					}
					else {
						response.put("message", "loginfailtest");
						response.put("loginfailtest", "Incorrect password.");
//						return response;
					}
				}
				else {
					response.put("message", "loginfailtest");
					response.put("loginfailtest", "Email doesn't exist.");
//					return response;
				}
			}
			else {
				response.put("message", "loginfailtest");
				response.put("loginfailtest", "Please fill in all of the fields.");
//				return response;
			}
		} catch (SQLException sqle) {
			try {
				response.put("message", "loginfailtest");
				response.put("loginfailtest", "Login failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject editProfile(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String newPassword = message.getString("newPassword");
			String email = message.getString("email");
			rs = st.executeQuery("SELECT * from TotalUsers WHERE Email='" + email + "';");
			if (rs.next()) {
				int p = hash(newPassword);
				st.executeUpdate("UPDATE TotalUsers SET Password=" + p + " WHERE Email='" + email + "';");
				response.put("message", "passwordSuccess");
				response.put("email", rs.getString("Email"));
				response.put("firstName", rs.getString("FirstName"));
				response.put("lastName", rs.getString("LastName"));
			}
			else {
				response.put("message",  "passwordFail");
			}
		} catch(SQLException sqle) {
			
		} catch (JSONException e) {
			e.printStackTrace();
			
		}
		return response;
	}
	
	public JSONObject createBigBudget(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String name = message.getString("bigBudgetName");
			double amount = message.getDouble("bigBudgetAmount");
			int user = message.getInt("userID");
			String addBigBudget = "(" + user + ", '"+ name + "', 1, 34.0222, -118.282, " + amount + ", 0, 3, '4/20', 1);";
			st.execute(Constants.SQL_INSERT_BIGBUDGET + addBigBudget);
//			if (success) {
			response = getData(conn, user);
			response.put("message", "createbudgetsuccess");
//			}
//			else {
//				response.put("message", "createbudgetfail");
//				response.put("createbudgetfail", "Create budget failed not successful.");
//			}
			
			//add budgets to feed
			
			return response;
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "createbudgetfail");
				response.put("createbudgetfail", "Create budget failed.");
				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		}
		return response;
		
	}
	public JSONObject editBigBudget(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int id = message.getInt("bigBudgetID");
			String name = message.getString("bigBudgetName");
//			double amount = message.getDouble("bigBudgetAmount");
			String editBigBudget = "UPDATE BigBudgets SET BigBudgetName='" + name + /*"', BigBudgetAmount=" + amount +*/ "' WHERE bigBudgetID=" + id + ";";
			st.execute(editBigBudget);
			response = getData(conn, message.getInt("userID"));
			response.put("message", "editbudgetsuccess");
			response.put("editbudgetsuccess", "Edit budget success.");
			return response;
			
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "editbudgetfail");
				response.put("editbudgetfail", "Edit budget failed.");
				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		}
		return response;
	}
	
	public JSONObject createBudget(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int user = message.getInt("userID");
			String name = message.getString("budgetName");
			int budgetID = message.getInt("bigBudgetID");
			double amount = message.getDouble("budgetAmount");
			String result = "(" + budgetID + ", " + amount + ", '" + name + "', 0);";
			st.execute(Constants.SQL_INSERT_BUDGET + result);
			response = getData(conn, user);
			response.put("message", "createcategorysuccess");
			return response;
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "createcategoryfailed");
				response.put("createbudgetfail", "Create category failed.");
				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		}
		return response;
	}
	public JSONObject editBudget(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int id = message.getInt("categoryID");
			String name = message.getString("categoryName");
//			double amount = message.getDouble("budgetAmount");
			String editBudget = "UPDATE Budgets SET BudgetName='" + name + /*"', BudgetAmount=" + amount + */"' WHERE budgetID=" + id + ";";
			st.execute(editBudget);
//			response = notify(conn, null, message);
//			JSONObject data = getData(conn, message.getInt("userID"));
//			for (String key : JSONObject.getNames(data)) {
//				response.put(key, data.get(key));
//			}
//			if (!response.getString("message").equals("notification")) {
			response = getData(conn, message.getInt("userID"));
				response.put("message", "editcategorysuccess");
				response.put("editcategorysuccess", "Edit category success.");
//			}
			return response;
			
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "editcategoryfail");
				response.put("editbudgetfail", "Edit budget failed.");
				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		}
		return response;
	}
	
	
	public int hash(String p) {
		int hash = 7;
		for (int i = 0; i < p.length(); i++) {
		    hash = hash*31 + p.charAt(i);
		}
		System.out.println(hash);
		return hash;
	}
	public JSONObject deleteBudget(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int id = message.getInt("categoryID");
			
			String deleteBudget = "DELETE FROM Budgets WHERE budgetID=" + id + ";";
			st.execute(deleteBudget);
			response = getData(conn, message.getInt("userID"));
			response.put("message", "removebudgetsuccess");
			response.put("removebudgetsuccess", "You removed a category.");
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "removebudgetfailure");
				response.put("removebudgetfailure", "SQLException in backend. ID not removed.");
				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return response;
	}
	
	//send getdatasuccess
	public JSONObject refreshData(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			response = getData(conn, message.getInt("userID"));
			response.put("message", "getdatasuccess");
			return response;
		} catch (JSONException e) {
			try {
				response.put("message", "getdatafail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return response;
	}
	public JSONObject refreshDataCategory(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			response = getData(conn, message.getInt("userID"));
			response.put("message", "getdatacategorysuccess");
			return response;
		} catch (JSONException e) {
			try {
				response.put("message", "getdatacategoryfail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return response;
	}
	
	public JSONObject deleteBigBudget(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject(); 
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int id = message.getInt("bigBudgetID");
			
			String deleteBudgetcmd = "DELETE FROM Budgets WHERE bigBudgetID=" + id + ";"; 
			st.execute(deleteBudgetcmd);
			
			String deleteBigBudget = "DELETE FROM BigBudgets WHERE bigBudgetID=" + id + ";";
			st.execute(deleteBigBudget);
			
			response.put("message", "removebigbudgetsuccess");
			response.put("removebigbudgetsuccess", "You removed a budget and its categories.");
			return response;
			
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "removebigbudgetfailure");
				response.put("removebigbudgetfailure", "SQLException in backend. ID not removed.");
				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return response;
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return response;
	}
	
	
	
	
	public JSONObject getData(Connection conn, int userID) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets WHERE userID = " + userID + ";");
			response.put("userID", userID);
			int budcounter = 0;
			while (rs.next()) {
//				System.out.println(rs.getString("BigBudgetName"));
				budcounter++;
				JSONObject currBudget = new JSONObject();
				int bbID = rs.getInt("bigBudgetID");
				
				currBudget.put("budgetName", rs.getString("BigBudgetName"));
				currBudget.put("budgetAmount", rs.getDouble("BigBudgetAmount"));
				currBudget.put("daysLeft", rs.getInt("BigBudgetDaysLeft"));
				currBudget.put("budgetID", bbID);
				
				Statement st1 = conn.createStatement();
				ResultSet rs1 = st1.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID = " + bbID + ";");
				int catcounter = 0;
				while (rs1.next()) {
//					System.out.println("add category");
					catcounter++;
					JSONObject currCat = new JSONObject();
					
					currCat.put("categoryName", rs1.getString("BudgetName"));
					currCat.put("categoryAmount", rs1.getDouble("BudgetAmount"));
					currCat.put("categoryID", rs1.getInt("budgetID"));
					
					currBudget.put("category" + catcounter, currCat);
				}
				currBudget.put("numCategories", catcounter);
//				System.out.println(currBudget.toString());
				response.put("budget" + budcounter, currBudget);
				
			}
			response.put("numBudgets", budcounter);
		} catch (JSONException | SQLException e) {
			System.out.println("Exception caught in getData." + e.getMessage());
		}
		return response;
	}
	
	public JSONObject addTransaction(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int budgetID = message.getInt("budgetID");
			//latitude, longitude, details
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", '', 0, 0);");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
//			System.out.println("rs");
			int bigBudgetID=0;
			double budgetSpent=0;
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent") + amount;
				System.out.println(bigBudgetID);
			}
//			System.out.println("rs");
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
//			System.out.println("rs1");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0;
			String bigbudgetName = "";
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent")+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + budgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + bigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (bigBudgetSpent > (0.8*(bigbudgetAmount))) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in budget" + bigbudgetName);
			}
			else {
				response.put("notification", "no");
			}
			response.put("message", "addTransactionSuccess");
		}
		catch (SQLException | JSONException e) {
			e.printStackTrace();
			try {
				response.put("message", "addTransactionFail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		}
//		deleteAll(conn);
		return response;
	}
	
	
	public JSONObject notify(Connection conn, Session session, JSONObject message) {
		return null;
	}
	
	
	public JSONObject signUpTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String signupemail = (String) message.get("email");
			if (signupemail.length() > 0) {
				rs = st.executeQuery("SELECT * from TotalUsers");
				while (rs.next()) {
					if (rs.getString("Email").equals(signupemail)) {
						response = getData(conn, rs.getInt("userID"));
						response.put("message", "signupfailtest");
						response.put("signupfailtest", "Account already exists.");
						return response;
						//return failed sign up message
					}
				}
				
				String signupfirstname = message.getString("firstname");
				String signuplastname = message.getString("lastname");
				String signuppassword = (String)message.get("password");
				signuppassword.replaceAll("\\s+","");
				
				int s = hash(signuppassword);
				

				
				if (signupfirstname.equals("") || signuplastname.equals("") || signuppassword.equals("") || signupemail.equals("")) {
					response.put("message", "signupfailtest");
					response.put("signupfailtest", "Please fill in all of the fields.");
					return response;
					//return failed sign up message
				}

				
				//Account has successful inputs and is now entered into the database.
				
				String addUser = "('" + signupfirstname + "', '" + signuplastname + "', " + s + ", '" + signupemail + "')";
//				String addUser = "('" + signupfirstname + "', '" + signuplastname + "', " + signuppassword + "', '" + signupemail + "')";
				st.execute(Constants.SQL_INSERT_USER + addUser + ";");
//				emailSessions.put(signupemail, session);
				response.put("message", "signupsuccesstest");
				response.put("signupsuccesstest", "Account was made.");
				response.put("email", signupemail);
				response.put("firstName", signupfirstname);
				response.put("lastName", signuplastname);
				
//				previousSearches.put(signupemail, new ArrayList<String>());
				
				//User details for front-end.
//				JSONObject userDetails = addUserToJSON(signupemail, conn);
//				for (String key : JSONObject.getNames(userDetails)) {
//					response.put(key, userDetails.get(key));
//				}
//				JSONObject feedDetails = addFeedToJSON(conn);
//				for (String key : JSONObject.getNames(feedDetails)) {
//					response.put(key, feedDetails.get(key));
//				}
				
				//return all of the details of user and whatever is needed on frontend
//				return response;
			}
			else {
				response.put("message", "signupfailtest");
				response.put("signupfailtest", "Please enter an email.");
//				return response;
				//return failed sign up message
			}
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "signupfailtest");
				response.put("signupfailtest", "Sign up failed.");
			} catch (JSONException e) {
				e.printStackTrace();
			}
//			return response;
	    } catch (JSONException e1) {
			e1.printStackTrace();
			
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject changePasswordTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String newPassword = message.getString("newPassword");
			String email = message.getString("email");
			int p = hash(newPassword);
			rs = st.executeQuery("SELECT * from TotalUsers WHERE Email='" + email + "';");
			if (rs.next()) {
				st.executeUpdate("UPDATE TotalUsers SET Password=" + p + " WHERE Email='" + email + "';");
				response.put("message", "passwordSuccessTest");
				response.put("email", rs.getString("Email"));
				response.put("firstName", rs.getString("FirstName"));
				response.put("lastName", rs.getString("LastName"));
			}
			else {
				response.put("message",  "passwordFailTest");
			}
		} catch(SQLException sqle) {
			
		} catch (JSONException e) {
			e.printStackTrace();
			
		}
		deleteAll(conn);
		return response;
	}

	public JSONObject createBigBudgetTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String name = message.getString("bigBudgetName");
			double amount = message.getDouble("bigBudgetAmount");
			int user = message.getInt("userID");
			boolean success;
			if (amount > 0 && amount <= 1000000) {
				String addBigBudget = "(" + user + ", '"+ name + "', 1, 34.0222, -118.282, " + amount + ", 0)";
				st.execute(Constants.SQL_INSERT_BIGBUDGET + addBigBudget);
			}
			else {
				success = true;
			}
			response.put("message", "createBigBudgetSuccessTest");
			
			
			//add budgets to feed
			
//			return response;
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "createBigBudgetSuccessTest");
				response.put("createBigBudgetSuccessTest", "Create budget failed.");
//				return response;
			} catch (JSONException e) {
				try {
					response.put("message", "createBigBudgetSuccessTest");
					response.put("createBigBudgetSuccessTest", "Create budget failed.");
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				e.printStackTrace();
				
			}
//			return response;
	    } catch (JSONException e) {
	    	try {
				response.put("message", "createBigBudgetSuccessTest");
				response.put("createBigBudgetSuccessTest", "didn't create");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	    	
			e.printStackTrace();
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject createBudgetTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int user = message.getInt("userID");
			String name = message.getString("budgetName");
			int budgetID = message.getInt("bigBudgetID");
			double amount = message.getDouble("budgetAmount");
			String result = "(" + budgetID + ", " + amount + ", '" + name + "',0);";
			boolean success = st.execute(Constants.SQL_INSERT_BUDGET + result);
			response.put("message", "createBudgetSuccessTest");
//			return response;
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "createBudgetFailTest");
				response.put("createBudgetFailTest", "Create category failed.");
//				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
//			return response;
	    } catch (JSONException e) {
			e.printStackTrace();
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject deleteBigBudgetTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject(); 
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int id = message.getInt("bigBudgetID");
			
			String deleteBudgetcmd = "DELETE FROM Budgets WHERE bigBudgetID=" + id + ";"; 
			st.execute(deleteBudgetcmd);
			
			String deleteBigBudget = "DELETE FROM BigBudgets WHERE bigBudgetID=" + id + ";";
			st.execute(deleteBigBudget);
			
			response.put("message", "deleteBigBudgetSuccessTest");
			response.put("deleteBigBudgetSuccessTest", "You removed a budget and its categories.");
//			return response;
			
		} catch (SQLException sqle) {
			try {
				sqle.printStackTrace();
				response.put("message", "deleteBigBudgetFailTest");
				response.put("deleteBigBudgetFailTest", "SQLException in backend. ID not removed.");
//				return response;
			} catch (JSONException e) {
				e.printStackTrace();
			}
//			return response;
		} catch (JSONException e) {
			e.printStackTrace();
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject addToBudgetTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int budgetID = message.getInt("budgetID");
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", '', 0, 0);");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
			System.out.println("rs");
			int bigBudgetID=0;
			double budgetSpent=0;
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent") + amount;
				System.out.println(bigBudgetID);
			}
			System.out.println("rs");
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
			System.out.println("rs1");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0;
			String bigbudgetName = "";
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent")+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + budgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + bigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (bigBudgetSpent > 0.8*(bigbudgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in budget" + bigbudgetName);
			}
			response.put("message", "addToBudgetSuccessTest");
		}
		catch (SQLException | JSONException e) {
			try {
				response.put("message", "addToBudgetFailTest");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject subtractFromBudgetTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int budgetID = message.getInt("budgetID");
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", '', 0, 0);");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
			int bigBudgetID=0;
			double budgetSpent=0;
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent") + amount;
				System.out.println(bigBudgetID);
			}
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0;
			String bigbudgetName = "";
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent")+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + budgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + bigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (bigBudgetSpent > 0.8*(bigbudgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in budget" + bigbudgetName);
			}
			response.put("message", "subtractFromBudgetSuccessTest");
		}
		catch (SQLException | JSONException e) {
			try {
				response.put("message", "subtractFromBudgetFailTest");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		}
		deleteAll(conn);
		return response;
	}
	public JSONObject transactionHistoryTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int budgetID = message.getInt("budgetID");
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", '', 0, 0);");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
			int bigBudgetID=0;
			double budgetSpent=0;
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent") + amount;
				System.out.println(bigBudgetID);
			}
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0;
			String bigbudgetName = "";
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent")+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + budgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + bigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (bigBudgetSpent > 0.8*(bigbudgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in budget" + bigbudgetName);
			}
			ResultSet rs2 = st.executeQuery("SELECT * FROM Transactions;");
			if (rs2.next()) {
				response.put("message", "transactionHistorySuccessTest");
			}
			else {
				response.put("message", "transactionHistoryFailTest");
			}
		}
		catch (SQLException | JSONException e) {
			try {
				response.put("message", "transactionHistoryFailTest");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		}
		deleteAll(conn);
		return response;
	}
	
	public JSONObject locationTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int budgetID = message.getInt("budgetID");
			double latitude = message.getDouble("markerLatitude");
			double longitude = message.getDouble("markerLongitude");
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", ''," + latitude + ", " + longitude + ");");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
			int bigBudgetID=0;
			double budgetSpent=0;
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent") + amount;
				System.out.println(bigBudgetID);
			}
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0;
			String bigbudgetName = "";
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent")+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + budgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + bigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (bigBudgetSpent > 0.8*(bigbudgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in budget" + bigbudgetName);
			}
			ResultSet rs2 = st.executeQuery("SELECT * FROM Transactions;");
			if (rs2.next()) {
				if (rs2.getDouble("Longitude") == message.getDouble("markerLongitude") && rs2.getDouble("Latitude") == message.getDouble("markerLatitude"))
					response.put("message", "locationSuccessTest");
				else {
					response.put("message", "locationFailTest");
				}
			}
			else {
				response.put("message", "locationFailTest");
			}
		}
		catch (SQLException | JSONException e) {
			try {
				response.put("message", "locationFailTest");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		}
		deleteAll(conn);
		return response;
	}
	
	public JSONObject limitNotificationTest(JSONObject message, Session session, Connection conn) {
		JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int budgetID = message.getInt("budgetID");
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", '', 0, 0);");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
			int bigBudgetID=0;
			double budgetSpent=0;
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent") + amount;
				System.out.println(bigBudgetID);
			}
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0;
			String bigbudgetName = "";
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent")+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + budgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + bigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (bigBudgetSpent > 0.8*(bigbudgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in budget" + bigbudgetName);
			}
			ResultSet rs2 = st.executeQuery("SELECT * FROM Transactions;");
			response.put("message", "limitNotificationSuccessTest");
		}
		catch (SQLException | JSONException e) {
			try {
				response.put("message", "limitNotificationFailTest");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		
		}
		deleteAll(conn);
		return response;
	}
	
	

	//budget: bigBudgetName, bigBudgetAmount, userID, totalAmountSpent, totalAmountAdded, resetFrequency, resetStartDate
    //category: budgetName, budgetAmount, bigBudgetID
    //transaction: amountToAdd, budgetID, markerLatitude, markerLongitude



//	else if (message.get("message").equals("limitNotificationTest")) { //return limitNotificationSuccessTest if pull from transaction table is not 0
//		//create budget, category, and transaction (if under 20% left, send successs notification message)
//		//
//		wsep.sendToSession(session, toBinary(limitNotificationTest(message, session, conn)));
//	}
	
	

	public void createUser(Connection conn, Session session) {
		try {
		Statement st = conn.createStatement();
		int h1 = hash("a");
		int h2 = hash("sealand");
		st.execute(Constants.SQL_INSERT_USER + "('Test', 'Tester', " + h1 + ", 'a');");
		st.execute(Constants.SQL_INSERT_USER + "('David', 'Sealand', " + h2 + ", 'sealand@usc.edu');");
		} catch (SQLException sqle) {
			sqle.printStackTrace();
		}
	}
	public void deleteAll(Connection conn) {
		try {
			Statement st = conn.createStatement();
			PreparedStatement psmt = null;
			psmt = conn.prepareStatement(Constants.SQL_DELETE_TRANSACTIONS);
			psmt.execute();
			psmt = null;
			psmt = conn.prepareStatement(Constants.SQL_DELETE_BUDGETS);
			psmt.execute();
			psmt = null;
			psmt = conn.prepareStatement(Constants.SQL_DELETE_BIGBUDGETS);
			psmt.execute();
			psmt = null;
			psmt = conn.prepareStatement(Constants.SQL_DELETE_USERS);
			psmt.execute();
//			st.execute(Constants.SQL_DELETE_BIGBUDGETS);
//			st.execute(Constants.SQL_DELETE_BUDGETS);
//			st.execute(Constants.SQL_DELETE_TRANSACTIONS);
//			st.execute(Constants.SQL_DELETE_USERS);
			st.execute(Constants.SQL_ALTER_BIGBUDGETS);
			st.execute(Constants.SQL_ALTER_BUDGETS);
			st.execute(Constants.SQL_ALTER_USERS);
			st.execute(Constants.SQL_ALTER_TRANSACTIONS);
			
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	/*
	 * Converts the JSONObject into binary so that it can be sent to the frontend.
	 */
	public byte[] toBinary(JSONObject message) {
		String messageToConvert = message.toString();
		byte[] converted = null;
		try {
			converted = messageToConvert.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return converted;
	}
//	public Session getSession(String email) {
//		if (emailSessions.get(email)!=null) {
//			return emailSessions.get(email);
//		}
//		return null;
//	}
//	public void removeSession(Session session) {
//		for (String key : emailSessions.keySet()) {
//		    if (emailSessions.get(key) == session) {
//		    	emailSessions.remove(key);
//		    }
//		}
//	}
	
	
	
	
}
