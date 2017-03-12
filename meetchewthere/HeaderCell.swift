//
//  HeaderCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/9/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var username: UILabel!
    
    // MARK: - HeaderCell

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
