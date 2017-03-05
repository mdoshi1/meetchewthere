//
//  UIButton+Layout.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/5/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

extension UIButton {
    
    func centerContent(withSpacing spacing: CGFloat) {
        let inset = spacing / 2.0
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -inset, bottom: 0, right: inset)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: -inset)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
    
}
