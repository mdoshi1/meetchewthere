//
//  YLPBusiness.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

class YLPBusiness {
    
    let closed: Bool!
    let imageURL: URL?
    let url: URL!
    let rating: Double!
    let reviewCount: UInt!
    let name: String!
    let phone: String?
    let identifier: String!
    
    
    init(withDictionary businessDict: JSONDictionary) {
        closed = businessDict["is_closed"] as! Bool
        
        url = URL(string: businessDict["url"] as! String)
        if let imageURLString = businessDict["image_url"] as? String, imageURLString.characters.count > 0 {
            imageURL = URL(string: imageURLString)
        } else {
            imageURL = nil
        }
        
        rating = businessDict["rating"] as! Double
        reviewCount = businessDict["review_count"] as! UInt
        
        name = businessDict["name"] as! String
        identifier = businessDict["id"] as! String
        if let phone = businessDict["phone"] as? String, phone.characters.count > 0 {
            self.phone = phone
        } else {
            self.phone = nil
        }
    }
}
