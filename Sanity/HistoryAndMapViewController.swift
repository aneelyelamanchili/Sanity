//
//  HistoryAndMapViewController.swift
//  Pocket Change
//
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import CoreData

class HistoryAndMapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GMSMapViewDelegate
{
    // Clean code
    var sharedDelegate: AppDelegate!
    
    var budgetArray: [MyBudget]!
    
    var currentIndex: Int!
    
    var toPopulate: [String: Any]!
    var currCategory: String!
    var currBudget: String!
    
    // IBOutlet for components
    @IBOutlet var historyTable: UITableView!
    @IBOutlet weak var clearHistoryButton: UIBarButtonItem!
    
    // IB Outlet for the current view
    @IBOutlet weak var myMapView: UIView!
    
    // Location manager for finding the current location
    let locationManager = CLLocationManager()
    
    // Global variables for manipulating the map
    var mapView = GMSMapView()
    var camera = GMSCameraPosition()
    var markerArray = [GMSMarker]()
    
    // When the screen loads, display the table
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        print("Printing in history view...")
        print(toPopulate)
        
        // Set up the map
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Set navbar color and title
        let color = UIColor.white
        self.navigationController?.navigationBar.tintColor = color
        self.navigationItem.title = "History"
        
        // Set delegates
        historyTable.dataSource = self
        historyTable.delegate = self
        
        // If there is no history, disable the clear history button
        if (toPopulate?["transactions"] as! NSArray).count == 0
        {
            clearHistoryButton.isEnabled = false
        }
        else
        {
            clearHistoryButton.isEnabled = true
        }
        
        // So we don't need to type this out again
        let shDelegate = UIApplication.shared.delegate as! AppDelegate
        sharedDelegate = shDelegate
        
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SpendViewController.dismissKeyboard))
        
        // Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    // Function runs everytime the screen appears
    override func viewWillAppear(_ animated: Bool)
    {
        // Make sure the table is up to date
        super.viewWillAppear(animated)
        
        // Get data from CoreData
        BudgetVariables.getData()
        
        // Reload the history table
        self.historyTable.reloadData()
    }
    
    // Only initialize the markers when the subviews have been set
    override func viewDidLayoutSubviews()
    {
        self.initializeMarkers()
    }
    
    // When the location finishes updating, stop updating the current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.locationManager.stopUpdatingLocation()
    }
    
    // Show the current markers on the Google Maps
    func initializeMarkers()
    {
        // If the current location cannot be found, set the default camera to be centered at UCLA
        if self.locationManager.location?.coordinate.latitude == nil || self.locationManager.location?.coordinate.longitude == nil
        {
            camera = GMSCameraPosition.camera(withLatitude: 34.068921, longitude: -118.44518110000001, zoom: 15)
        }
            
        // Otherwise if the current location can be found, center the map at the current location
        else
        {
            camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 15)
        }
        
        // Create a map view using the current width and height of the view, and the camera determined from above
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.myMapView.frame.size.width, height: self.myMapView.frame.size.height), camera: camera)
        
        // Clear all markers before updating the markers
        mapView.clear()
        self.markerArray.removeAll()
        
        // Append markers for all the locations in the array
        let transactionArray = toPopulate?["transactions"] as! NSArray
        for i in 0..<transactionArray.count
        {
            let currTransaction = transactionArray[i] as? [String:Any]
            let latitude = currTransaction!["Latitude"] as! Double
            let longitude = currTransaction!["Longitude"] as! Double
            
            print(latitude)
            print(longitude)
            
            // If the latitude and longitude are valid, add a corresponding marker to the map
            if latitude != 360 && longitude != 360
            {
                let marker = GMSMarker()
                marker.position.latitude = latitude
                marker.position.longitude = longitude
                print(currTransaction!["transactionDetails"] as! String)
//                marker.snippet = BudgetVariables.getDetailFromDescription(descripStr: "Test")
                marker.snippet = currTransaction!["transactionDetails"] as! String
                
                // If the action is a "+", add a green marker instead
                let str = currTransaction!["transactionAmount"] as! String
                let index = str.index(str.startIndex, offsetBy: 0)
                if str[index] == "+"
                {
                    marker.icon = GMSMarker.markerImage(with: BudgetVariables.hexStringToUIColor(hex: "00B22C"))
                }
                
                marker.map = mapView
                self.markerArray.append(marker)
            }
            
            // If the latitude or longitude values are invalid, place a marker with no attributes to keep a 1:1 ratio
            else
            {
                let marker = GMSMarker()
                self.markerArray.append(marker)
            }
        }
        
        // Enable current location and add a current location button
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // Grab the current hour
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        // Style the map with a night theme only between 6 PM - 6 AM
        if hour >= 18 || hour <= 6
        {
            do
            {
                if let styleURL = Bundle.main.url(forResource: "Google_Maps_Night_Theme", withExtension: "json")
                {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                }
                else
                {
                    NSLog("Unable to find style.json")
                }
            }
            catch
            {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
        // Add the map to the map view
        self.myMapView.addSubview(mapView)
        
        // Initialize the selected marker to be the last marker, if a marker exists, and set the camera to center on the marker
        if self.markerArray.isEmpty == false
        {
            let lastMarker = self.markerArray[self.markerArray.count - 1]
            mapView.selectedMarker = lastMarker
            mapView.camera = GMSCameraPosition.camera(withLatitude: lastMarker.position.latitude, longitude: lastMarker.position.longitude, zoom: 15)
        }
    }
    
    // Remove all markers
    func removeMarkers()
    {
        for marker in self.markerArray
        {
            marker.map = nil
        }
        self.markerArray.removeAll()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // When the clear history button gets pressed, clear the history and disable button
    @IBAction func clearHistoryButtonWasPressed(_ sender: Any)
    {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("deleteAllTransactions", forKey: "message")
        
        json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
        json.setValue(self.toPopulate?["categoryID"], forKey: "categoryID")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        Client.sharedInstance.socket.write(data: jsonData as Data)
        
        // Save context and get data
        self.sharedDelegate.saveContext()
        BudgetVariables.getData()
        
        // Reload the table, refresh the markers, and disable the clear history button
        self.sendRefreshQuery()
        self.historyTable.reloadData()
        self.removeMarkers()
        clearHistoryButton.isEnabled = false
    }
    
    // Functions that conform to UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Represents the number of rows the UITableView should have
        return (toPopulate?["transactions"] as! NSArray).count + 1
    }
    
    // Determines what data goes in what cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell:UITableViewCell = historyTable.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        let count = (toPopulate?["transactions"] as! NSArray).count
        
        // If it's the last cell, customize the message
        if indexPath.row == count
        {
            myCell.textLabel?.textColor = UIColor.lightGray
            myCell.detailTextLabel?.textColor = UIColor.lightGray
            myCell.textLabel?.text = "Swipe to edit"
            myCell.detailTextLabel?.text = "Tap to locate"
            myCell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        else
        {
            myCell.textLabel?.textColor = UIColor.black
            myCell.detailTextLabel?.textColor = UIColor.black
            
            let transactions = toPopulate?["transactions"] as! NSArray
            let currTransaction = transactions[count - 1 - indexPath.row] as? [String: Any]
            let str = currTransaction!["transactionAmount"] as? String
            let index = str?.index((str?.startIndex)!, offsetBy: 0)
            
            if str![index!] == "+"
            {
                myCell.textLabel?.textColor = BudgetVariables.hexStringToUIColor(hex: "00B22C")
            }
            
            if str![index!] == "-"
            {
                myCell.textLabel?.textColor = BudgetVariables.hexStringToUIColor(hex: "FF0212")
            }
            
            myCell.textLabel?.text = str
            
            // String of the description
            let descripStr = currTransaction!["transactionDetails"] as? String
            
            // Create Detail Text
            let detailText = currTransaction!["transactionDetails"] as? String
            
            
            let dateText = BudgetVariables.createDateText(descripStr: (currTransaction!["Date"] as? String)!)
            
            // Display text
            let displayText = detailText! + dateText
            myCell.detailTextLabel?.text = displayText
            myCell.selectionStyle = UITableViewCellSelectionStyle.default
        }
        
        // Custom insets for the separators
        myCell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)
        
        return myCell
    }
    
    // User cannot delete the last cell which contains information
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // If it is the last cell which contains information, user cannot delete this cell
        let count = (toPopulate?["transactions"] as! NSArray).count
        if indexPath.row == count
        {
            return false
        }
        
        // Extract the amount spent for this specific transaction into the variable amountSpent
        let transactions = toPopulate?["transactions"] as! NSArray
        let currTransaction = transactions[count - 1 - indexPath.row] as? [String: Any]
        
        let historyStr = currTransaction!["transactionAmount"] as? String
        print("Printing1...")
        print(historyStr)
        
        let index1 = historyStr?.index((historyStr?.startIndex)!, offsetBy: 0) // Index spans the first character in the string
        let index2 = historyStr?.index((historyStr?.startIndex)!, offsetBy: 1) // Index spans the amount spent in that transaction
        let amountSpent = Double(historyStr!.substring(from: index2!))
        
        // If after the deletion of a spend action the new balance is over 1M, user cannot delete this cell
        if historyStr![index1!] == "-"
        {
            print(amountSpent)
            let newBalance = (toPopulate["categoryAmount"] as? Double)! + amountSpent!
        }
        else if historyStr![index1!] == "+"
        {
            let newBalance = (toPopulate["categoryAmount"] as? Double)! - amountSpent!
        }
        
        return true
    }
    
    // Generates an array of custom buttons that appear after the swipe to the left
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // Title is the text of the button
        let transactionArray = toPopulate?["transactions"] as! NSArray
        let currTransaction = transactionArray[indexPath.row] as? [String:Any]
        
        let delete = UITableViewRowAction(style: .normal, title: " Delete")
        { (action, indexPath) in
            
            let json:NSMutableDictionary = NSMutableDictionary()
            json.setValue("deleteTransaction", forKey: "message")
            
            json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
            json.setValue(self.toPopulate?["categoryID"], forKey: "categoryID")
            json.setValue(currTransaction?["transactionID"], forKey: "transactionID")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            print(jsonData)
            
            Client.sharedInstance.socket.write(data: jsonData as Data)
            
            // Disable the clear history button if the cell deleted was the last item
            if transactionArray.count == 0
            {
                self.clearHistoryButton.isEnabled = false
            }
            else
            {
                self.clearHistoryButton.isEnabled = true
            }
            
            self.sendRefreshQuery()
        }
        
        // Change the color of the undo button
        delete.backgroundColor = BudgetVariables.hexStringToUIColor(hex: "E74C3C")
        
        let count = (toPopulate?["transactions"] as! NSArray).count
        // Edit item at indexPath
        let edit = UITableViewRowAction(style: .normal, title: "Edit   ")
        { (action, indexPath) in
            
            // If it is not the last row
            if indexPath.row != count
            {
                self.showEditDescriptionAlert(indexPath: indexPath)
            }
        }
        
        // Change the color of the edit button
        edit.backgroundColor = BudgetVariables.hexStringToUIColor(hex: "BBB7B0")
        
        return [delete, edit]
    }
    
    // When a cell is selected, focus the camera on the associated marker
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // If it is not the last row
        let count = (toPopulate?["transactions"] as! NSArray).count
        if indexPath.row != count
        {
            let transactionArray = toPopulate?["transactions"] as! NSArray
            let currTransaction = transactionArray[indexPath.row] as? [String:Any]
            let latitude = currTransaction!["Latitude"] as! Double
            let longitude = currTransaction!["Longitude"] as! Double
            
            // If the latitude and longitude are valid, animate the camera to that location and select that marker, otherwise do nothing
            if latitude != 360 && longitude != 360
            {
                mapView.selectedMarker = self.markerArray[indexPath.row]
                mapView.animate(toLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    // Use this variable to enable and disable the Save button
    weak var saveButton : UIAlertAction?
    
    // Shows the alert pop-up
    func showEditDescriptionAlert(indexPath: IndexPath)
    {
        let transactionArray = toPopulate?["transactions"] as! NSArray
        let count = transactionArray.count
        let currTransaction = transactionArray[count - 1 - indexPath.row] as? [String:Any]
        
        let alert = UIAlertController(title: "Edit Description", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "New Description"
            
            // Grab old description and put it into the initial textfield
            let oldDescription = currTransaction!["transactionDetails"]
            textField.text = oldDescription as! String
            
            //textField.delegate = self
            textField.autocapitalizationType = .sentences
            textField.addTarget(self, action: #selector(self.inputDescriptionDidChange(_:)), for: .editingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
        })
        
        let save = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            var inputDescription = alert.textFields![0].text
            
            // Trim the inputName first
            inputDescription = inputDescription?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            let json:NSMutableDictionary = NSMutableDictionary()
            json.setValue("editTransactionDescription", forKey: "message")
            
            json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
            json.setValue(self.toPopulate?["categoryID"], forKey: "categoryID")
            json.setValue(currTransaction?["transactionID"], forKey: "transactionID")
            json.setValue(inputDescription, forKey: "newDescription")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            print(jsonData)
            
            Client.sharedInstance.socket.write(data: jsonData as Data)
            
            //COOL
            self.sendRefreshQuery()
            self.historyTable.reloadRows(at: [indexPath], with: .fade)
            
            // Save and get data to coredata
            self.sharedDelegate.saveContext()
            BudgetVariables.getData()
            
            // Reload the table
            self.historyTable.reloadData()
            
            // Update the snippet for this marker
            self.markerArray[count - 1 - indexPath.row].snippet = inputDescription!
        })
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        self.saveButton = save
        save.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    // Holds the old description of cell pressed
    var oldDescription: String = ""
    
    // Enable save button if the description doesn't equal current description
    func inputDescriptionDidChange(_ textField: UITextField)
    {
        let inputDescription = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if inputDescription != self.oldDescription
        {
            self.saveButton?.isEnabled = true
        }
        else
        {
            self.saveButton?.isEnabled = false
        }
    }
    
    // This function limits the maximum character count for a textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var maxLength = 0
        
        if textField.placeholder == "New Description"
        {
            maxLength = 22
        }
        
        let currentString = textField.text as NSString?
        let newString = currentString?.replacingCharacters(in: range, with: string)
        return newString!.characters.count <= maxLength
    }
    
    func sendRefreshQuery() {
        print("REFRESH QUERY")
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("refreshdatahistory", forKey: "message")
        json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        Client.sharedInstance.socket.write(data: jsonData)
    }
    
    func refreshData() {
        var budget = Client.sharedInstance.json?[currBudget] as? [String: Any]
        toPopulate = budget?[currCategory] as? [String: Any]
        print("REFRESH DATA")
        do {
            //            let data1 =  try JSONSerialization.data(withJSONObject: toPopulate!, options: JSONSerialization.WritingOptions.prettyPrinted)
            //            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            //            print(convertedString! + "\n\n\n\n\n") // <-- here is ur string
            DispatchQueue.main.async{
                self.historyTable.reloadData()
            }
        } catch let myJSONError {
            print(myJSONError)
        }
    }
}
