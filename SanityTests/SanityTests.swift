//
//  swift
//  SanityTests
//
//  Created by Aneel Yelamanchili on 10/26/17.
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import XCTest
@testable import Sanity
import Starscream

class SanityTests: XCTestCase {
    let client = Client.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        client.establishConnection {
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginPassword() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")
        let username = "a"
        let password = "b"

        client.establishConnection {

        }

        usleep(2000000)

        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("logintest", forKey: "message")
        json.setValue(username, forKey: "email")
        json.setValue(password, forKey: "password")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)

        client.socket.write(data: jsonData as Data)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            print("DISPATCH")
            let testPassed = Client.testPassed
            print(testPassed)

            XCTAssertEqual(false, testPassed)
        })

        usleep(5000000)
    }

    func testLoginEmail() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")

        let username = "b"
        let password = "a"

        usleep(2000000)

        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("logintest", forKey: "message")
        json.setValue(username, forKey: "email")
        json.setValue(password, forKey: "password")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)

        client.socket.write(data: jsonData as Data)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            let testPassed = Client.testPassed
            print(testPassed)
            print("GOT INTO DISPATCH")

            XCTAssertEqual(false, testPassed)
        })

        usleep(5000000)
    }

    func testSignup() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")
        let firstname = "David"
        let lastname = "Sealand"
        let password = "sealand"
        let email = "sealand@usc.edu"

        usleep(2000000)

        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("signuptest", forKey: "message")
        json.setValue(firstname, forKey: "firstname")
        json.setValue(lastname, forKey: "lastname")
        json.setValue(password, forKey: "password")
        json.setValue(email, forKey: "email")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)

        client.socket.write(data: jsonData as Data)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            let testPassed = Client.testPassed
            print(testPassed)
            print("GOT INTO SIGNUP DISPATCH")

            XCTAssertEqual(false, testPassed)
        })

        usleep(5000000)
    }

    func testForgotPassword() {
        let inputEmail = "sealand@usc.edu"
        let inputPassword = "hi"

        usleep(2000000)

        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("changePasswordTest", forKey: "message")
        json.setValue(inputEmail, forKey: "email")
        json.setValue(inputPassword, forKey: "newPassword")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String

        client.socket.write(data: jsonData as Data)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            let testPassed = Client.testPassed
            print(testPassed)
            print("GOT INTO DISPATCH")

            XCTAssertEqual(true, testPassed)
        })

        usleep(5000000)
    }
    
    // Create bigbudget, category in budget of 5k, then add 100
    func testAddToCategory() {
        let budgetAmount = 10000
        let categoryAmount = 5000
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        usleep(2000000)

        let json6:NSMutableDictionary = NSMutableDictionary()
        json6.setValue("signup", forKey: "message")
        json6.setValue("David", forKey: "firstname")
        json6.setValue("Sealand", forKey: "lastname")
        json6.setValue("sealand", forKey: "password")
        json6.setValue("sealand@usc.edu", forKey: "email")
        let jsonData6 = try! JSONSerialization.data(withJSONObject: json6, options: JSONSerialization.WritingOptions())
        let jsonString6 = NSString(data: jsonData6, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString6)
        print(jsonData6)

        client.socket.write(data: jsonData6 as Data)
        
        usleep(1000000)
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "bigBudgetName") // need
        json.setValue(budgetAmount, forKey: "bigBudgetAmount") // need
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue(1, forKey: "userID") // need
        json.setValue(historyArray, forKey: "historyArray")
        json.setValue(0.0, forKey: "totalAmountSpent")
        json.setValue(0.0, forKey: "totalAmountAdded")
        json.setValue(0, forKey: "barGraphColor")
        json.setValue(markerLatitude, forKey: "markerLatitude")
        json.setValue(markerLongitude, forKey: "markerLongitude")
        json.setValue("testResetFrequency", forKey: "resetFrequency")
        json.setValue("testResetStartDate", forKey: "resetStartDate")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        client.socket.write(data: jsonData as Data)
        
        usleep(1000000)
        
        // Create category with amount of $5000
        let json2:NSMutableDictionary = NSMutableDictionary()
        json2.setValue("createBudget", forKey: "message")
        
        json2.setValue("testname", forKey: "budgetName")
        json2.setValue(1, forKey: "bigBudgetID")
        json2.setValue(categoryAmount, forKey: "budgetAmount")
        json2.setValue(1, forKey: "userID") // need
        
        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString2)
        print(jsonData2)
        
        client.socket.write(data: jsonData2 as Data)
        
        usleep(1000000)
        
        // Add to $100 to category that was just created
        let json3:NSMutableDictionary = NSMutableDictionary()
        json3.setValue("addToBudgetTest", forKey: "message")
        
        json3.setValue("testname", forKey: "budgetName")
        json3.setValue(1, forKey: "budgetID")
        json3.setValue(100, forKey: "amountToAdd")
        json3.setValue(1, forKey: "userID") // do we need this? maybe for later?
        
        let jsonData3 = try! JSONSerialization.data(withJSONObject: json3, options: JSONSerialization.WritingOptions())
        var jsonString3 = NSString(data: jsonData3, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString3)
        print(jsonData3)
        
        client.socket.write(data: jsonData3 as Data)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            let testPassed = Client.testPassed
            print(testPassed)
            print("GOT INTO DISPATCH")
            
            XCTAssertEqual(true, testPassed)
        })
        
        usleep(5000000)
        //addToBudgetSuccessTest
    }

    // -------------------- Fixed I believe -------------------- //
//    // Create bigbudget, category in budget of 5k, then subtract 100
//    func testSubtractFromCategory() {
//        let budgetAmount = 10000
//        let categoryAmount = 5000
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        usleep(2000000)
//
//        let json6:NSMutableDictionary = NSMutableDictionary()
//        json6.setValue("signup", forKey: "message")
//        json6.setValue("David", forKey: "firstname")
//        json6.setValue("Sealand", forKey: "lastname")
//        json6.setValue("sealand", forKey: "password")
//        json6.setValue("sealand@usc.edu", forKey: "email")
//        let jsonData6 = try! JSONSerialization.data(withJSONObject: json6, options: JSONSerialization.WritingOptions())
//        let jsonString6 = NSString(data: jsonData6, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString6)
//        print(jsonData6)
//
//        client.socket.write(data: jsonData6 as Data)
//
//        usleep(1000000)
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "bigBudgetName") // need
//        json.setValue(budgetAmount, forKey: "bigBudgetAmount") // need
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID") // need
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        usleep(1000000)
//
//        // Create category with amount of $5000
//        let json2:NSMutableDictionary = NSMutableDictionary()
//        json2.setValue("createBudget", forKey: "message")
//
//        json2.setValue("testname", forKey: "budgetName")
//        json2.setValue(1, forKey: "bigBudgetID")
//        json2.setValue(categoryAmount, forKey: "budgetAmount")
//        json2.setValue(1, forKey: "userID") // need
//
//        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
//        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString2)
//        print(jsonData2)
//
//        client.socket.write(data: jsonData2 as Data)
//
//        usleep(1000000)
//
//        // Add to $100 to category that was just created
//        let json3:NSMutableDictionary = NSMutableDictionary()
//        json3.setValue("subtractFromBudgetTest", forKey: "message")
//
//        json3.setValue("testname", forKey: "budgetName")
//        json3.setValue(1, forKey: "budgetID")
//        json3.setValue(-100, forKey: "amountToAdd")
//        json3.setValue(1, forKey: "userID") // do we need this? maybe for later?
//
//        let jsonData3 = try! JSONSerialization.data(withJSONObject: json3, options: JSONSerialization.WritingOptions())
//        var jsonString3 = NSString(data: jsonData3, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString3)
//        print(jsonData3)
//
//        client.socket.write(data: jsonData3 as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//        // subtractFromBudgetSuccessTest
//    }

    // -------------------- Fixed I believe, check the final message (addToBudgetTest) -------------------- //
//    func testBarChart() {
//        // Assume Sealand has a bar chart object that is populated with a list of the last 6 historical transactions. He also has an list of max size 6, with lists of transations, where each index of the list represents a day. In each day, either a of transactions for that day or the total amount spent for that day is stored.
//        // testBarChart functionality:
//        // 1. create a transaction in a specific category
//        // 2. grab bar chart object, sealand checks if the bar chart object's list isn't empty
//        // 3. return true
//
    //        let budgetAmount = 10000
//        let categoryAmount = 5000
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        usleep(2000000)
//
//        let json6:NSMutableDictionary = NSMutableDictionary()
//        json6.setValue("signup", forKey: "message")
//        json6.setValue("David", forKey: "firstname")
//        json6.setValue("Sealand", forKey: "lastname")
//        json6.setValue("sealand", forKey: "password")
//        json6.setValue("sealand@usc.edu", forKey: "email")
//        let jsonData6 = try! JSONSerialization.data(withJSONObject: json6, options: JSONSerialization.WritingOptions())
//        let jsonString6 = NSString(data: jsonData6, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString6)
//        print(jsonData6)
//
//        client.socket.write(data: jsonData6 as Data)
//
//        usleep(1000000)
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "bigBudgetName") // need
//        json.setValue(budgetAmount, forKey: "bigBudgetAmount") // need
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID") // need
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        usleep(1000000)
//
//        // Create category with amount of $5000
//        let json2:NSMutableDictionary = NSMutableDictionary()
//        json2.setValue("createBudget", forKey: "message")
//
//        json2.setValue("testname", forKey: "budgetName")
//        json2.setValue(1, forKey: "bigBudgetID")
//        json2.setValue(categoryAmount, forKey: "budgetAmount")
//        json2.setValue(1, forKey: "userID") // need
//
//        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
//        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString2)
//        print(jsonData2)
//
//        client.socket.write(data: jsonData2 as Data)
//
//        usleep(1000000)
//
//        // Add to $100 to category that was just created
//        let json3:NSMutableDictionary = NSMutableDictionary()
//        json3.setValue("addToBudgetTest", forKey: "message")
//
//        json3.setValue("testname", forKey: "budgetName")
//        json3.setValue(1, forKey: "budgetID")
//        json3.setValue(100, forKey: "amountToAdd")
//        json3.setValue(1, forKey: "userID") // do we need this? maybe for later?
//
//        let jsonData3 = try! JSONSerialization.data(withJSONObject: json3, options: JSONSerialization.WritingOptions())
//        var jsonString3 = NSString(data: jsonData3, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString3)
//        print(jsonData3)
//
//        client.socket.write(data: jsonData3 as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//        let testPassed = Client.testPassed
//        print(testPassed)
//        print("GOT INTO DISPATCH")
//
//        XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//        //addToBudgetSuccessTest
//    }

    // transactionHistoryTest
//    func testHistoryOfTransactions() { 
//        let budgetAmount = 10000
//        let categoryAmount = 5000
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        usleep(2000000)
//
//        let json6:NSMutableDictionary = NSMutableDictionary()
//        json6.setValue("signup", forKey: "message")
//        json6.setValue("David", forKey: "firstname")
//        json6.setValue("Sealand", forKey: "lastname")
//        json6.setValue("sealand", forKey: "password")
//        json6.setValue("sealand@usc.edu", forKey: "email")
//        let jsonData6 = try! JSONSerialization.data(withJSONObject: json6, options: JSONSerialization.WritingOptions())
//        let jsonString6 = NSString(data: jsonData6, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString6)
//        print(jsonData6)
//
//        client.socket.write(data: jsonData6 as Data)
//
//        usleep(1000000)
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "bigBudgetName") // need
//        json.setValue(budgetAmount, forKey: "bigBudgetAmount") // need
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID") // need
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        usleep(1000000)
//
//        // Create category with amount of $5000
//        let json2:NSMutableDictionary = NSMutableDictionary()
//        json2.setValue("createBudget", forKey: "message")
//
//        json2.setValue("testname", forKey: "budgetName")
//        json2.setValue(1, forKey: "bigBudgetID")
//        json2.setValue(categoryAmount, forKey: "budgetAmount")
//        json2.setValue(1, forKey: "userID") // need
//
//        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
//        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString2)
//        print(jsonData2)
//
//        client.socket.write(data: jsonData2 as Data)
//
//        usleep(1000000)
//
//        // Add to $100 to category that was just created
//        let json3:NSMutableDictionary = NSMutableDictionary()
//        json3.setValue("transactionHistoryTest", forKey: "message")
//
//        json3.setValue("testname", forKey: "budgetName")
//        json3.setValue(1, forKey: "budgetID")
//        json3.setValue(100, forKey: "amountToAdd")
//        json3.setValue(1, forKey: "userID") // do we need this? maybe for later?
//
//        let jsonData3 = try! JSONSerialization.data(withJSONObject: json3, options: JSONSerialization.WritingOptions())
//        var jsonString3 = NSString(data: jsonData3, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString3)
//        print(jsonData3)
//
//        client.socket.write(data: jsonData3 as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//        let testPassed = Client.testPassed
//        print(testPassed)
//        print("GOT INTO DISPATCH")
//
//        XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//        //transactionHistorySuccessTest
//    }

    
//    func testHistoryLocations() {
//        let budgetAmount = 10000
//        let categoryAmount = 5000
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "bigBudgetName")
//        json.setValue(budgetAmount, forKey: "bigBudgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//
//        // Create category with amount of $5000
//        let json2:NSMutableDictionary = NSMutableDictionary()
//        json2.setValue("createBudget", forKey: "message")
//
//        json2.setValue("testname", forKey: "budgetName")
//        json2.setValue(1, forKey: "bigBudgetID")
//        json2.setValue(categoryAmount, forKey: "budgetAmount")
//
//        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
//        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString2)
//        print(jsonData2)
//
//        client.socket.write(data: jsonData2 as Data)
//
//        // Add to $100 to category that was just created
//        let json3:NSMutableDictionary = NSMutableDictionary()
//        json3.setValue("locationTest", forKey: "message")
//
//        json3.setValue("testname", forKey: "budgetName")
//        json3.setValue(1, forKey: "budgetID")
//        json3.setValue(100, forKey: "amountToAdd")
//        json3.setValue(1, forKey: "userID") // do we need this? maybe for later?
//        json3.setValue(100, forKey: "markerLatitude")
//        json3.setValue(100, forKey: "markerLongitude")
//
//        let jsonData3 = try! JSONSerialization.data(withJSONObject: json3, options: JSONSerialization.WritingOptions())
//        var jsonString3 = NSString(data: jsonData3, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString3)
//        print(jsonData3)
//
//        client.socket.write(data: jsonData3 as Data)
//
//        // Adds to budget, and then sealand checks if the history of transactions is not 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//        // locationSuccessTest
//    }
//
//    func testTransactionLimitNotification() {
//        let budgetAmount = 10000
//        let categoryAmount = 100
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        // Create category with amount of $100
//        let json2:NSMutableDictionary = NSMutableDictionary()
//        json2.setValue("createBudget", forKey: "message")
//
//        json2.setValue("testname", forKey: "budgetName")
//        json2.setValue(1, forKey: "bigBudgetID")
//        json2.setValue(categoryAmount, forKey: "budgetAmount")
//
//        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
//        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString2)
//        print(jsonData2)
//
//        client.socket.write(data: jsonData2 as Data)
//
//        // subtract 99 from category that was just created
//        let json3:NSMutableDictionary = NSMutableDictionary()
//        json3.setValue("limitNotificationTest", forKey: "message")
//
//        json3.setValue("testname", forKey: "budgetName")
//        json3.setValue(1, forKey: "budgetID")
//        json3.setValue(99, forKey: "amountToSubtract")
//        json3.setValue(1, forKey: "userID") // do we need this? maybe for later?
//        json3.setValue(100, forKey: "markerLatitude")
//        json3.setValue(100, forKey: "markerLongitude")
//
//        let jsonData3 = try! JSONSerialization.data(withJSONObject: json3, options: JSONSerialization.WritingOptions())
//        var jsonString3 = NSString(data: jsonData3, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString3)
//        print(jsonData3)
//
//        client.socket.write(data: jsonData3 as Data)
//
//        // Adds to budget, and then sealand checks if the history of transactions is not 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//
//        //limitNotificationSuccessTest
//    }
//
//    func testCreateBudgetSuccessful() {
//        let budgetAmount = 10000
//        let categoryAmount = 100
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudgetTest", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        // Adds to budget, and then sealand checks if the history of transactions is not 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//
//        //createBigBudgetSuccessTest
//    }
//
//    func testCreateCategorySuccessful() {
//        let budgetAmount = 10000
//        let categoryAmount = 100
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        // Create budget
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//
//        // Create category with amount of $100
//        let json2:NSMutableDictionary = NSMutableDictionary()
//        json2.setValue("createBudgetTest", forKey: "message")
//
//        json2.setValue("testname", forKey: "budgetName")
//        json2.setValue(1, forKey: "bigBudgetID")
//        json2.setValue(categoryAmount, forKey: "budgetAmount")
//
//        let jsonData2 = try! JSONSerialization.data(withJSONObject: json2, options: JSONSerialization.WritingOptions())
//        var jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString2)
//        print(jsonData2)
//
//        client.socket.write(data: jsonData2 as Data)
//
//        // Adds to budget, and then sealand checks if the history of transactions is not 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//
//        //createBudgetSuccessTest
//    }
//
//    func testBudgetAmountNegative() {
//        let budgetAmount = -1.0
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudgetTest", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//
//        //createBigBudgetSuccessTest
//    }
//
//    func testBudgetAmountString() {
//        let budgetAmount = "testAmount"
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudgetTest", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//
//        //createBigBudgetSuccessTest
//    }
//
//    func testLargePositiveBudget() {
//        let budgetAmount = "999999999999999"
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudgetTest", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue(1, forKey: "userID")
//        json.setValue(historyArray, forKey: "historyArray")
//        json.setValue(0.0, forKey: "totalAmountSpent")
//        json.setValue(0.0, forKey: "totalAmountAdded")
//        json.setValue(0, forKey: "barGraphColor")
//        json.setValue(markerLatitude, forKey: "markerLatitude")
//        json.setValue(markerLongitude, forKey: "markerLongitude")
//        json.setValue("testResetFrequency", forKey: "resetFrequency")
//        json.setValue("testResetStartDate", forKey: "resetStartDate")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//
//        //createBigBudgetSuccessTest
//    }
//
//    func testDeleteBudget() {
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("deleteBigBudgetTest", forKey: "message")
//
//        json.setValue(0, forKey: "bigBudgetID")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            let testPassed = Client.testPassed
//            print(testPassed)
//            print("GOT INTO DISPATCH")
//
//            XCTAssertEqual(true, testPassed)
//        })
//
//        usleep(5000000)
//        //deleteBigBudgetSuccessTest
//    }
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    
}
