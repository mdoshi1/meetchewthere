//
//  SessionManager.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/12/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    
    var reviews: [Review] = []
    var restrictions: [String] = []
    
}
