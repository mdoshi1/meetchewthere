//
//  UIView+Autolayout.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

extension UIView {
    
    func usingAutolayout() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
}
