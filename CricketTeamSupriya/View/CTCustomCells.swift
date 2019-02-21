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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.displayImageView.layer.cornerRadius = self.displayImageView.frame.height/2
        self.displayImageView.layer.borderColor = UIColor.gray.cgColor
        self.displayImageView.layer.borderWidth = 1.0
        
    }
    
    func setData(detailData: JSON) {
        self.nameLabel.text = detailData["name"].stringValue.capitalized
        
        self.displayImageView.sd_setImage(with: getImageURL(fromURLString: detailData["picture"].stringValue), placeholderImage: UIImage(named: "placeholder"), options: [.highPriority, .retryFailed]) { (img, err, cache, url) in
            self.displayImageView.image = img
        }
    }
    
}
