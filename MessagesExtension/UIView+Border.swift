//
//  UIView+Border.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

extension UIView {
    
    func drawBorder(withWidth width: CGFloat) {
        layer.borderWidth = width
    }
    
    func hideBorder() {
        layer.borderWidth = 0
    }
    
}
