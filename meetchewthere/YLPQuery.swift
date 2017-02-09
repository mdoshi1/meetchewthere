//
//  YLPQuery.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/8/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

class YLPQuery {
    
    private enum YLPSearchMode {
        case YLPSearchModeLocation
        case YLPSearchModeCoordinate
    }
    
    private var mode: YLPSearchMode
    private var location: String = ""
    
    var term: String?
    var limit: Int?
    var offset: Int?
    
    
    init(withLocation location: String) {
        mode = .YLPSearchModeLocation
        self.location = location
    }
    
    func parameters() -> [String:String] {
        var params = [String:String]()
        switch (mode) {
        case .YLPSearchModeLocation:
            params["location"] = location
            break
        case .YLPSearchModeCoordinate:
            // TODO
            break;
        }
        
        if let term = self.term {
            params["term"] = term
        }
        if let limit = self.limit {
            params["limit"] = String(limit)
        }
        if let offset = self.offset {
            params["offset"] = String(offset)
        }
        
        return params
    }
}
