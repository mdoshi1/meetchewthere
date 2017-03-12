//
//  UIView+Autolayout.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/17/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit

extension UIView {
    
    func usingAutolayout() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
}
