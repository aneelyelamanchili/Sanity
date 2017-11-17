//
//  Client.swift
//  Pocket Change
//
//  Created by Aneel Yelamanchili on 10/15/17.
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import Foundation
import Starscream

class Client: NSObject, WebSocketDelegate {
    static let sharedInstance = Client()
    static var testPassed:Bool!
    var notifications : [[String:Any]]!
    
    var json: [String: Any]?
    var socket = WebSocket(url: URL(string: "ws://991f3dc4.ngrok.io/SanityBackend1/ws")!)
    
    func websocketDidConnect(socket: WebSocketClient) {
            print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("DID RECEIVE DATA")
        print("Received data: \(data)")
        
        if let str = String(data: data, encoding: String.Encoding.utf8) {
            json = convertToDictionary(text: str)
            print(json!["message"])
            if(json!["message"] as? String == "loginfail" || json?["message"] as? String == "loginsuccess") {
                LoginViewController().didReceiveData()
            } else if(json!["message"] as? String == "signupsuccess" || json!["message"] as? String == "signupfail") {
                SignUpViewController().didReceiveData()
            } else if(json!["message"] as? String == "passwordSuccess" || json!["message"] as? String == "passwordFail") {
                LoginViewController().didReceiveData()
            } else if(json!["message"] as? String == "loginfailtest" || json?["message"] as? String == "loginsuccesstest") {
                print("GOT HERE TO TEST")
                if(json!["message"] as? String == "loginfailtest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "loginsuccesstest") {
                    print("GOT IN TRUE")
                    Client.testPassed = true
                }
                print(Client.testPassed)
                //TODO: adjust for wrong email or wrong password
            } else if(json!["message"] as? String == "signupfailtest" || json?["message"] as? String == "signupsuccesstest") {
                print("GOT INTO SIGNUP TEST")
                if(json!["message"] as? String == "signupfailtest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "signupsuccesstest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "passwordSuccessTest" || json!["message"] as? String == "passwordFailTest") {
                if(json!["message"] as? String == "passwordFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "passwordSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "deleteBigBudgetSuccessTest" || json!["message"] as? String == "deleteBigBudgetFailTest") {
                if(json!["message"] as? String == "deleteBigBudgetFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "deleteBigBudgetSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "createBigBudgetSuccessTest" || json!["message"] as? String == "createBigBudgetFailTest") {
                if(json!["message"] as? String == "createBigBudgetFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "createBigBudgetSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "createBudgetSuccessTest" || json!["message"] as? String == "createBudgetFailTest") {
                if(json!["message"] as? String == "createBudgetFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "createBudgetSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "limitNotificationSuccessTest" || json!["message"] as? String == "limitNotificationFailTest") {
                if(json!["message"] as? String == "limitNotificationFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "limitNotificationSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "locationSuccessTest" || json!["message"] as? String == "locationFailTest") {
                print("MESSAGE IS: ")
                print(json!["message"] as? String)
                if(json!["message"] as? String == "locationFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "locationSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "transactionHistorySuccessTest" || json!["message"] as? String == "transactionHistoryFailTest") {
                if(json!["message"] as? String == "transactionHistoryFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "transactionHistorySuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "addToBudgetSuccessTest" || json!["message"] as? String == "addToBudgetFailTest") {
                if(json!["message"] as? String == "addToBudgetFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "addToBudgetSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "subtractFromBudgetSuccessTest" || json!["message"] as? String == "subtractFromBudgetFailTest") {
                if(json!["message"] as? String == "subtractFromBudgetFailTest") {
                    Client.testPassed = false
                } else if (json!["message"] as? String == "subtractFromBudgetSuccessTest") {
                    Client.testPassed = true
                }
            } else if(json!["message"] as? String == "getdatasuccess") {
                print("GOT HERE")
                let vc = UIApplication.topViewController() as? BigBudgetListViewController
                vc?.refreshData()
            } else if(json!["message"] as? String == "getdatacategorysuccess") {
                print("GOT HERE")
                let vc = UIApplication.topViewController() as? BudgetListViewController
//                print(type(of: vc))
//                vc.budgetTable.reloadData()
                vc?.refreshData()
            } else if(json!["message"] as? String == "addTransactionSuccess") {
                print("INSIDE ADDTRANSACTIONSUCCESSMESSAGE CLIENT")
                print(json)
                let vc = UIApplication.topViewController() as? SpendViewController
//                vc?.didReceiveData()
                vc?.sendRefreshQuery()
//                vc?.didReceiveData()
            } else if(json!["message"] as? String == "getdatatransactionsuccess") {
                print("INSIDE GETDATATRANSACTIONSUCCESSMESSAGE CLIENT")
                print(json)
                let vc = UIApplication.topViewController() as? SpendViewController
                vc?.refreshData()
            } else if(json!["message"] as? String == "getdatahistorysuccess") {
                let vc = UIApplication.topViewController() as? HistoryAndMapViewController
                vc?.refreshData()
            } else if(json!["message"] as? String == "periodNotification") {
                let vc = UIApplication.topViewController()
                for i in 0 ..< (json!["notificationSize"] as! Int) {
                    let arrayString = "notification" + String(i + 1);
                    let messageArray = json![arrayString] as? [String:Any]
                    notifications.append(messageArray!)
                }
                
                showAlert(vc: vc!)
                
            } else if(json!["message"] as? String == "editbudgetsuccess" || json!["message"] as? String == "editbudgetfail") {
                let vc = UIApplication.topViewController() as? SettingsViewController
                vc?.didReceiveData()
            } else if(json!["message"] as? String == "editcategorysuccess" || json!["message"] as? String == "editcategoryfail") {
                let vc = UIApplication.topViewController() as? BudgetListViewController
                vc?.sendRefreshQuery()
            } else if(json!["message"] as? String == "getHistorySuccess" || json!["message"] as? String == "getHistoryFail") {
                let vc = UIApplication.topViewController() as? BarGraphViewController
                vc?.didReceiveData()
            }
        
        } else {
            print("not a valid UTF-8 sequence")
        }
    }
    
    func establishConnection(completion: @escaping ()->Void) {
        socket.delegate = self
        socket.connect()
        socket.onConnect = {
            completion()
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showAlert(vc: UIViewController) {
        if let notification = notifications.first {
            let alertController = UIAlertController(title: "Period Notification!", message: notification["notify"] as? String, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { action in
                self.notifications.remove(at: 0) // remove the message of the alert we have just dismissed
                
                self.showAlert(vc: vc)
                
            }
            alertController.addAction(action)
            
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
}
