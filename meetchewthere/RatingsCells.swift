//
//  RatingsCells.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class RatingsCells: UITableViewCell {

    @IBOutlet weak var restriction: UILabel?
    @IBOutlet weak var rating: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
