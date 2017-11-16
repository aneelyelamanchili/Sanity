//
//  SettingsViewController.swift
//  Sanity
//
//  Created by William Wang on 11/14/17.
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var renameTextField: UITextField!
    @IBOutlet weak var changePeriodTextField: UITextField!
    @IBOutlet weak var changeBudgetAmountTextField: UITextField!
    @IBOutlet weak var changeNotificationThresholdTextField: UITextField!
    @IBOutlet weak var changePeriodUpdateTextField: UITextField!
    @IBOutlet weak var bigBudgetNameLabel: UILabel!
    @IBOutlet weak var bigBudgetAmountLabel: UILabel!
    @IBOutlet weak var resetPeriodLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    var bigBudgetID: Int!
    var bigBudgetAmount: String!
    var bigBudgetName: String!
    var bigBudgetResetPeriod: String!
    var daysLeft: String!
    var currBudget: String! 
    
    // editBigBudgetAttributes
    // params: bigBudgetId, frequency

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        // Set the logo for the app through an image created with Adobe Illustrator
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 157.11974, height: 35))
        //        imageView.contentMode = .scaleAspectFit
        //        let image = UIImage(named: "Pocket_Change_Logo")
        //        imageView.image = image
        //        navigationItem.titleView = imageView
        
        navigationItem.title = "Settings"
        bigBudgetNameLabel.text = bigBudgetName
        bigBudgetAmountLabel.text = bigBudgetAmount
        resetPeriodLabel.text = bigBudgetResetPeriod
        daysLeftLabel.text = daysLeft
        
        bigBudgetNameLabel.adjustsFontSizeToFitWidth = true;
        
        bigBudgetAmountLabel.adjustsFontSizeToFitWidth = true;
        
        resetPeriodLabel.adjustsFontSizeToFitWidth = true;
        
        daysLeftLabel.adjustsFontSizeToFitWidth = true;
        
//        bigBudgetNameLabel.sizeToFit()
//        bigBudgetAmountLabel.sizeToFit()
//        resetPeriodLabel.sizeToFit()
//        daysLeftLabel.sizeToFit()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("editBigBudget", forKey: "message")
        json.setValue(Client.sharedInstance.json?["userID"], forKey: "userID")
        json.setValue(bigBudgetID, forKey: "bigBudgetID")
        json.setValue(renameTextField.text, forKey: "bigBudgetName")
        json.setValue(changePeriodTextField.text, forKey: "frequency")
        json.setValue(changeBudgetAmountTextField.text, forKey: "budgetAmount")
        json.setValue(changeNotificationThresholdTextField.text, forKey: "limitNotification")
        json.setValue(changePeriodUpdateTextField.text, forKey: "periodUpdateNotification")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        Client.sharedInstance.socket.write(data: jsonData as Data)
        
        print("Changes were sent to backend")
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    public func didReceiveData() {
        if (Client.sharedInstance.json?["message"] as! String == "editbudgetfail") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = UIAlertView()
            myAlert.title = "Edit Budget Failure"
            myAlert.message = Client.sharedInstance.json?["editbudgetfail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        } else {
            refreshData()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = UIAlertView()
            myAlert.title = "Budget Successfully Edited!"
//            myAlert.message = Client.sharedInstance.json?["loginfail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        }
    }
    
    func refreshData() {
        var toPopulate = Client.sharedInstance.json
        print("REFRESH DATA")
        let populate = toPopulate![currBudget] as! [String : Any]
        resetPeriodLabel.text = (populate["budgetName"] as! String) + " resets " + (populate["frequency"] as! String) + "."
        daysLeftLabel.text = "You have " + BigBudgetVariables.formatPeriods(myNum: populate["daysLeft"] as! Int) + " days left."
        bigBudgetAmountLabel.text = BigBudgetVariables.numFormat(myNum: populate["budgetAmount"] as! Double)
        bigBudgetNameLabel.text = populate["budgetName"] as! String + " : "
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
