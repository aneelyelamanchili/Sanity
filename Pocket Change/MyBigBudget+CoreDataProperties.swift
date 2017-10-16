//
//  MyBigBudget+CoreDataProperties.swift
//  Pocket Change
//
//  Created by William Wang on 10/16/17.
//  Copyright © 2017 Nathan Tsai. All rights reserved.
//

import Foundation
import CoreData
import GoogleMaps

extension MyBigBudget
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyBigBudget>
    {
        return NSFetchRequest<MyBigBudget>(entityName: "MyBigBudget")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var balance: Double
    @NSManaged public var barGraphColor: Int
    @NSManaged public var descriptionArray: [String]
    @NSManaged public var historyArray: [String]
    @NSManaged public var markerLatitude: [Double]
    @NSManaged public var markerLongitude: [Double]
    @NSManaged public var amountSpentOnDate: [String: Double]
    @NSManaged public var totalAmountSpent: Double
    @NSManaged public var totalBudgetAmount: Double
    @NSManaged public var totalAmountAdded: Double
}
