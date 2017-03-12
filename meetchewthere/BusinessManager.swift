//
//  BusinessManager.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/20/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import Foundation
import YelpAPI

class BusinessManager {
    
    static let shared = BusinessManager()
    
    var businesses: [YLPBusiness] = []
}
