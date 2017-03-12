//
//  BusinessManager.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/20/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation
import YelpAPI

class BusinessManager {
    
    static let shared = BusinessManager()
    
    var businesses: [YLPBusiness] = []
}
