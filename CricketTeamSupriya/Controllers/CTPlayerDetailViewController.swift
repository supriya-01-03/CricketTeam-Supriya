//
//  CTPlayerDetailViewController.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import SwiftyJSON

class CTPlayerDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var displayImageview: UIImageView!
    
    private let paramsArray = ["Player Id", "Name", "Age", "Team", "Team Status", "Category Name", "Batsman", "Bowler", "Building", "Points", "Points Type", "Base Price"]
    var valuesArray : [String] = []
    
    
    var detailJSON: JSON = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayImageview.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        self.displayImageview.sd_setImage(with: getImageURL(fromURLString: detailJSON["picture"].stringValue), placeholderImage: getPlaceholderImage(), options: [.highPriority, .retryFailed]) { (img, err, cache, url) in
            self.displayImageview.image = img
        }
        
        valuesArray = [detailJSON["player_id"].stringValue,
                       detailJSON["name"].stringValue,
                       detailJSON["age"].stringValue,
                       detailJSON["team"].stringValue,
                       detailJSON["team_status"].stringValue,
                       detailJSON["category_name"].stringValue,
                       detailJSON["batsman"].stringValue,
                       detailJSON["bowler"].stringValue,
                       detailJSON["building"].stringValue,
                       detailJSON["points"].stringValue,
                       detailJSON["points_type"].stringValue,
                       detailJSON["base_price"].stringValue]
    }
    
    
    //MARK: Tableview Datasource & Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailCell = tableView.dequeueReusableCell(withIdentifier: "playerDetailCell", for: indexPath) as! CTPlayerDetailTableviewCell
        detailCell.setData(paramName: paramsArray[indexPath.row], paramValue: valuesArray[indexPath.row])
        return detailCell
    }
    
    

}
