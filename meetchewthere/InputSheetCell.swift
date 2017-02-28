//
//  InputSheetCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class InputSheetCell: UITableViewCell {
    
    // MARK: - IBOutles
    
    @IBOutlet weak var inputField: UITextField!
    
    //MARK: - InputSheetCell

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
