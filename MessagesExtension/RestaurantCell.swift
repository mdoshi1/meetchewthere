//
//  RestaurantCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var restrictionsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var checkMark: CheckMark!
    
    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
    }
    
    func setChecked(_ selected: Bool) {
        if selected {
            checkMark.setChecked(true)
        } else {
            checkMark.setChecked(false)
        }
    }
}
