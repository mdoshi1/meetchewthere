//
//  MCTButton.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/6/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

enum MCTButtonType {
    case primary
    case secondary
}

class MCTButton: UIButton {
        
    init(frame: CGRect = CGRect.zero, type: MCTButtonType) {
        super.init(frame: frame)
        self.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        //self.layer.borderWidth = 2.0
        switch type {
        case .primary:
            self.backgroundColor = .white
            //self.layer.borderColor = UIColor.chewGreen.cgColor
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

