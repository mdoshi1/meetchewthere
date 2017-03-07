//
//  ReviewCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/7/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var goodChoiceLabel: UIButton!
    @IBOutlet weak var goodSafetyLabel: UIButton!
    @IBOutlet weak var okChoiceLabel: UIButton!
    @IBOutlet weak var okSafetyLabel: UIButton!
    @IBOutlet weak var badChoiceLabel: UIButton!
    @IBOutlet weak var badSafetyLabel: UIButton!
    
    @IBOutlet weak var restrictionLabel: UILabel!
    
    // MARK: - ReviewCell

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
        goodChoiceLabel.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        goodChoiceLabel.layer.cornerRadius = 5.0
        okChoiceLabel.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        okChoiceLabel.layer.cornerRadius = 5.0
        badChoiceLabel.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        okChoiceLabel.layer.cornerRadius = 5.0
        
        goodSafetyLabel.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        goodSafetyLabel.layer.cornerRadius = 5.0
        okSafetyLabel.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        okSafetyLabel.layer.cornerRadius = 5.0
        badSafetyLabel.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        badSafetyLabel.layer.cornerRadius = 5.0
    }
    
}
