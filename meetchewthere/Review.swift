//
//  Review.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

class Review {
    
    let userId: String
    let businessId: String
    let restriction: String
    let choice: String
    let safety: String
    let reviewText: String
    var businessName: String?
    
    init?(dictionary: JSONDictionary) {
        guard let userId = dictionary["userid"] as? String,
            let businessId = dictionary["bizid"] as? String,
            let restriction = dictionary["restriction"] as? String,
            let choice = dictionary["choice"] as? String,
            let safety = dictionary["safety"] as? String,
            let reviewText = dictionary["reviewtxt"] as? String else {
                print("Error in one or more fields of business review JSON")
                return nil
        }
        
        self.userId = userId
        self.businessId = businessId
        self.restriction = restriction
        self.choice = choice
        self.safety = safety
        self.reviewText = reviewText
    }
    
}
