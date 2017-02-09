//
//  BusinessCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var restriction1: UILabel!
    @IBOutlet weak var restriction2: UILabel!
    @IBOutlet weak var restrictionRating1: UIImageView!
    @IBOutlet weak var restrictionRating2: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var restImage: UIImageView!
    
    // MARK: - BusinessCell

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
