//
//  CTCustomCells.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import SwiftyJSON

class CTLoadingCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class CTPlayerListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var displayImageviewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.displayImageviewWidthConstraint.constant = (self.frame.width*0.45)
        
        self.displayImageView.layer.cornerRadius = ((((UIScreen.main.bounds.width-16)/3)*0.5)/2)
        self.displayImageView.layer.borderColor = UIColor.gray.cgColor
        self.displayImageView.layer.borderWidth = 1.0
        
        
        
    }
    
    func setData(detailData: JSON) {
        self.nameLabel.text = detailData["name"].stringValue.capitalized
        
        self.displayImageView.sd_setImage(with: getImageURL(fromURLString: detailData["picture"].stringValue), placeholderImage: getPlaceholderImage(), options: [.highPriority, .retryFailed]) { (img, err, cache, url) in
            self.displayImageView.image = img
        }
    }
    
}

class CTPlayerDetailTableviewCell: UITableViewCell {
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(paramName: String, paramValue: String) {
        let displayText = getBoldString(string: "\(paramName) : ", size: 14)
        displayText.append(getRegularString(string: paramValue, size: 14))
        self.detailLabel.attributedText = displayText
    }
    
}
