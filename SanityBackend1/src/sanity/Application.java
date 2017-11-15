package sanity;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;

import javax.websocket.Session;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;



public class Application {
	/* 
	 * rideList is a map mapping rideID's to an ArrayList that holds the usernames that
	 * are going on that ride. rideSize is a map mapping rideID's to the size of that ride.
	 */
	private Map<Integer, User> users = new HashMap<Integer, User>();
	JSONObject response;
	JSONObject transNotif;
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
	    response = new JSONObject();
//	    transNotif = new JSONObject();
	    try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Sanity?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			JSONObject r = new JSONObject();
			if (!message.get("message").equals("signup") && !message.get("message").equals("login")) {
				r = notifyPeriod(message, session, conn);
			}
			else {
				r = null;
			}
			if (r!=null) {
				wsep.sendToSession(session, toBinary(r));
			}
			response = new JSONObject();
//			System.out.println(message.toString());
	        if (message.get("message").equals("signup")) {
				wsep.sendToSession(session, toBinary(signUp(message, conn)));
			}
	        else if (message.get("message").equals("editBigBudgetAttributes")) {
	        	wsep.sendToSession(session, toBinary(editBigBudgetAttributes(message, session, conn)));
	        }
	        else if (message.get("message").equals("refreshdata")) {
	        	wsep.sendToSession(session, toBinary(refreshData(message, session, conn)));
	        }
	        else if (message.get("message").equals("refreshdatacategory")) {
	        	wsep.sendToSession(session, toBinary(refreshDataCategory(message, session, conn)));
	        }
	        else if (message.get("message").equals("refreshdatatransaction")) {
	        	wsep.sendToSession(session, toBinary(refreshDataTransaction(message, session, conn)));
	        }
	        else if (message.get("message").equals("refreshdatahistory")) {
	        	wsep.sendToSession(session, toBinary(refreshDataHistory(message, session, conn)));
	        }
			else if (message.get("message").equals("login")) {
				wsep.sendToSession(session, toBinary(signIn(message, session, conn)));
//				if (r!=null) {
//					wsep.sendToSession(session, toBinary(r));
//				}
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
			else if (message.get("message").equals("editTransactionDescription")) {
				wsep.sendToSession(session, toBinary(renameTransaction(message, session, conn)));
			}
			else if (message.get("message").equals("deleteTransaction")) {
				wsep.sendToSession(session, toBinary(deleteTransaction(message, session, conn)));
			}
			else if (message.get("message").equals("deleteAllTransactions")) {
				wsep.sendToSession(session, toBinary(deleteAllTransactions(message, session, conn)));
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
			//JSONObject response = new JSONObject();
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

	public JSONObject notifyPeriod(JSONObject message, Session session, Connection conn) {
		try {
			Statement st = conn.createStatement();
			int userID = message.getInt("userID");
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets WHERE userID = " + userID + ";");
			while (rs.next()) {
				int bbID = rs.getInt("bigBudgetID");
				String bbName = rs.getString("BigBudgetName");
				int daysLeft = rs.getInt("BigBudgetDaysLeft");
				int frequency = rs.getInt("Frequency");
				String startDateString = rs.getString("Date");
				DateFormat df = new SimpleDateFormat("MM/dd/yyyy"); 
				Date startDate = null;
				try {
				    startDate = df.parse(startDateString);
				    String newDateString = df.format(startDate);
				    System.out.println(newDateString);
				} catch (ParseException e) {
				    e.printStackTrace();
				}
				
				Date date = new Date();
				if (startDate.before(date)) {
					return null;
				}
				else if (startDate.after(date)) {
					String newDate = df.format(date);
					long difference = startDate.getTime() - date.getTime();
				    int daysBetween = (int)(difference / (1000*60*60*24));
					daysLeft-=daysBetween;
					System.out.println("number of days between: " + daysBetween + " and days left: " + daysLeft);
					if (daysLeft <= 0) {
						double spent = rs.getFloat("TotalAmountSpent");
						double amount = rs.getFloat("BigBudgetAmount");
						Statement st2 = conn.createStatement();
//						if (spent>amount) {
						st2.executeUpdate("UPDATE BigBudgets SET BigBudgetDaysLeft=" + frequency + ", Date='" + newDate + "', TotalAmountSpent=0 WHERE BigBudgetID=" + bbID + ";");
//						}
//						else {
//							st2.executeUpdate("UPDATE BigBudgets SET BigBudgetDaysLeft=" + frequency + ", Date='" + newDate + "', TotalAmountSpent=" + (-(amount-spent)) + " WHERE BigBudgetID=" + bbID + ";");
//						}
						if (rs.getString("BigBudgetName").equals("Annual Savings")) {
							response.put("message", "periodNotification");
							response.put("notify", "You saved " + amount + " over the last year.");
							Statement st5 = conn.createStatement();
							ResultSet rs5 = st5.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID=" + bbID + ";");
							while (rs5.next()) {
								Statement st6 = conn.createStatement();
								st6.execute("UPDATE Budgets SET TotalAmountSpent=0 WHERE bigBudgetID=" + bbID + ";");
								st6.execute("DELETE FROM Transactions WHERE budgetID=" + rs5.getInt("budgetID"));
							}
							
						}
						else {
							response.put("message", "periodNotification");
							response.put("notify", bbName + " was reset. You spent " + String.format("%.2f",(spent/amount*100)) + "% of your budget this period, $" + spent + " out of $" + amount + ".");
							Statement st1 = conn.createStatement();
							ResultSet rs1 = st1.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID=" + bbID + ";");
							double saved = amount-spent;
							Statement st7 = conn.createStatement();
							ResultSet rs9 = st7.executeQuery("SELECT * FROM BigBudgets WHERE BigBudgetName='Annual Savings';");
							if (rs9.next()) {
								Statement st8 = conn.createStatement();
								st8.execute("UPDATE BigBudgets SET BigBudgetAmount=" + (rs9.getDouble("BigBudgetAmount")+saved) + " WHERE bigBudgetID=" + rs9.getInt("bigBudgetID") + ";");
							}
							
	
							while (rs1.next()) {
								Statement st3 = conn.createStatement();
								double aSpent = rs1.getDouble("TotalAmountSpent");
								double aAmount = rs1.getDouble("BudgetAmount");
								
								st3.execute("UPDATE Budgets SET TotalAmountSpent=0 WHERE bigBudgetID=" + bbID + ";");
								st3.execute("DELETE FROM Transactions WHERE budgetID=" + rs1.getInt("budgetID"));
							}
						}
					}
					else {
						Statement st4 = conn.createStatement();
						st4.executeUpdate("UPDATE BigBudgets SET BigBudgetDaysLeft=" + daysLeft + ", Date='" + newDate + "' WHERE BigBudgetID=" + bbID + ";");
						return null;
					}
				}
			}
			
			
		} catch(JSONException | SQLException e) {
			e.printStackTrace();
		}
		return response;
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
		//JSONObject response = new JSONObject();
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
					Statement st1 = conn.createStatement();
					
					DateFormat df = new SimpleDateFormat("MM/dd/yyyy");			
					Date date = new Date();
					String newDate = df.format(date);
					System.out.println(newDate);
					
					String addBigBudget = "(" + id + ", 'Annual Savings', 1, 0, 0, 0, 0, 365, '" + newDate + "', 365);";
					st1.execute(Constants.SQL_INSERT_BIGBUDGET + addBigBudget);
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
		//JSONObject response = new JSONObject();
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
//						System.out.println(response.toString());
						response.put("message", "loginsuccess");
						response.put("loginsuccess", "Logged in.");
						response.put("email", rs.getString("Email"));
						response.put("firstName", rs.getString("FirstName"));
						response.put("lastName", rs.getString("LastName"));
//						int userID = rs.getInt("userID");
						message.put("userID", rs.getInt("userID"));
//						r = notifyPeriod(message, session, conn);
						
						
						
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			String name = message.getString("bigBudgetName");
			double amount = message.getDouble("bigBudgetAmount");
			int user = message.getInt("userID");
			String date = message.getString("resetStartDate");
			String frequency = message.getString("resetFrequency");
			int freq = 0;
			if (frequency.equals("Daily")) {
				freq = 1;
			}
			else if (frequency.equals("Weekly")) {
				freq = 7;
			}
			else if (frequency.equals("Monthly")) {
				freq = 30;
			}
			else if (frequency.equals("Yearly")) {
				freq = 365;
			}
			else if (frequency.equals("")) {
				freq = 30; //default is monthly
			}
			else {
				response = getData(conn, user);
				response.put("message", "createBigBudgetFail");
				response.put("createBigBudgetFail", "Enter a correct frequency (Daily, Weekly, Monthly, Yearly)");
				return response;
			}
			System.out.println(date);
			String addBigBudget = "(" + user + ", '"+ name + "', 1, 34.0222, -118.282, " + amount + ", 0, " + freq + ", '" + date + "', " + freq + ");";
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
	public JSONObject editBigBudgetAttributes(JSONObject message, Session session, Connection conn) {
		//frequency, bigbudgetID, frequency will be string but parsable to int for custom
		return null; //add to editBigBudget
	}
	public JSONObject editBigBudget(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int id = message.getInt("bigBudgetID");
			String name = message.getString("bigBudgetName");
			String newAmount = message.getString("budgetAmount");
			String frequency = message.getString("frequency");
			
			if (!name.equals("")) {
				String editBigBudget = "UPDATE BigBudgets SET BigBudgetName='" + name + /*"', BigBudgetAmount=" + amount +*/ "' WHERE bigBudgetID=" + id + ";";
				st.execute(editBigBudget);
			}
			if (!newAmount.equals("")) {
				double amount = message.getDouble("budgetAmount");
				rs = st.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID=" + id + ";");
				double sum = 0;
				while (rs.next()) {
					sum += rs.getDouble("BudgetAmount");
				}
				if (sum >= amount) {
					response = getData(conn, message.getInt("userID"));
					response.put("message", "editbudgetfail");
					response.put("editbudgetfail", "You can't make the budget amount less than the sum of the categories.");
					return response;
				}
				else {
					String editBigBudget = "UPDATE BigBudgets SET BigBudgetAmount=" + amount + " WHERE bigBudgetID=" + id + ";";
					st.execute(editBigBudget);
				}
			}
			if (!frequency.equals("")) {
				int freq = 0;
				if (frequency.equalsIgnoreCase("Daily")) {
					freq = 1;
				}
				else if (frequency.equalsIgnoreCase("Weekly")) {
					freq = 7;
				}
				else if (frequency.equalsIgnoreCase("Monthly")) {
					freq = 30;
				}
				else if (frequency.equalsIgnoreCase("Yearly")) {
					freq = 365;
				}
				else {
					try {
						freq = Integer.parseInt(frequency);
					} catch (NumberFormatException e) {
						response = getData(conn, message.getInt("userID"));
						response.put("message", "editbudgetfail");
						response.put("editbudgetfail", "Invalid frequency added.");
						return response;
					}
				}
				st.execute("UPDATE BigBudgets SET Frequency=" + freq + ", BigBudgetDaysLeft=" + freq + " WHERE bigBudgetID=" + id + ";");
			}
			
			
			
//			double amount = message.getDouble("bigBudgetAmount");
			
//			st.execute(editBigBudget);
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = null;
			int id = message.getInt("categoryID");
			String name = message.getString("categoryName");
			String amount = message.getString("categoryAmount");
			String editBudget = "";
			if (!name.equals("")) {
				editBudget = "UPDATE Budgets SET BudgetName='" + name + /*"', BudgetAmount=" + amount + */"' WHERE budgetID=" + id + ";";
				st.execute(editBudget);
			}
			if (!amount.equals("")) {
				double a = message.getDouble("categoryAmount");
				rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID=" + id + ";");
				int bbID = 0;
				if (rs.next()) {
					bbID = rs.getInt("bigBudgetID");
				}
				Statement st1 = conn.createStatement();
				ResultSet rs1 = st1.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID=" + bbID + ";");
				double sum = 0;
				if (rs1.next()) {
					if (rs1.getInt("budgetID") != id) {
						sum += rs1.getDouble("BudgetAmount");
					}
				}
				Statement st2 = conn.createStatement();
				ResultSet rs2 = st2.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID=" + bbID + ";");
				double bigBudgetAmount = 0;
				if (rs2.next()) {
					bigBudgetAmount = rs2.getDouble("BigBudgetAmount");
				}
				if ((sum+a)<=bigBudgetAmount) {
					editBudget = "UPDATE Budgets SET BudgetAmount=" + amount + " WHERE budgetID=" + id + ";";
					st.execute(editBudget);
				}
				else {
					response = getData(conn, message.getInt("userID"));
					response.put("message", "editcategoryfail");
					response.put("editcategoryfail", "You can't make the category amounts sum to more than the budget limit.");
					return response;
				}
				//TODO make sure it doesn't go over BigBUDGETAMOUTN
			}
//			else {
//				editBudget = "UPDATE Budgets SET BudgetName='" + name + "', BudgetAmount=" + amount + " WHERE budgetID=" + id + ";";
//				st.execute(editBudget);
//			}
			
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
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int id = message.getInt("categoryID");
			
			String deleteTransactions = "DELETE FROM Transactions WHERE budgetID=" + id + ";";
			st.execute(deleteTransactions);
			
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID=" + id + ";");
			double addBack = 0;
			int bigBudgetID = 0;
			if (rs.next()) {
				addBack = rs.getFloat("TotalAmountSpent");
				bigBudgetID = rs.getInt("bigBudgetID");
			}
			
			String deleteBudget = "DELETE FROM Budgets WHERE budgetID=" + id + ";";
			st.execute(deleteBudget);
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
			double bbAmountSpent = 0;
			if (rs1.next()) {
				bbAmountSpent = rs1.getFloat("TotalAmountSpent");
			}
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent=" + (bbAmountSpent-addBack) + " WHERE bigBudgetID=" + bigBudgetID + ";");
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
	public JSONObject refreshDataTransaction(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		try {
			response = getData(conn, message.getInt("userID"));
			if (transNotif != null) {
				response.put("notification", "yes");
				response.put("notify", transNotif.get("notify"));
			}
			else {
				response.put("notification", "no");
			}
			response.put("message", "getdatatransactionsuccess");
			return response;
		} catch (JSONException e) {
			try {
				response.put("message", "getdatatransactionfail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return response;
	}
	public JSONObject refreshDataHistory(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		try {
			response = getData(conn, message.getInt("userID"));
			response.put("message", "getdatahistorysuccess");
			return response;
		} catch (JSONException e) {
			try {
				response.put("message", "getdatahistoryfail");
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
		//JSONObject response = new JSONObject(); 
		try {
			Statement st = conn.createStatement();
			int id = message.getInt("bigBudgetID");
			
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE bigBudgetID=" + id + ";");
			Statement st1 = conn.createStatement();
			while (rs.next()) {
				st1.execute("DELETE FROM Transactions WHERE budgetID=" + rs.getInt("budgetID") + ";");
			}
			
			String deleteBudgetcmd = "DELETE FROM Budgets WHERE bigBudgetID=" + id + ";"; 
			st1.execute(deleteBudgetcmd);
			
			String deleteBigBudget = "DELETE FROM BigBudgets WHERE bigBudgetID=" + id + ";";
			st1.execute(deleteBigBudget);
			
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
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM BigBudgets WHERE userID = " + userID + ";");
			response.put("userID", userID);
			int budcounter = 1;
			while (rs.next()) {
//				System.out.println(rs.getString("BigBudgetName"));
				budcounter++;
				JSONObject currBudget = new JSONObject();
				int bbID = rs.getInt("bigBudgetID");
				
				currBudget.put("budgetName", rs.getString("BigBudgetName"));
				currBudget.put("budgetAmount", rs.getDouble("BigBudgetAmount"));
				currBudget.put("totalAmountSpent", rs.getDouble("TotalAmountSpent"));
				currBudget.put("daysLeft", rs.getInt("BigBudgetDaysLeft"));
				currBudget.put("budgetID", bbID);
				int f = rs.getInt("Frequency");
				if (f==1) {
					currBudget.put("frequency", "Daily");
				}
				else if (f==7) {
					currBudget.put("frequency", "Weekly");
				}
				else if (f==30) {
					currBudget.put("frequency", "Monthly");
				}
				else if (f==365) {
					currBudget.put("frequency", "Yearly");
				}
				else {
					currBudget.put("frequency", f + " days");
				}
				
				
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
					currCat.put("totalAmountSpent", rs1.getDouble("TotalAmountSpent"));
					
					//Nest transactions into categories 
					Statement st2 = conn.createStatement();
					ResultSet rs2 = st2.executeQuery("SELECT * FROM Transactions WHERE budgetID = " + rs1.getInt("budgetID") + ";");
					JSONArray transJSONArr = new JSONArray();
					int transCounter = 0;
					while(rs2.next()) {
						JSONObject transJSON = new JSONObject();
						double a = rs2.getDouble("Amount");
						String tAmount;
						if (a < 0) {
							tAmount = "+" + String.format("%.2f", -a);
						}
						else {
							tAmount = "-" + String.format("%.2f", a);
						}
						transJSON.put("transactionAmount", tAmount);
						transJSON.put("transactionDetails", rs2.getString("Details"));
						transJSON.put("Longitude", rs2.getFloat("Longitude"));
						transJSON.put("Latitude", rs2.getFloat("Latitude"));
						transJSON.put("Date", rs2.getString("DateValue"));
						transJSON.put("transactionID", rs2.getInt("transactionID"));
						transCounter++;
						transJSONArr.put(transJSON);
					}
					currCat.put("transactionSize", transCounter);
					
					currCat.put("transactions", transJSONArr);
					currBudget.put("category" + catcounter, currCat);
				}
				currBudget.put("numCategories", catcounter);
//				System.out.println(currBudget.toString());
				if (rs.getString("BigBudgetName").equals("Annual Savings")) {
					response.put("budget1", currBudget);
					budcounter--;
				}
				else {
					response.put("budget" + budcounter, currBudget);
				}
				
				
			}
			response.put("numBudgets", budcounter);
		} catch (JSONException | SQLException e) {
			System.out.println("Exception caught in getData." + e.getMessage());
		}
		return response;
	}
	
	public JSONObject addTransaction(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		transNotif = new JSONObject();
		try {
			Statement st = conn.createStatement();
			double amount = message.getDouble("amountToAdd");
			int userID = message.getInt("userID");
			int budgetID = message.getInt("categoryID");
			double latitude = message.getDouble("latitude");
			double longitude = message.getDouble("longitude");
			String details = message.getString("details");
			String date = message.getString("date");
			//latitude, longitude, details
			st.execute(Constants.SQL_INSERT_TRANSACTION + "(" + budgetID + ", " + amount + ", '" + details + "', " + latitude + ", " + longitude +", '" + date + "');");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID = " + budgetID + ";");
//			System.out.println("rs");
			int bigBudgetID=0;
			double budgetSpent=0;
			double newBudgetSpent=0;
			double budgetAmount=0;
			String budgetName="";
			if(rs.next()) {
				bigBudgetID = rs.getInt("bigBudgetID");
				budgetSpent = rs.getDouble("TotalAmountSpent");
				newBudgetSpent = budgetSpent + amount;
				budgetAmount = rs.getDouble("BudgetAmount");
				budgetName = rs.getString("BudgetName");
				System.out.println(bigBudgetID);
			}
//			System.out.println("rs");
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID = " + bigBudgetID + ";");
//			System.out.println("rs1");
			double bigBudgetSpent = 0; double bigbudgetAmount = 0; double newBigBudgetSpent = 0;
			String bigbudgetName = "";
			int daysLeft = 0;
			if (rs1.next()) {
				bigBudgetSpent = rs1.getDouble("TotalAmountSpent");
				newBigBudgetSpent = bigBudgetSpent+amount;
				bigbudgetAmount = rs1.getDouble("BigBudgetAmount");
				bigbudgetName = rs1.getString("BigBudgetName");
				daysLeft = rs1.getInt("BigBudgetDaysLeft");
			}
			st.executeUpdate("UPDATE Budgets SET TotalAmountSpent = " + newBudgetSpent + " WHERE budgetID = " + budgetID + ";");
			System.out.println("update");
			response = getData(conn, userID);
			st.executeUpdate("UPDATE BigBudgets SET TotalAmountSpent = " + newBigBudgetSpent + " WHERE bigBudgetID = " + bigBudgetID + ";");
			if (newBudgetSpent >= ((budgetAmount)) && budgetSpent <= (budgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You have used all of your allotted amount in category " + budgetName + " which is in budget " + bigbudgetName + ". You have " + daysLeft + " more days.");
			}
			else if (newBudgetSpent > (0.95*(budgetAmount)) && budgetSpent <= (0.95*budgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 5% left in category " + budgetName + " which is in budget " + bigbudgetName + ". You have " + daysLeft + " more days.");
			}
			else if (newBudgetSpent > (0.9*(budgetAmount)) && budgetSpent <= (0.9*budgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 10% left in category " + budgetName + " which is in budget " + bigbudgetName + ". You have " + daysLeft + " more days.");
			}
			else if (newBudgetSpent > (0.8*(budgetAmount)) && budgetSpent <= (0.8*budgetAmount)) {
				response.put("notification", "yes");
				response.put("notify", "You now have less than 20% left in category " + budgetName + " which is in budget " + bigbudgetName + ". You have " + daysLeft + " more days.");
			}
			else {
				response.put("notification", "no");
			}
			if (response.getString("notification").equals("no")) {
				transNotif = null;
			}
			else {
				transNotif.put("notification", "yes");
				transNotif.put("notify", response.getString("notify"));
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
	public JSONObject renameTransaction(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int transID = message.getInt("transactionID");
			int userID = message.getInt("userID");
			String details = message.getString("newDescription");
			st.execute("UPDATE Transactions SET Details='" + details + "' WHERE transactionID=" + transID + ";");
			response = getData(conn, userID);
			response.put("message", "renameTransactionSuccess");
		} catch(SQLException | JSONException e) {
			e.printStackTrace();
			try {
				response.put("message", "renameTransactionFail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		return response;
	}
	public JSONObject deleteTransaction(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int transID = message.getInt("transactionID");
			int userID = message.getInt("userID");
			int budgetID = 0;
			double amount = 0;
			ResultSet rs = st.executeQuery("SELECT * FROM Transactions WHERE transactionID=" + transID + ";");
			int bigBudgetID = 0;
			if (rs.next()) {
				amount = rs.getFloat("Amount");
				budgetID = rs.getInt("budgetID");
			}
			ResultSet rs1 = st.executeQuery("SELECT * FROM Budgets WHERE budgetID=" + budgetID + ";");
			double budgetAmountSpent = 0;
			
			if (rs1.next()) {
				budgetAmountSpent = rs1.getFloat("TotalAmountSpent");
				bigBudgetID = rs1.getInt("bigBudgetID");
			}
			ResultSet rs2 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID=" + bigBudgetID + ";");
			double bigBudgetAmountSpent = 0;
			if (rs2.next()) {
				bigBudgetAmountSpent = rs2.getFloat("TotalAmountSpent");
			}
			Statement st4 = conn.createStatement();
			st4.execute("UPDATE Budgets SET TotalAmountSpent=" + (budgetAmountSpent-amount) + " WHERE budgetID=" + budgetID + ";");
			Statement st5 = conn.createStatement();
			st5.execute("UPDATE BigBudgets SET TotalAmountSpent=" + (bigBudgetAmountSpent-amount) + "WHERE bigBudgetID=" + bigBudgetID + ";");
			
			String deleteTrans = "DELETE FROM Transactions WHERE transactionID=" + transID + ";";
			st.execute(deleteTrans);
			response = getData(conn, userID);
			response.put("message", "deleteTransactionSuccess");
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
			try {
				response.put("message", "deleteTransactionFail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		return response;
	}
	public JSONObject deleteAllTransactions(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
		try {
			Statement st = conn.createStatement();
			int budgetID = message.getInt("categoryID");
			ResultSet rs = st.executeQuery("SELECT * FROM Budgets WHERE budgetID=" + budgetID + ";");
			double addBack = 0;
			int bigBudgetID = 0;
			if (rs.next()) {
				addBack = rs.getFloat("TotalAmountSpent");
				bigBudgetID = rs.getInt("bigBudgetID");
			}
			ResultSet rs1 = st.executeQuery("SELECT * FROM BigBudgets WHERE bigBudgetID=" + bigBudgetID + ";");
			double bbAmountSpent = 0;
			if (rs1.next()) {
				bbAmountSpent = rs1.getFloat("TotalAmountSpent");
			}
			st.execute("DELETE FROM Transactions WHERE budgetID = " + budgetID + ";");
			st.execute("UPDATE Budgets SET TotalAmountSpent=0 WHERE budgetID=" + budgetID + ";");
			st.execute("UPDATE BigBudgets SET TotalAmountSpent = " + (bbAmountSpent-addBack) + " WHERE bigBudgetID=" + bigBudgetID + ";");
			response.put("message", "deleteAllTransactionsSuccess");
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
			try {
				response.put("message", "deleteAllTransactionsFail");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		return response;
	}
	
	
	public JSONObject notify(Connection conn, Session session, JSONObject message) {
		return null;
	}
	
	
	public JSONObject signUpTest(JSONObject message, Session session, Connection conn) {
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject(); 
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
		//JSONObject response = new JSONObject();
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
