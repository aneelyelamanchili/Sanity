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
    
    var json: [String: Any]?
    var socket = WebSocket(url: URL(string: "ws://de34c71f.ngrok.io/SanityBackend1/ws")!)
    
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
    
    
}
