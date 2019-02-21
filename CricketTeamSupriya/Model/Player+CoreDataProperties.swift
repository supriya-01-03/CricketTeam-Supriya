//
//  Player+CoreDataProperties.swift
//  
//
//  Created by Supriya Malgaonkar on 22/02/19.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var playerId: String?
    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var team: String?
    @NSManaged public var teamStatus: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var batsman: String?
    @NSManaged public var bowler: String?
    @NSManaged public var building: String?
    @NSManaged public var points: String?
    @NSManaged public var pointsType: String?
    @NSManaged public var basePrice: String?
    @NSManaged public var picture: String?

}
