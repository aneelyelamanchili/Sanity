//
//  LoginViewController.swift
//  Pocket Change
//
//  Created by Aneel Yelamanchili on 10/15/17.
//  Copyright © 2017 Nathan Tsai. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("login", forKey: "message")
//        json.setValue(username.text, forKey: "email")
//        json.setValue(password.text, forKey: "password")
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        //        jsonString += "\n\n"
//        print(jsonString)
//        print(jsonData)
//
//        Client.sharedInstance.socket.write(data: jsonData as Data)
//        //        Client.sharedInstance.socket.write(string: jsonString)
//        print("HERE")
        
    }
}
