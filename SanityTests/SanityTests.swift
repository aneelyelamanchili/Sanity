//
//  SanityTests.swift
//  SanityTests
//
//  Created by Aneel Yelamanchili on 10/26/17.
//  Copyright © 2017 Aneel Yelamanchili. All rights reserved.
//

import XCTest
@testable import Sanity

class SanityTests: XCTestCase {
    static var client: Client!
    var testPassed:Bool!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testPassed = false
        SanityTests.client = Client.sharedInstance
        SanityTests.client.establishConnection {
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        testPassed = nil
        SanityTests.client = nil
    }
    
    func testLoginPassword() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")
        let username = "a"
        let password = "b"
        
        SanityTests.client.establishConnection {
            
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testLoginEmail() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")
        let username = "b"
        let password = "a"
        
        SanityTests.client.establishConnection {
            
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testSignup() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")
        let firstname = "David"
        let lastname = "Sealand"
        let password = "Hello"
        let email = "sealand@usc.edu"
        
        SanityTests.client.establishConnection {
            
        }
        
        usleep(2000000)
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("signup", forKey: "message")
        json.setValue(firstname, forKey: "firstname")
        json.setValue(lastname, forKey: "lastname")
        json.setValue(password, forKey: "password")
        json.setValue(email, forKey: "email")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testForgotPassword() {
        let inputEmail = "sealand@usc.edu"
        let inputPassword = "hi"
        
        SanityTests.client.establishConnection {
            
        }
        
        usleep(2000000)
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("changePassword", forKey: "message")
        json.setValue(inputEmail, forKey: "email")
        json.setValue(inputPassword, forKey: "newPassword")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    
    func testBudgetAmountNegative() {
        let budgetAmount = -1.0
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()

        SanityTests.client.establishConnection {
            
        }
        
        usleep(2000000)
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testBudgetAmountString() {
        let budgetAmount = "testAmount"
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        SanityTests.client.establishConnection {
            
        }
        
        usleep(2000000)
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testLargePositiveBudget() {
        let budgetAmount = "999999999999999"
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        SanityTests.client.establishConnection {
            
        }
        
        usleep(2000000)
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    
    func testDeleteBudget() {
        
        SanityTests.client.establishConnection {
            
        }
        
        usleep(2000000)
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("deleteBigBudget", forKey: "message")
        
        json.setValue(0, forKey: "budgetID")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    // Create bigbudget, category in budget of 5k, then add 100
    func testAddToCategory() {
        let budgetAmount = 10000
        let categoryAmount = 5000
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        
        // Create category with amount of $5000
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "bigBudgetID")
        json.setValue(categoryAmount, forKey: "budgetAmount")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Add to $100 to category that was just created
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("addToBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "budgetID")
        json.setValue(100, forKey: "amountToAdd")
        json.setValue("0", forKey: "userID") // do we need this? maybe for later?
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
        
    }
    
    // Create bigbudget, category in budget of 5k, then subtract 100
    func testSubtractFromCategory() {
        let budgetAmount = 10000
        let categoryAmount = 5000
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        
        // Create category with amount of $5000
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "bigBudgetID")
        json.setValue(categoryAmount, forKey: "budgetAmount")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Subtract to $100 to category that was just created
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("subtractFromBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "budgetID")
        json.setValue(100, forKey: "amountToAdd")
        json.setValue("0", forKey: "userID") // do we need this? maybe for later?
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
        
    }
    
    func testBarChart() {
        // Assume Sealand has a bar chart object that is populated with a list of the last 6 historical transactions. He also has an list of max size 6, with lists of transations, where each index of the list represents a day. In each day, either a of transactions for that day or the total amount spent for that day is stored.
        // testBarChart functionality:
        // 1. create a transaction in a specific category
        // 2. grab bar chart object, sealand checks if the bar chart object's list isn't empty
        // 3. return true
        
        let budgetAmount = 10000
        let categoryAmount = 5000
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        
        // Create category with amount of $5000
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "bigBudgetID")
        json.setValue(categoryAmount, forKey: "budgetAmount")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Add to $100 to category that was just created
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("subtractFromBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "budgetID")
        json.setValue(100, forKey: "amountToAdd")
        json.setValue("0", forKey: "userID") // do we need this? maybe for later?
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Return true if bar chart list is not null
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testHistoryOfTransactions() {
        let budgetAmount = 10000
        let categoryAmount = 5000
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        
        // Create category with amount of $5000
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "bigBudgetID")
        json.setValue(categoryAmount, forKey: "budgetAmount")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Add to $100 to category that was just created
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("addToBudget", forKey: "message")
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "budgetID")
        json.setValue(100, forKey: "amountToAdd")
        json.setValue("0", forKey: "userID") // do we need this? maybe for later?
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Adds to budget, and then sealand checks if the history of transactions is not 0
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testHistoryLocations() {
        let budgetAmount = 10000
        let categoryAmount = 5000
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        
        // Create category with amount of $5000
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "bigBudgetID")
        json.setValue(categoryAmount, forKey: "budgetAmount")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Add to $100 to category that was just created
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("addToBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "budgetID")
        json.setValue(100, forKey: "amountToAdd")
        json.setValue("0", forKey: "userID") // do we need this? maybe for later?
        json.setValue(100, forKey: "markerLatitude")
        json.setValue(100, forKey: "markerLongitude")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Adds to budget, and then sealand checks if the history of transactions is not 0
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testTransactionLimitNotification() {
        let budgetAmount = 10000
        let categoryAmount = 100
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Create category with amount of $100
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "bigBudgetID")
        json.setValue(categoryAmount, forKey: "budgetAmount")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Add to $100 to category that was just created
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("subtractFromBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(0, forKey: "budgetID")
        json.setValue(99, forKey: "amountToSubtract")
        json.setValue("0", forKey: "userID") // do we need this? maybe for later?
        json.setValue(100, forKey: "markerLatitude")
        json.setValue(100, forKey: "markerLongitude")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print(jsonData)
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Adds to budget, and then sealand checks if the history of transactions is not 0
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func createBudgetSuccessful() {
        let budgetAmount = 10000
        let categoryAmount = 100
        var descriptionArray = [String]()
        var historyArray = [String]()
        var markerLatitude = [Double]()
        var markerLongitude = [Double]()
        
        // Create budget
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setValue("createBigBudget", forKey: "message")
        
        json.setValue("testname", forKey: "budgetName")
        json.setValue(budgetAmount, forKey: "budgetAmount")
        json.setValue(descriptionArray, forKey: "descriptionArray")
        json.setValue("0", forKey: "userID")
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
        
        SanityTests.client.socket.write(data: jsonData as Data)
        
        // Adds to budget, and then sealand checks if the history of transactions is not 0
        usleep(5000000)
        
        XCTAssertEqual(true, SanityTests.client.testPassed)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
