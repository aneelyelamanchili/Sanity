//
//  BudgetListViewController.swift
//  Pocket Change
//
//  Copyright © 2016 William Wang. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class BigBudgetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    // sharedDelegate
    var sharedDelegate: AppDelegate!
    
    var toPopulate = Client.sharedInstance.json
    
    // IBOutlets
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet var budgetTable: UITableView!
    
    // When the view initially loads set the title
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(toPopulate)
        // Set the logo for the app through an image created with Adobe Illustrator
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 157.11974, height: 35))
        //        imageView.contentMode = .scaleAspectFit
        //        let image = UIImage(named: "Pocket_Change_Logo")
        //        imageView.image = image
        //        navigationItem.titleView = imageView
        
        navigationItem.title = "Budgets"
        
        budgetTable.dataSource = self
        budgetTable.delegate = self
        
        // So we don't need to type this out again
        let shDelegate = UIApplication.shared.delegate as! AppDelegate
        sharedDelegate = shDelegate
        
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SpendViewController.dismissKeyboard))
        
        // Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Add the refresh control
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: UIControlEvents.valueChanged)
        budgetTable.refreshControl = rc
        budgetTable.reloadData();
        budgetTable.addSubview(rc)
        
        // Gets rid of the empty cells
        budgetTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Reload table data everytime the view is about to appear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Get data from CoreData
        BigBudgetVariables.getData()
        
        // Reload the budget table
        self.budgetTable.reloadData()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Use this variable to enable and disable the Confirm button
    weak var confirmButton : UIAlertAction?
    
    // Function that shows the alert pop-up
    func showAlert()
    {
        let alert = UIAlertController(title: "Create a Budget", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Budget Name"
            textField.delegate = self
            textField.autocapitalizationType = .words
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "From $0 to $1,000,000"
            textField.keyboardType = .decimalPad
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.inputAmountDidChange(_:)), for: .editingChanged)
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Frequency: Daily, Weekly, etc"
            textField.delegate = self
            textField.autocapitalizationType = .words
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Reset Start Date: MM/DD/YYYY"
            textField.delegate = self
            textField.autocapitalizationType = .words
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
        })
        
        let create = UIAlertAction(title: "Create", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            var inputName = alert.textFields![0].text
            
            // Trim the inputName first
            inputName = inputName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if let inputAmount = (Double(alert.textFields![1].text!))?.roundTo(places: 2)
            {
                if inputAmount >= 0 && inputAmount <= 1000000
                {
                    if inputName == ""
                    {
                        inputName = "Untitled Budget"
                    }
                    
                    // Generate the correct name taking into account repeats
                    inputName = BigBudgetVariables.createName(myName: inputName!, myNum: 0)
                    
                    let context = self.sharedDelegate.persistentContainer.viewContext
                    let budget = MyBigBudget(context: context)
                    budget.name = inputName
                    budget.balance = inputAmount
                    budget.descriptionArray = [String]()
                    budget.historyArray = [String]()
                    budget.totalAmountSpent = 0.0
                    budget.totalBudgetAmount = inputAmount
                    budget.totalAmountAdded = 0.0
                    budget.barGraphColor = 0
                    budget.markerLatitude = [Double]()
                    budget.markerLongitude = [Double]()
                    
                    print("The frequencey is: " + String(alert.textFields![2].text!))
                    print("The starting date is: " + String(alert.textFields![3].text!))
                    
                    
                    let json:NSMutableDictionary = NSMutableDictionary()
                    json.setValue("createBigBudget", forKey: "message")
                    
                    json.setValue(self.toPopulate?["userID"], forKey: "userID")
                    json.setValue(budget.name, forKey: "bigBudgetName")
                    json.setValue(budget.balance, forKey: "bigBudgetAmount")
                    json.setValue(budget.descriptionArray, forKey: "descriptionArray")
                    json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
                    json.setValue(budget.historyArray, forKey: "historyArray")
                    json.setValue(budget.totalAmountSpent, forKey: "totalAmountSpent")
                    json.setValue(budget.totalAmountAdded, forKey: "totalAmountAdded")
                    json.setValue(budget.barGraphColor, forKey: "barGraphColor")
                    json.setValue(budget.markerLatitude, forKey: "markerLatitude")
                    json.setValue(budget.markerLongitude, forKey: "markerLongitude")
                    json.setValue(String(alert.textFields![2].text!), forKey: "resetFrequency")
                    json.setValue(String(alert.textFields![3].text!), forKey: "resetStartDate")
                    
                    let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
                    var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                    print(jsonString)
                    print(jsonData)

                    Client.sharedInstance.socket.write(data: jsonData as Data)
                    
                    // Save and get data to coredata
                    self.sharedDelegate.saveContext()
                    BigBudgetVariables.getData()
                    
                    // Set the new current index and reload the table
                    BigBudgetVariables.currentIndex = BigBudgetVariables.budgetArray.count - 1
                    self.budgetTable.reloadData()
                }
            }
        })
        
        alert.addAction(create)
        alert.addAction(cancel)
        
        self.confirmButton = create
        create.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("refreshdata", forKey: "message")
        json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        Client.sharedInstance.socket.write(data: jsonData)
        
        //self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func sendRefreshQuery() {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("refreshdata", forKey: "message")
        json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        Client.sharedInstance.socket.write(data: jsonData)
    }
    
    func refreshData() {
        toPopulate = Client.sharedInstance.json
        print("REFRESH DATA")
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: toPopulate!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString! + "\n\n\n\n\n") // <-- here is ur string
            DispatchQueue.main.async{
                self.budgetTable.reloadData()
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    // This function limits the maximum character count for each textField and limits the decimal places input to 2
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var maxLength = 0
        
        if textField.placeholder == "From $0 to $1,000,000"
        {
            maxLength = 10
        }
        else if textField.placeholder == "Budget Name" || textField.placeholder == "New Name"
        {
            maxLength = 18
        }
        
        let currentString = textField.text as NSString?
        let newString = currentString?.replacingCharacters(in: range, with: string)
        let isValidLength = newString!.characters.count <= maxLength
        
        if textField.placeholder == "From $0 to $1,000,000"
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
    
    // This function disables the Confirm button if the input amount is not valid
    func inputAmountDidChange(_ textField: UITextField)
    {
        // Trim the input first
        let trimmedInput = (textField.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // If the input is a number
        if let inputAmount = Double(trimmedInput!)
        {
            // If the input is also between 0 and 1 million
            if inputAmount >= 0 && inputAmount <= 1000000
            {
                // Confirm button gets enabled
                self.confirmButton?.isEnabled = true
            }
            else
            {
                self.confirmButton?.isEnabled = false
            }
        }
        else
        {
            self.confirmButton?.isEnabled = false
        }
    }
    
    // When the compose button is pressed, show an alert pop-up
    @IBAction func composeButtonWasPressed(_ sender: AnyObject)
    {
        // Alert Pop-up
        showAlert()
    }
    
    // When the pie chart button is pressed, segue to the pie chart view
    @IBAction func pieChartButtonPressed(_ sender: AnyObject)
    {
        performSegue(withIdentifier: "showPieChart", sender: nil)
    }
    
    // If a cell is pressed, go to the corresponding budget
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "viewBudget"
        {
            // code for viewing a budget after a cell is pressed
        }
        else if segue.identifier == "showPieChart"
        {
            // code for viewing the pie chart
        }
        
        // Define the back button's text for the next view
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    // Functions that conform to UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Represents the number of rows the UITableView should have
        return (toPopulate!["numBudgets"] as! Int) + 1
    }
    
    // Set the title and description of each corresponding cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell:UITableViewCell = self.budgetTable.dequeueReusableCell(withIdentifier: "clickableCell", for: indexPath)
//        let count = BigBudgetVariables.budgetArray.count
        let count = toPopulate?["numBudgets"] as! Int
        print("Number of budgets: ")
        print(count)
        
        
        // If it's the last cell, customize the message, make it unselectable, and remove the last separator
        if indexPath.row == count
        {
            myCell.textLabel?.textColor = UIColor.lightGray
            myCell.detailTextLabel?.textColor = UIColor.lightGray
            myCell.textLabel?.text = "Budget"
            // myCell.detailTextLabel?.text = "Balance / Budget"
            myCell.detailTextLabel?.text = "Balance"
            myCell.selectionStyle = UITableViewCellSelectionStyle.none
            myCell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, myCell.bounds.size.width)
        }
        else
        {
            var queryBudget: String = "budget" + String(indexPath.row + 1)
            let populate: [String: Any]
            populate = toPopulate![queryBudget] as! [String : Any]
            myCell.textLabel?.textColor = UIColor.black
            myCell.detailTextLabel?.textColor = UIColor.black
            myCell.textLabel?.text = populate["budgetName"] as? String
            let currentBalance = (populate["budgetAmount"] as? Double)?.roundTo(places: 2)
            let currentBalanceString = BigBudgetVariables.numFormat(myNum: currentBalance!)
            myCell.detailTextLabel?.text = currentBalanceString
            myCell.selectionStyle = UITableViewCellSelectionStyle.default
            myCell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)
        }
        
        return myCell
    }
    
    // User cannot delete the last cell which contains information
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // If it is the last cell which contains information, user cannot delete this cell
        if indexPath.row == toPopulate!["numBudgets"] as! Int
        {
            return false
        }
        
        return true
    }
    
    // When a cell is selected segue to corresponding view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // If it is not the last row, set current index to row # of cell pressed, then segue
        if indexPath.row != toPopulate?["numBudgets"] as! Int
        {
//            BigBudgetVariables.currentIndex = indexPath.row
            var queryBudget: String = "budget" + String(indexPath.row + 1)
            let destination = storyboard?.instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            destination.toPopulate = toPopulate![queryBudget] as! [String: Any]
//            destination.budgetName = BigBudgetVariables.budgetArray[BigBudgetVariables.currentIndex].name
//            destination.budgetArray = BigBudgetVariables.budgetArray[BigBudgetVariables.currentIndex].categories
//            destination.currBigBudget = BigBudgetVariables.budgetArray[BigBudgetVariables.currentIndex]
//            destination.currentIndex = BigBudgetVariables.currentIndex
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // Generates an array of custom buttons that appear after the swipe to the left
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Title is the text of the button
        let delete = UITableViewRowAction(style: .normal, title: " Delete  ")
        { (action, indexPath) in
//            let budget = BigBudgetVariables.budgetArray[indexPath.row]
//            context.delete(budget)
            var queryBudget: String = "budget" + String(indexPath.row + 1)
            var populate:[String: Any]
            populate = (self.toPopulate?[queryBudget] as? [String: Any])!
            
            let json:NSMutableDictionary = NSMutableDictionary()
            json.setValue("deleteBigBudget", forKey: "message")
            
            json.setValue(self.toPopulate?["userID"], forKey: "userID")
            json.setValue(populate["budgetID"], forKey: "bigBudgetID")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            print(jsonData)
            
            Client.sharedInstance.socket.write(data: jsonData as Data)
            self.sharedDelegate.saveContext()
            
//            do
//            {
//                BigBudgetVariables.budgetArray = try context.fetch(MyBigBudget.fetchRequest())
//            }
//            catch
//            {
//                print("Fetching Failed")
//            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            BigBudgetVariables.currentIndex = BigBudgetVariables.budgetArray.count - 1
            
        }
        
        // Title is the text of the button
        let rename = UITableViewRowAction(style: .normal, title: " Rename")
        { (action, indexPath) in
            self.showEditNameAlert(indexPath: indexPath)
        }
        
        // Change the color of the buttons
        rename.backgroundColor = BigBudgetVariables.hexStringToUIColor(hex: "BBB7B0")
        delete.backgroundColor = BigBudgetVariables.hexStringToUIColor(hex: "E74C3C")
        
        return [delete, rename]
    }
    
    // Use this variable to enable or disable the Save button
    weak var nameSaveButton : UIAlertAction?
    
    // Show Edit Name Pop-up
    func showEditNameAlert(indexPath: IndexPath)
    {
        let editAlert = UIAlertController(title: "Rename Budget", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        editAlert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "New Name"
            
            // Set the initial text to be the budget name of the row selected
            var queryBudget: String = "budget" + String(indexPath.row + 1)
            textField.text = self.toPopulate?[queryBudget] as? String
            
            textField.delegate = self
            textField.autocapitalizationType = .words
            textField.addTarget(self, action: #selector(self.newNameTextFieldDidChange(_:)), for: .editingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
        })
        
        let save = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            var inputName = editAlert.textFields![0].text
            var queryBudget: String = "budget" + String(indexPath.row + 1)
            var populate:[String: Any]
            populate = (self.toPopulate?[queryBudget] as? [String: Any])!
            
            // If the input name isn't empty and it isn't the old name
            if inputName != "" && inputName != self.toPopulate?[queryBudget] as? String
            {
                // Trim all extra white space and new lines
                inputName = inputName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                // Create the name with the newly trimmed String
//                inputName = BigBudgetVariables.createName(myName: inputName!, myNum: 0)
//                BigBudgetVariables.budgetArray[indexPath.row].name = inputName!
                
                let json:NSMutableDictionary = NSMutableDictionary()
                json.setValue("editBigBudget", forKey: "message")
                
                json.setValue(self.toPopulate?["userID"], forKey: "userID")
                json.setValue(populate["budgetID"], forKey: "bigBudgetID")
                json.setValue(inputName, forKey: "bigBudgetName")
                
                let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
                var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                print(jsonString)
                print(jsonData)
                
                Client.sharedInstance.socket.write(data: jsonData as Data)
//                self.budgetTable.reloadRows(at: [indexPath], with: .right)
                self.budgetTable.reloadData()
                self.sendRefreshQuery()
            }
            
            // Save data to coredata
            self.sharedDelegate.saveContext()
            
            // Get data
            BigBudgetVariables.getData()
        })
        
        editAlert.addAction(save)
        editAlert.addAction(cancel)
        
        self.nameSaveButton = save
        save.isEnabled = false
        self.present(editAlert, animated: true, completion: nil)
    }
    
    // This function disables the save button if the input name is not valid
    func newNameTextFieldDidChange(_ textField: UITextField)
    {
        // Trim the input first
        let input = (textField.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // If the input is not empty and it doesn't currently exist, enable the Save button
        if input != "" && BigBudgetVariables.nameExistsAlready(str: input!) == false
        {
            self.nameSaveButton?.isEnabled = true
        }
        else
        {
            self.nameSaveButton?.isEnabled = false
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainViewController
        self.dismiss(animated: true) {
            let _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}

