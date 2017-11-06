//
//  SignUpViewController.swift
//  Pocket Change
//
//  Created by Aneel Yelamanchili on 10/15/17.
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func signupUser(_ sender: Any) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("signup", forKey: "message")
        json.setValue(firstname.text, forKey: "firstname")
        json.setValue(lastname.text, forKey: "lastname")
        json.setValue(password.text, forKey: "password")
        json.setValue(email.text, forKey: "email")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        Client.sharedInstance.socket.write(data: jsonData)
        
    }
    
    public func didReceiveData() {
        print(Client.sharedInstance.json?["message"])
        
        if (Client.sharedInstance.json?["message"] as! String == "signupfail") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let myAlert = UIAlertView()
            myAlert.title = "Signup Failure"
            myAlert.message = Client.sharedInstance.json?["signupfail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "BigBudgetListViewController") as! BigBudgetListViewController
            
            self.dismissKeyboard()
            
            let targetNavigationController = UINavigationController(rootViewController: mainViewController)
            
            UIApplication.topViewController()?.present(targetNavigationController, animated: true, completion: nil)
            
        }
        
        
    }
        
}
