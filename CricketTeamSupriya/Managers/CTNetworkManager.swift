//
//  CTNetworkManager.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CTNetworkManager: NSObject {
    
    private static var sharedInstance: CTNetworkManager!
    
    //MARK: - Shared Instance
    
    static func getSharedManager() -> CTNetworkManager {
        if  sharedInstance == nil {
            sharedInstance = CTNetworkManager()
        }
        return sharedInstance
    }
    
    private override init() {
        super.init()
    }
    
    
    //MARK: - SERVER REQUEST
    
    func fetchFromServer(withURLStr: String, allParameters: [String : Any]?, methodType: HTTPMethod = .post, isCachingRequired:Bool=false, completionBlock: @escaping ((JSON, Data?) -> Void)) {
        
        var json: JSON = ["value": false,
                          "data": ["message" : "Something went wrong"]]
        
        
        var requestHeaders: HTTPHeaders?
        
        if let tokenVal = getUserToken() {
            requestHeaders = ["token" : tokenVal]
        }
        
        
        Alamofire.AF.request((BASE_URL + withURLStr), method: methodType, parameters: allParameters, encoding: JSONEncoding.default, headers: requestHeaders).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    var resData: Data? = nil
                    json = JSON(data)
                    if isCachingRequired {
                        do {
                            resData = try json.rawData()
                        }
                        catch let error {
                            print("\n Error while json to data: \(error)")
                        }
                    }
                    completionBlock(json, resData)
                }
                break
                
            case .failure(_):
                if let err = response.result.error {
                    json = ["value": false,
                            "data": ["message" : err.localizedDescription]]
                }
                completionBlock(json, nil)
                break
            }
        }
    }

}
