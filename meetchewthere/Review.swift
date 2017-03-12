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
    
    init?(dictionary: JSONDictionary) {
        /*print("dcitoin \(dictionary)")
        guard let blah = dictionary["userid"] as? String else {
            print("blah user")
            return nil
        }
        guard let b = dictionary["bizid"] as? String else {
            print("blah biz")
            return nil
        }
        guard let a = dictionary["restriction"] as? String else {
            print("blah restrict")
            return nil
        }
        guard let c = dictionary["choice"] as? Int else {
            print("choice \(dictionary["choice"])")
            print("blah choice")
            return nil
        }
        guard let d = dictionary["safety"] as? Int else {
            print("safety \(dictionary["safety"])")
            print("blah safety")
            return nil
        }
        guard let e = dictionary["reviewtxt"] as? String else {
            print("review \(dictionary["reviewtext"])")
            print("blah review")
            return nil
        }*/
        
        
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
