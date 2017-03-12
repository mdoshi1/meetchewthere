//
//  OptionCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/4/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    
    // MARK: - IBOutles
    
    @IBOutlet weak var optionButton: UIButton!
    
    // MARK: - OptionCell

    override func awakeFromNib() {
        super.awakeFromNib()
        optionButton.setTitleColor(.black, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
