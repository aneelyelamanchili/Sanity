//
//  SanityTests.swift
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
    
//    func testLoginPassword() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let expectation = XCTestExpectation(description: "Received response from backend")
//        let username = "a"
//        let password = "b"
//
//        client.establishConnection {
//
//        }
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("logintest", forKey: "message")
//        json.setValue(username, forKey: "email")
//        json.setValue(password, forKey: "password")
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        client.socket.write(data: jsonData as Data)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            print("DISPATCH")
//            let testPassed = Client.testPassed
//            print(testPassed)
//
//            XCTAssertEqual(false, testPassed)
//        })
//
//        usleep(5000000)
//    }
//
//    func testLoginEmail() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let expectation = XCTestExpectation(description: "Received response from backend")
//
//        let username = "b"
//        let password = "a"
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("logintest", forKey: "message")
//        json.setValue(username, forKey: "email")
//        json.setValue(password, forKey: "password")
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
//            XCTAssertEqual(false, testPassed)
//        })
//
//        usleep(5000000)
//    }

    func testSignup() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Received response from backend")
        let firstname = "David"
        let lastname = "Sealand"
        let password = "Hello"
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
            print("GOT INTO DISPATCH")
            
            XCTAssertEqual(true, testPassed)
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
//
//
//    func testBudgetAmountNegative() {
//        let budgetAmount = -1.0
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        SanityTests.client.establishConnection {
//
//        }
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//        usleep(5000000)
//
//        XCTAssertEqual(true, SanityTests.client.testPassed)
//    }
//
//    func testBudgetAmountString() {
//        let budgetAmount = "testAmount"
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        SanityTests.client.establishConnection {
//
//        }
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//        usleep(5000000)
//
//        XCTAssertEqual(true, SanityTests.client.testPassed)
//    }
//
//    func testLargePositiveBudget() {
//        let budgetAmount = "999999999999999"
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        SanityTests.client.establishConnection {
//
//        }
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//        usleep(5000000)
//
//        XCTAssertEqual(true, SanityTests.client.testPassed)
//    }
//
//
//    func testDeleteBudget() {
//
//        SanityTests.client.establishConnection {
//
//        }
//
//        usleep(2000000)
//
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("deleteBigBudget", forKey: "message")
//
//        json.setValue(0, forKey: "budgetID")
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
//        var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//        print(jsonData)
//
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//        usleep(5000000)
//
//        XCTAssertEqual(true, SanityTests.client.testPassed)
//    }
//
//    func testAddToBudget() {
//        let budgetAmount = 5000
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        // Create budget with amount of $5000
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//        // Add to $100 to budget that was just created
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//    }
//
//    func testBarChart() {
//        //
//        let budgetAmount = 5000
//        var descriptionArray = [String]()
//        var historyArray = [String]()
//        var markerLatitude = [Double]()
//        var markerLongitude = [Double]()
//
//        // Create budget with amount of $5000
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//        // Add to $100 to budget that was just created
//        let json:NSMutableDictionary = NSMutableDictionary()
//        json.setValue("createBigBudget", forKey: "message")
//
//        json.setValue("testname", forKey: "budgetName")
//        json.setValue(budgetAmount, forKey: "budgetAmount")
//        json.setValue(descriptionArray, forKey: "descriptionArray")
//        json.setValue("0", forKey: "userID")
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
//        SanityTests.client.socket.write(data: jsonData as Data)
//
//    }
    
}
