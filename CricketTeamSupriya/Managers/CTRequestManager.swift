//
//  CTRequestManager.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import SwiftyJSON

class CTRequestManager: NSObject {

    private static var sharedInstance: CTRequestManager!
    
    //MARK: - Shared Instance
    
    static func getSharedManager() -> CTRequestManager {
        if  sharedInstance == nil {
            sharedInstance = CTRequestManager()
        }
        return sharedInstance
    }
    
    private override init() {
        super.init()
    }
    
    
    //MARK: - Make Requests
    
    func loginUser(emailValue: String, passwordValue: String, completion: @escaping ((JSON) -> Void)) {
        CTNetworkManager.getSharedManager().fetchFromServer(withURLStr: "user/login", allParameters: ["email": emailValue, "password": passwordValue]) { (serverResponse) in
            completion(serverResponse)
        }
    }
    
    func getAllPlayers(categoryF: String = "", skillF: String = "", buildingF: String = "", team_statusF: String = "", completion: @escaping ((JSON) -> Void)) {
        
        var parameters: [String : Any] = [:]
        if categoryF != "" {
            parameters["category"] = categoryF
        }
        if skillF != "" {
            parameters["skill"] = skillF
        }
        if buildingF != "" {
            parameters["building"] = buildingF
        }
        if team_statusF != "" {
            parameters["team_status"] = team_statusF
        }
        
        
        
        CTNetworkManager.getSharedManager().fetchFromServer(withURLStr: "players", allParameters: (parameters.isEmpty ? nil : parameters)) { (serverResponse) in
            completion(serverResponse)
        }
    }
    
    func getFilters(completion: @escaping ((JSON) -> Void)) {
        CTNetworkManager.getSharedManager().fetchFromServer(withURLStr: "players/filters", allParameters: nil, methodType: .get) { (serverResponse) in
            completion(serverResponse)
        }
    }
    
    
}
