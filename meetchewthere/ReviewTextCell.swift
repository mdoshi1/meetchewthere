//
//  ReviewTextCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class ReviewTextCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var reviewText: UITextView!
    
    // MARK: - ReviewTextCell

    override func awakeFromNib() {
        super.awakeFromNib()
        reviewText.returnKeyType = .done
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
