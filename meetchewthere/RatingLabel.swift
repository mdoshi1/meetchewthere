//
//  RatingLabel.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/19/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

enum RatingType: String {
    case choice = "Choice"
    case safety = "Safety"
}

enum Rating {
    case na
    case bad
    case okay
    case good
}

class RatingLabel: UILabel {
    
    // MARK: - Properties
    
    private static let topInset: CGFloat = 4.0
    private static let bottomInset: CGFloat = 4.0
    private static let leftInset: CGFloat = 6.0
    private static let rightInset: CGFloat = 6.0
    private static let cornerRadius: CGFloat = 10.0
    
    // MARK: - RatingLabel

    init(frame: CGRect = CGRect.zero, type: RatingType, rating: Rating = .na) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = RatingLabel.cornerRadius
        self.layer.masksToBounds = true
        self.text = type.rawValue
        self.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        let randomRating = Int(arc4random_uniform(4) + 1)
        switch randomRating {
        case 1:
            self.backgroundColor = .chewGray
        case 2:
            self.backgroundColor = .chewRed
        case 3:
            self.backgroundColor = .chewYellow
        case 4:
            self.backgroundColor = .chewGreen
        default:
            self.backgroundColor = .chewGray
        }
        
        /*switch rating {
        case .bad:
            self.backgroundColor = .chewGray
        case .okay:
            self.backgroundColor = .yellow
        case .good:
            self.backgroundColor = .chewGreen
        default:
            self.backgroundColor = .chewGray
        }*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: RatingLabel.topInset, left: RatingLabel.leftInset, bottom: RatingLabel.bottomInset, right: RatingLabel.rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var instrinsicContentSize = super.intrinsicContentSize
        instrinsicContentSize.height += RatingLabel.topInset + RatingLabel.bottomInset
        instrinsicContentSize.width += RatingLabel.leftInset + RatingLabel.rightInset
        return instrinsicContentSize
    }
}
