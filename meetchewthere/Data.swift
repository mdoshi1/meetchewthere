//
//  Data.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

class Data {
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
    let places = [
        Entry(title: "RawDaddy’s Fun Cone Food", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest4.png", ratings: "ratings.png"),
        Entry(title: "Calafia Cafe", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "California Pizza Kitchen", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest2.png", ratings: "ratings.png"),
        Entry(title: "Shuly's Bakery", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest3.png", ratings: "ratings.png"),
        Entry(title: "Lyfe Kitchen", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest4.png", ratings: "ratings.png"),
        Entry(title: "The Melt Stanford", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "Gott's Roadside", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "American (New), Burgers", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "Tacolicous", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "Mexican, Cocktail Bars", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "Cascal Restaurant", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png"),
        Entry(title: "JJ Magoo's Pizza", restrictions: "Restrictions", distance: "0.0 mi", restImage: "rest1.png", ratings: "ratings.png")
    ]
    
}
