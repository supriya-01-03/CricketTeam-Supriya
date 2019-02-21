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
        CTNetworkManager.getSharedManager().fetchFromServer(withURLStr: "user/login", allParameters: ["email": emailValue, "password": passwordValue]) { (serverResponse, _) in
            completion(serverResponse)
        }
    }
    
    func getAllPlayers(completion: @escaping ((JSON) -> Void)) {
        CTNetworkManager.getSharedManager().fetchFromServer(withURLStr: "players", allParameters: nil) { (serverResponse, _) in
            completion(serverResponse)
        }
    }
    
    func getFilters(completion: @escaping ((JSON) -> Void)) {
        CTNetworkManager.getSharedManager().fetchFromServer(withURLStr: "players/filters", allParameters: nil, methodType: .get, isCachingRequired: false) { (serverResponse, _) in
            completion(serverResponse)
        }
    }
    
    
}
