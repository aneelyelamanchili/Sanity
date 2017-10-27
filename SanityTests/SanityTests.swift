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
    
    func testLogin() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        usleep(2000000)
        let expectation = XCTestExpectation(description: "Received response from backend")
        let username = "a"
        let password = "a"
        
        SanityTests.client.establishConnection {
            
        }
        
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
