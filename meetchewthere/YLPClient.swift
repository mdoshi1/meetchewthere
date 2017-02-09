//
//  YLPClient.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/8/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

class YLPClient {
    
    // MARK: - Properties
    
    static let sharedYLPClient = YLPClient()
    private static let kYLPAPIHost = "api.yelp.com"
    
    private lazy var _accessToken: String? = {
        return nil
    }()
    
    var accessToken: String? {
        get {
            return _accessToken
        }
        set(newValue) {
            _accessToken = newValue
        }
    }
    
    // MARK: - YLPClient
    
    func request(withPath path: String, params: [String:String]) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = YLPClient.kYLPAPIHost
        urlComponents.path = path
        
        let queryItems = queryItemsForParams(params)
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let authHeader = String(format: "Bearer %@", accessToken!) // TODO: don't force cast
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    /*func query(withRequest request: URLRequest, completionHandler: @escaping (Any?, Error?) -> ()) {
        queryWithRequest(request, completionHandler: completionHandler)
    }*/
    
    // MARK: - Request Utilities
    
    func queryWithRequest(_ request: URLRequest, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Request response is not an HTTPURLResponse")
                return
            }
            guard httpResponse.statusCode == 200 else {
                print("Request failed with http response code: \(httpResponse)")
                completionHandler(nil, error)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            completionHandler(responseJSON, error)
            }.resume()
    }
    
    func queryItemsForParams(_ params: [String:String]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        for pair in params {
            let queryItem = URLQueryItem(name: pair.key, value: pair.value)
            queryItems.append(queryItem)
        }
        return queryItems
    }
    
    func URLEncodeAllowedCharacters() -> CharacterSet {
        var allowedCharacters = CharacterSet()
        allowedCharacters.insert(charactersIn: UnicodeScalar("A")...UnicodeScalar("Z"))
        allowedCharacters.insert(charactersIn: UnicodeScalar("a")...UnicodeScalar("z"))
        allowedCharacters.insert(charactersIn: UnicodeScalar("0")...UnicodeScalar("9"))
        allowedCharacters.insert(charactersIn: "-._~")
        return allowedCharacters
    }

    // MARK: - Authorization
    
    func authorizeWithAppId(_ appId: String, secret: String, completionHandler: @escaping (Bool) -> ()) {
        let request = authRequestWithAppId(appId, secret: secret)
        queryWithRequest(request) { (jsonResponse, error) in
            
            guard let jsonResponse = jsonResponse as? JSONDictionary, error == nil else {
                print("Error authorizing app id")
                completionHandler(false)
                return
            }
            
            let accessToken = jsonResponse["access_token"] as? String
            print("Access token: \(accessToken)")
            YLPClient.sharedYLPClient.accessToken = accessToken
            completionHandler(true)
        }
    }
    
    func authRequestWithAppId(_ appId: String, secret: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = YLPClient.kYLPAPIHost
        urlComponents.path = "/oauth2/token";
        
        let allowedCharacters = URLEncodeAllowedCharacters()
        let body = String(format: "grant_type=client_credentials&client_id=%@&client_secret=%@", appId.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!, secret.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!)
        let bodyData = body.data(using: .utf8)
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue(String(format: "%zd", [bodyData?.count]), forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
