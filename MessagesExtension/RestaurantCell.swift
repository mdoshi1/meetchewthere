//
//  RestaurantCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var restrictionsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var circleLayer: CAShapeLayer = {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 352.5,y: 50.0), radius: 9.0, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 1.0
        
        return circleLayer
    }()
    
    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
        
        // Add empty checkmark circle
        layer.addSublayer(circleLayer)
        tintColor = .white
        selectionStyle = .none
    }
    
    func setChecked(isSelected: Bool) {
        if isSelected {
            circleLayer.fillColor = UIColor.chewBlue.cgColor
        } else {
            circleLayer.fillColor = UIColor.clear.cgColor
        }
    }
}
