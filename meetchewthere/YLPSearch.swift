//
//  YLPSearch.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation


class YLPSearch {
    
    var total: UInt = 0
    var businesses = [YLPBusiness]()
    
    init(withDictionary searchDict: JSONDictionary) {
        total = searchDict["total"] as! UInt
        businesses = YLPSearch.businesses(fromJSONArray: searchDict["businesses"] as! [JSONDictionary])
    }
    
    class func businesses(fromJSONArray businessesJSON: [JSONDictionary]) -> [YLPBusiness] {
        var businesses = [YLPBusiness]()
        
        for business in businessesJSON {
            businesses.append(YLPBusiness(withDictionary: business))
        }
        
        return businesses
    }
}
