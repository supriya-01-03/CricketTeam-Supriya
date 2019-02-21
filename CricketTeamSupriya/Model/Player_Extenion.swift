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
                
                let fetchPlayerRequest: NSFetchRequest<Player> = Player.fetchRequest()
                fetchPlayerRequest.predicate = NSPredicate(format: "playerId = %@", detail["player_id"].stringValue)
                fetchPlayerRequest.returnsObjectsAsFaults = false
                
                var playerObject: Player!
                
                let mainContext = PersistenceServeice.context
                mainContext.performAndWait({
                    do {
                        if let existingPlayer = try mainContext.fetch(fetchPlayerRequest).first {
                            playerObject = existingPlayer
                        }
                        else {
                            playerObject = Player(context: privateContext)
                            playerObject.playerId = detail["player_id"].stringValue
                        }
                        
                        playerObject.age = detail["age"].stringValue
                        playerObject.playerId = detail["player_id"].stringValue
                        playerObject.name = detail["name"].stringValue
                        playerObject.team = detail["team"].stringValue
                        playerObject.teamStatus = detail["team_status"].stringValue
                        playerObject.building = detail["building"].stringValue
                        playerObject.picture = detail["picture"].stringValue
                        playerObject.categoryName = detail["category_name"].stringValue
                        playerObject.batsman = detail["batsman"].stringValue
                        playerObject.bowler = detail["bowler"].stringValue
                        playerObject.basePrice = detail["base_price"].stringValue
                        playerObject.points = detail["points"].stringValue
                        playerObject.pointsType = detail["points_type"].stringValue
                    }
                    catch let _ {
                    }
                })
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
        fetchPlayerRequests.sortDescriptors = [NSSortDescriptor(key: "playerId", ascending: true)]
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

