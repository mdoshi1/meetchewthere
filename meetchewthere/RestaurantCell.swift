//
//  RestaurantCell.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var restrictions: UILabel?
    @IBOutlet weak var distance: UILabel?
    @IBOutlet weak var rating: UIImageView?
    @IBOutlet weak var restImage: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = (restImage?.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        restImage?.addSubview(blurEffectView)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
