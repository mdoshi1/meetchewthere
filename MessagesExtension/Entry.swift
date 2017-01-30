//
//  Entry.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

class Entry {
    let title : String
    let restrictions : String
    let distance : String
    let restImage: String
    let ratings: String
    init(title : String, restrictions : String, distance: String, restImage: String, ratings: String){
        self.title = title
        self.restrictions = restrictions
        self.distance = distance
        self.restImage = restImage
        self.ratings = ratings
    }
}
