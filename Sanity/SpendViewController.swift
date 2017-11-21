//
//  SpendViewController.swift
//  Pocket Change
//
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import CoreLocation

class SpendViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate
{
    // sharedDelegate
    var sharedDelegate: AppDelegate!
    
    var currentIndex: Int!
    
    var budgetArray: [MyBudget]!
    
    var toPopulate: [String: Any]!
    
    var currCategory: String!
    var currBudget: String!
    
    // Location manager for finding the current location
    let locationManager = CLLocationManager()
    
    // IB Outlets
    @IBOutlet weak var spendButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    
    // Buttons get initially enabled or disabled based on conditions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        // So we don't need to type this out again
        let shDelegate = UIApplication.shared.delegate as! AppDelegate
        sharedDelegate = shDelegate
        
        // Find the current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Set Navbar Color
        let color = UIColor.white
        self.navigationController?.navigationBar.tintColor = color
        self.navigationItem.title = toPopulate?["categoryName"] as! String
        
        // Set textField delegates to themselves
        inputAmount.delegate = self
        descriptionText.delegate = self
        
        // Set placeholder text for each textfield
        inputAmount.placeholder = "$0.00"
        descriptionText.placeholder = "What's it for?"
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SpendViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // Syncs labels with global variables
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Save context and get data
        self.sharedDelegate.saveContext()
        BudgetVariables.getData()
        
        // Refresh the total balance label, in the case that another view modified the balance vaariable
        //totalBalance.text = BudgetVariables.numFormat(myNum: budgetArray[currentIndex].balance)
        totalBalance.text = BudgetVariables.numFormat(myNum: (toPopulate?["categoryAmount"] as! Double) - (toPopulate?["totalAmountSpent"] as! Double))
        
        // Reset the text fields and disable the buttons
        inputAmount.text = ""
        descriptionText.text = ""
        spendButton.isEnabled = false
        addButton.isEnabled = false
        
        self.sendRefreshQuery()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    public func didReceiveData() {
        print("IN DID RECEIVE DATA SPENDVIEWCONTROLLER")
        print(Client.sharedInstance.json)
        if(Client.sharedInstance.json?["message"] != nil && Client.sharedInstance.json?["notification"] as! String == "yes") {
            let myAlert = UIAlertView()
            myAlert.title = "Category Notification!"
            myAlert.message = Client.sharedInstance.json?["notify"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        }
    }
    
    // This function limits the maximum character count for each textField and limits the decimal places input to 2
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var maxLength = 0
        
        if textField.placeholder == "$0.00"
        {
            maxLength = 10
        }
        else if textField.placeholder == "What's it for?"
        {
            maxLength = 22
        }
        
        let currentString = textField.text as NSString?
        let newString = currentString?.replacingCharacters(in: range, with: string)
        let isValidLength = newString!.characters.count <= maxLength
        
        if textField.placeholder == "$0.00"
        {
            // Max 2 decimal places for input using regex :D
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let regex = try! NSRegularExpression(pattern: "\\..{3,}", options: [])
            let matches = regex.matches(in: newText, options:[], range:NSMakeRange(0, newText.characters.count))
            guard matches.count == 0 else { return false }
            
            switch string
            {
            case "0","1","2","3","4","5","6","7","8","9":
                if isValidLength == true
                {
                    return true
                }
            case ".":
                let array = textField.text?.characters.map { String($0) }
                var decimalCount = 0
                for character in array!
                {
                    if character == "."
                    {
                        decimalCount += 1
                    }
                }
                if decimalCount == 1
                {
                    return false
                }
                else if isValidLength == true
                {
                    return true
                }
            default:
                let array = string.characters.map { String($0) }
                if array.count == 0
                {
                    return true
                }
                return false
            }
        }
        
        // For any other text field, return true if the length is valid
        if isValidLength == true
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // This function gets called when the Spend button is pressed
    @IBAction func spendButtonPressed(_ sender: Any)
    {
        // Get current date, append to history Array
        let date = BudgetVariables.todaysDate(format: "MM/dd/YYYY")
        
        // Trim input first
        let trimmedInput = (inputAmount.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // If the input amount is a number, round the input to two decimal places before doing further calculations
        if let input = (Double(trimmedInput!))?.roundTo(places: 2)
        {
            // Trim description text before appending
            let description = (descriptionText.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            // Log the latitude and longitude of the current transaction if the current location is available
            let currentPosition = self.locationManager.location?.coordinate
            let latitude:Double!
            let longitude:Double!
            
            if currentPosition != nil
            {
                latitude = (currentPosition?.latitude)!
                longitude = (currentPosition?.longitude)!
            }
                
            // If the current position is nil, set the arrays with placeholders of (360,360)
            else
            {
                latitude = 360
                longitude = 360
            }
            
            let json:NSMutableDictionary = NSMutableDictionary()
            json.setValue("addTransaction", forKey: "message")
            
            json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
            json.setValue(self.toPopulate?["categoryID"], forKey: "categoryID")
            json.setValue(description, forKey: "details")
            json.setValue(latitude, forKey: "latitude")
            json.setValue(longitude, forKey: "longitude")
            json.setValue(input, forKey: "amountToAdd")
            json.setValue(String(date), forKey: "date")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            print(jsonData)
            
            Client.sharedInstance.socket.write(data: jsonData as Data)
            
            // Save and get data to coredata
            self.sharedDelegate.saveContext()
            BudgetVariables.getData()
            
            // Set the new current index and reload the table
            BudgetVariables.currentIndex = BudgetVariables.budgetArray.count - 1
            //                    self.budgetTable.reloadData()
            //self.sendRefreshQuery()
            
        }
        else
        {
            // Our amountEnteredChanged should take into account all non-Number cases and
            totalBalance.text = "If this message is seen check func amountEnteredChanged"
        }
        
        self.sharedDelegate.saveContext()
        BudgetVariables.getData()
    }
    
    // This function gets called when the Add button is pressed
    @IBAction func addButtonPressed(_ sender: Any)
    {
        // Get current date, append to history Array
        let date = BudgetVariables.todaysDate(format: "MM/dd/YYYY")
        
        // Trim input first
        let trimmedInput = (inputAmount.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // If the input amount is a number, round the input to two decimal places before doing further calculations
        if let input = (Double(trimmedInput!))?.roundTo(places: 2)
        {
            // Trim description text before appending
            let description = (descriptionText.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            // Log the latitude and longitude of the current transaction if the current location is available
            let currentPosition = self.locationManager.location?.coordinate
            let latitude:Double!
            let longitude:Double!
            
            if currentPosition != nil
            {
                latitude = (currentPosition?.latitude)!
                longitude = (currentPosition?.longitude)!
            }
                
                // If the current position is nil, set the arrays with placeholders of (360,360)
            else
            {
                latitude = 360
                longitude = 360
            }
            
            let json:NSMutableDictionary = NSMutableDictionary()
            json.setValue("addTransaction", forKey: "message")
            
            json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
            json.setValue(self.toPopulate?["categoryID"], forKey: "categoryID")
            json.setValue(description, forKey: "details")
            json.setValue(latitude, forKey: "latitude")
            json.setValue(longitude, forKey: "longitude")
            json.setValue((input * -1.0), forKey: "amountToAdd")
            json.setValue(String(date), forKey: "date")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            print(jsonData)
            
            Client.sharedInstance.socket.write(data: jsonData as Data)
            
            // Save and get data to coredata
            self.sharedDelegate.saveContext()
            BudgetVariables.getData()
            
            // Set the new current index and reload the table
            BudgetVariables.currentIndex = BudgetVariables.budgetArray.count - 1
            //                    self.budgetTable.reloadData()
            //self.sendRefreshQuery()
            
        }
        else
        {
            // Our amountEnteredChanged should take into account all non-Number cases and
            totalBalance.text = "If this message is seen check func amountEnteredChanged"
        }
        
        self.sharedDelegate.saveContext()
        BudgetVariables.getData()
    }
    
    // This function dynamically configures button availability depending on input
    @IBAction func amountEnteredChanged(_ sender: AnyObject)
    {
        // Trim input first
        let trimmedInput = (inputAmount.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // If the input is empty or a period, show current balance and disable buttons
        if trimmedInput == "" || trimmedInput == "."
        {
            totalBalance.text = BudgetVariables.numFormat(myNum: (toPopulate?["categoryAmount"] as! Double) - (toPopulate?["totalAmountSpent"] as! Double))
            spendButton.isEnabled = false
            addButton.isEnabled = false
        }
            
        // Otherwise, if the input is a positive number, enable or disable buttons based on input value
        else if let input = (Double(trimmedInput!))?.roundTo(places: 2)
        {
            // Print error statement if input exceeeds 1 million
            if input > 1000000
            {
                totalBalance.text = "Must be under $1M"
                spendButton.isEnabled = false
                addButton.isEnabled = false
            }
            else
            {
                totalBalance.text = BudgetVariables.numFormat(myNum: (toPopulate?["categoryAmount"] as! Double) - (toPopulate?["totalAmountSpent"] as! Double))
                
                // If the input is $0, disable both buttons
                if input == 0
                {
                    spendButton.isEnabled = false
                    addButton.isEnabled = false
                }
                else
                {
                    // If the input can be spent and still result in a valid balance, enable the spend button
                    spendButton.isEnabled = true
                    
                    // If the input can be added and still result in a valid balance, enable the add button
                    if (toPopulate?["categoryAmount"] as! Double) + input > 1000000
                    {
                        addButton.isEnabled = false
                    }
                    else
                    {
                        addButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    // When the History button gets pressed segue to the BarGraphViewController file
    @IBAction func historyButtonPressed(_ sender: Any)
    {
        // Save context and get data
        self.sharedDelegate.saveContext()
        BudgetVariables.getData()
        
        let destination = storyboard?.instantiateViewController(withIdentifier: "HistoryAndMapViewController") as! HistoryAndMapViewController
//        destination.budgetArray = budgetArray
//        destination.currentIndex = currentIndex
        destination.toPopulate = toPopulate
        destination.currCategory = currCategory
        destination.currBudget = currBudget
        navigationController?.pushViewController(destination, animated: true)
        
        // Show the view controller with history and the map
//        performSegue(withIdentifier: "showHistoryAndMap", sender: nil)
    }
    
    // When the Graphs icon gets pressed segue to the graphs view
    @IBAction func graphsButtonPressed(_ sender: Any)
    {
        // Save context and get data
        self.sharedDelegate.saveContext()
        BudgetVariables.getData()
//        performSegue(withIdentifier: "showGraphs", sender: nil)
        
        let destination = storyboard?.instantiateViewController(withIdentifier: "BarGraphViewController") as! BarGraphViewController
        //        destination.budgetArray = budgetArray
        //        destination.currentIndex = currentIndex
//        destination.toPopulate = toPopulate
        destination.categoryID = toPopulate["categoryID"] as! Int
        destination.userID = Client.sharedInstance.json!["userID"] as! Int
//        destination.currBudget = currBudget
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // If we are going to the bar graph view, set button text to be empty
        if segue.identifier == "showGraphs"
        {
            
        }
            
        // If we are going to the history and map view, set button text to be the name of the budget
        else if (segue.identifier == "showHistoryAndMap")
        {
            
        }
        
        // Define the back button's text for the next view        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func sendRefreshQuery() {
        print("REFRESH QUERY")
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("refreshdatatransaction", forKey: "message")
        json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        Client.sharedInstance.socket.write(data: jsonData)
    }
    
    func refreshData() {
        print(currCategory)
        var budget = Client.sharedInstance.json?[currBudget] as? [String: Any]
        toPopulate = budget?[currCategory] as? [String: Any]
        print("REFRESH DATA")
        do {
//            let data1 =  try JSONSerialization.data(withJSONObject: toPopulate!, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//            print(convertedString! + "\n\n\n\n\n") // <-- here is ur string
            DispatchQueue.main.async{
                self.totalBalance.text = BudgetVariables.numFormat(myNum: (self.toPopulate?["categoryAmount"] as! Double) - (self.toPopulate?["totalAmountSpent"] as! Double))
                self.didReceiveData()
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
}
