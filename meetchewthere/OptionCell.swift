//
//  OptionCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/4/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    
    // MARK: - IBOutles
    
    @IBOutlet weak var optionLabel: UILabel!
    
    // MARK: - OptionCell

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
