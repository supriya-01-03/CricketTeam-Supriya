//
//  Player_Extenion.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 22/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Player {
    
    static func savePlayers(details: [JSON], completion: @escaping((Bool) -> Void)) {
        let privateContext = PersistenceServeice.privateContext
        privateContext.perform {
            for detail in details {
                let newPlayer = Player(context: privateContext)
                newPlayer.age = detail["age"].stringValue
                newPlayer.playerId = detail["player_id"].stringValue
                newPlayer.name = detail["name"].stringValue
                newPlayer.team = detail["team"].stringValue
                newPlayer.teamStatus = detail["team_status"].stringValue
                newPlayer.building = detail["building"].stringValue
                newPlayer.picture = detail["picture"].stringValue
                newPlayer.categoryName = detail["category_name"].stringValue
                newPlayer.batsman = detail["batsman"].stringValue
                newPlayer.bowler = detail["bowler"].stringValue
                newPlayer.basePrice = detail["base_price"].stringValue
                newPlayer.points = detail["points"].stringValue
                newPlayer.pointsType = detail["points_type"].stringValue
            }
            
            do {
                if privateContext.hasChanges {
                    try privateContext.save()
                    
                    PersistenceServeice.context.performAndWait({
                        PersistenceServeice.saveContext()
                        completion(true)
                    })
                }
                else {
                    completion(false)
                }
                
            }
            catch let saveError {
                print("\n Error in saving Context savePost : \(saveError.localizedDescription)")
                completion(false)
            }
        }
    }
    
    static func getAllPlayers(completion: @escaping(([JSON]) -> Void)) {
        var requiredObjects: [JSON] = []
        let fetchPlayerRequests: NSFetchRequest<Player> = Player.fetchRequest()
        fetchPlayerRequests.returnsObjectsAsFaults = false
        
        let privateContext = PersistenceServeice.privateContext
        privateContext.performAndWait {
            do {
                let allObj = try privateContext.fetch(fetchPlayerRequests)
                for playerObj in allObj {
                    let reqObj: JSON = ["age": playerObj.age ?? "",
                                        "player_id": playerObj.playerId ?? "",
                                        "name": playerObj.name ?? "",
                                        "team": playerObj.team ?? "",
                                        "team_status": playerObj.teamStatus ?? "",
                                        "building": playerObj.building ?? "",
                                        "picture": playerObj.picture ?? "",
                                        "category_name": playerObj.categoryName ?? "",
                                        "batsman": playerObj.batsman ?? "",
                                        "bowler": playerObj.bowler ?? "",
                                        "base_price": playerObj.basePrice ?? "",
                                        "points": playerObj.points ?? "",
                                        "points_type": playerObj.pointsType ?? ""]
                    requiredObjects.append(reqObj)
                }
                
                completion(requiredObjects)
            }
            catch let err {
                print("\n Error in getAllPlayers : \(err.localizedDescription)")
            }
        }
    }
}

