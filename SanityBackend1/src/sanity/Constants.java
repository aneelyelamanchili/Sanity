package sanity;

public class Constants {
	public static final String SQL_INSERT_USER = "INSERT INTO TotalUsers(FirstName, Lastname, Password, Email) VALUES ";
	public static final String SQL_INSERT_BIGBUDGET = "INSERT INTO BigBudget(userID, BigBudgetName, BarGraphColor, Latitude, Longitude, BigBudgetAmount, TotalAmountSpent)";
	public static final String SQL_INSERT_BUDGET = "INSERT INTO Budget(budgetID, BudgetAmount, BudgetName)";
	public static final String SQL_EDIT_BIGBUDGET = "UPDATE BigBudget SET ";
	public static final String SQL_INSERT_RIDE = "INSERT INTO CurrentTrips(userID, FirstName, LastName, Email, StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsAvailable) VALUES";
	public static final String SQL_INSERT_PREVIOUSRIDE = "INSERT INTO TotalPreviousTrips(rideID, userID, FirstName, LastName, Email, StartingPoint, DestinationPoint, CarModel, LicensePlate, Cost, `Date/Time`, Detours, Hospitality, Food, Luggage, TotalSeats, SeatsFilled) VALUES";
}
