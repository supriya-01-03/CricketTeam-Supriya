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

class CTFilterTableviewCell: UITableViewCell {
    
    @IBOutlet weak var selectImageview: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(filterName: String, isSelected: Bool) {
        self.selectImageview.image = UIImage(named: isSelected ? "checked" : "unchecked")
        self.filterLabel.text = filterName
    }
}

protocol CTActionPerformDelgate {
    func applyFilters()
    func clearFilters()
}

class CTActionTableviewCell: UITableViewCell {
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var actionDelegate: CTActionPerformDelgate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyButton.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        applyButton.layer.borderColor = UIColor.black.cgColor
        applyButton.layer.borderWidth = 0.5
        
        clearButton.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        clearButton.layer.borderColor = UIColor.black.cgColor
        clearButton.layer.borderWidth = 0.5
    }
    
    func setDelegate(delegate: CTActionPerformDelgate?) {
        self.actionDelegate = delegate
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        self.actionDelegate?.applyFilters()
    }
    
    @IBAction func clearButtonClicked(_ sender: UIButton) {
        self.actionDelegate?.clearFilters()
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
