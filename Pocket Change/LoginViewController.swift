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
    let sharedModel = Client.sharedInstance
    
    var sendMessage: [String: Any]?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
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
    
    @IBAction func login(_ sender: Any) {
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("login", forKey: "message")
        json.setValue(username.text, forKey: "email")
        json.setValue(password.text, forKey: "password")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)

        Client.sharedInstance.socket.write(data: jsonData as Data)
        //Client.sharedInstance.socket.write(string: jsonString)
        if Client.sharedInstance.socket.isConnected {
            print("HERE")
        }
        //print("HERE")
        
    }
    
    public func didReceiveData() {
        print(Client.sharedInstance.json?["message"])
        
        if (Client.sharedInstance.json?["message"] as! String == "loginfail") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let myAlert = UIAlertView()
            myAlert.title = "Login Failure"
            myAlert.message = Client.sharedInstance.json?["loginfail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            print("SUCCESS")
            // Convert dictionary to string
            //            do {
            //                sendMessage = try JSONSerialization.jsonObject(with: Client.sharedInstance.json?["message"] as! Data, options: .allowFragments) as! Dictionary<String, Any>
            //            } catch {
            //                print("parse error")
            //            }
            
            sendMessage = Client.sharedInstance.json
            
            print(sendMessage?["message"])
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            
            //mainViewController.toPopulate = sendMessage
            
            print(self.navigationController)
            
            //self.navigationController?.pushViewController(mainViewController, animated: true)
            let targetNavigationController = UINavigationController(rootViewController: mainViewController)
            
            UIApplication.topViewController()?.present(targetNavigationController, animated: true, completion: nil)
            
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
