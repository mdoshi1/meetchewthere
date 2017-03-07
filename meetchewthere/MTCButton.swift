//
//  MTCButton.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/6/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class MTCButton: UIButton {

    enum MTCButtonType {
        case primary
        case secondary
    }
    
    class MTCButton: UIButton {
        
        init(frame: CGRect = CGRect.zero, text: String, type: MTCButtonType) {
            super.init(frame: frame)
            self.setTitle(text, for: .normal)
            switch type {
            case .primary:
                self.backgroundColor = .white
                self.setTitleColor(.chewGreen, for: .normal)
            case .secondary:
                self.backgroundColor = .chewDarkGray
                self.setTitleColor(.white, for: .normal)
            }
            self.layer.cornerRadius = 5.0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

}
