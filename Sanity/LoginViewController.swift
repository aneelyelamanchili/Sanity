//
//  LoginViewController.swift
//  Pocket Change
//
//  Created by Aneel Yelamanchili on 10/15/17.
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import LocalAuthentication

class LoginViewController : UIViewController, UITextFieldDelegate {
    let sharedModel = Client.sharedInstance
    
    var sendMessage: [String: Any]?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Client.sharedInstance.closeConnection()
        Client.sharedInstance.establishConnection {
            
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        //let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
//        //self.username.setBottomLine(borderColor: UIColor.white)
//        //self.password.setBottomLine(borderColor: UIColor.white)
//        username = KaedeTextField(frame: textFieldFrame)
//        username.placeholderColor = .darkGrayColor()
//        textField.foregroundColor = .lightGrayColor()
//
//        view.addSubView(textField)
//
//    }
    
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
        } else if (Client.sharedInstance.json?["message"] as! String == "passwordFail") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let myAlert = UIAlertView()
            myAlert.title = "Password Not Changed"
            myAlert.message = Client.sharedInstance.json?["passwordFail"] as! String?
            myAlert.addButton(withTitle: "Dismiss")
            myAlert.delegate = self
            myAlert.show()
        } else {

//            var context:LAContext = LAContext();
//            var error:NSError?
//            var success:Bool;
//            var reason:String = "Please authenticate using TouchID.";
//
//            if (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error))
//            {
////                good = true
//                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) -> Void in
//                    if (success) {
                        print("Auth was OK");
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)

                        print("SUCCESS")

                        self.sendMessage = Client.sharedInstance.json

                        //print(sendMessage)

                        let mainViewController = storyboard.instantiateViewController(withIdentifier: "BigBudgetListViewController") as! BigBudgetListViewController

                        mainViewController.toPopulate = self.sendMessage

                        //self.navigationController?.pushViewController(mainViewController, animated: true)
                        let targetNavigationController = UINavigationController(rootViewController: mainViewController)

                        UIApplication.topViewController()?.present(targetNavigationController, animated: true, completion: nil)

//                    }
//                    else
//                    {
//                        //You should do better handling of error here but I'm being lazy
//                        print("Error received: %d", error!);
//                    }
//                });
//            }
        }
    }
    
    weak var confirmButton : UIAlertAction?
    
    // Function that shows the alert pop-up
    @IBAction func showAlert(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Change Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Email"
            textField.delegate = self
        })
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Old Password"
            textField.delegate = self as! UITextFieldDelegate
        })
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "New Password"
            textField.delegate = self as! UITextFieldDelegate
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
        })
        
        let change = UIAlertAction(title: "Change", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            var inputEmail = alert.textFields![0].text
            var oldPassword = alert.textFields![1].text
            var inputPassword = alert.textFields![2].text
            
            let json:NSMutableDictionary = NSMutableDictionary()
            json.setValue("changePassword", forKey: "message")
            json.setValue(inputEmail, forKey: "email")
            json.setValue(inputPassword, forKey: "newPassword")
            json.setValue(oldPassword, forKey: "oldPassword")
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            Client.sharedInstance.socket.write(data: jsonData as Data)
            
        })
        
        alert.addAction(change)
        alert.addAction(cancel)
        
        self.confirmButton = change
        change.isEnabled = true
        self.present(alert, animated: true, completion: nil)
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

//extension UITextField {
//
//    func setBottomLine(borderColor: UIColor) {
//
//        self.borderStyle = UITextBorderStyle.none
//        self.backgroundColor = UIColor.clear
//
//        let borderLine = UIView()
//        let height = 1.0
//        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
//
//        borderLine.backgroundColor = borderColor
//        self.addSubview(borderLine)
//    }
//
//}

