//
//  YLPClient+Search.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/8/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

typealias YLPSearchCompletionHandler = (YLPSearch?, Error?) -> ()

extension YLPClient {
    
    func search(withLocation location: String, term: String? = nil, completionHandler: @escaping YLPSearchCompletionHandler) {
        let query = YLPQuery(withLocation: location)
        query.term = term
        search(withQuery: query, completionHandler: completionHandler)
    }
    
    func search(withQuery query: YLPQuery, completionHandler: @escaping YLPSearchCompletionHandler) {
        let params = query.parameters()
        let request = searchRequest(withParams: params)
        
        queryWithRequest(request) { (responseDict, error) in
            guard let responseDict = responseDict as? JSONDictionary, error == nil else {
                print("Search query failed")
                completionHandler(nil, error)
                return
            }
            
            let search = YLPSearch(withDictionary: responseDict)
            completionHandler(search, nil)
            
        }
    }
    
    func searchRequest(withParams params: [String:String]) -> URLRequest {
        return request(withPath: "/v3/businesses/search", params: params)
    }
}
