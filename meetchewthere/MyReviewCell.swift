//
//  MyReviewCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/12/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit

class MyReviewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restrictionLabel: UILabel!
    @IBOutlet weak var choiceButton: UIButton!
    @IBOutlet weak var safetyButton: UIButton!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    // MARK: - MyReviewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func setupButtons() {
        
        choiceButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        choiceButton.layer.cornerRadius = 5.0
        choiceButton.layer.masksToBounds = true
        choiceButton.isEnabled = false
        
        safetyButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        safetyButton.layer.cornerRadius = 5.0
        safetyButton.layer.masksToBounds = true
        safetyButton.isEnabled = false
    }
    
}
