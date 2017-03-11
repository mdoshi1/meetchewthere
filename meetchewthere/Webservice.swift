//
//  Webservice.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

final class Webservice {
    
    private static let apiURL = "https://hashtag.butler-demos.com/senthil"
    
    class func getBusinessReviews(forBusinessId businessId: String, completion: @escaping(JSONDictionary?) -> ()) {
        let urlString = apiURL + "/reviews_select_bizid.php"
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "bizid=\(businessId)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = json as? JSONDictionary else {
                print("failed to case dict")
                completion(nil)
                return
            }
            completion(dictionary)
            }.resume()
    }
    
    class func postReview(forUserId userId: String, businessId: String, restriction: String, reviewText: String, choiceRating: String, safetyRating: String, completion: @escaping(Bool) -> ()) {
        
        let urlString = apiURL + "/reviews_insert_bizid_reviewtxt_choice_safety_email.php"
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "userid=\(userId)&bizid=\(businessId)&restriction=\(restriction)&reviewtxt=\(reviewText)&choice=\(choiceRating)&safety=\(safetyRating)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
            }
            
            completion(true)
            }.resume()

    }
    
    class func deleteReview(forUserId userId: String, businessId: String, completion: @escaping (Bool) -> ()) {
        
        let urlString = apiURL + "/reviews_delete_bizid_reviewtxt_choice_safety_email.php"
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "userid=\(userId)&bizid=\(businessId)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
            }
            
            completion(true)
            }.resume()
    }
    
    class func postRestrictions(forUserId userId: String, restriction: String, completion: @escaping(Bool) -> ()) {
        let urlString = apiURL + "/restrictions_insert_email_restriction.php"
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "userid=\(userId)&restriction=\(restriction)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
            }
            
            completion(true)
            }.resume()
    }
    
    class func getRestrictions(forUserId userId: String, completion: @escaping (JSONDictionary?) -> ()) {
        
        let urlString = apiURL + "/restrictions_select_email.php"
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "userid=\(userId)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = json as? JSONDictionary else {
                print("failed to case dict")
                completion(nil)
                return
            }
            completion(dictionary)
            }.resume()
    }
    
    class func deleteRestrictions(forUserId userId: String, completion: @escaping (Bool) -> ()) {
        
        let urlString = apiURL + "/restrictions_delete_email.php"
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = "userid=\(userId)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
            }
            completion(true)
            }.resume()
    }
    
    class func getImage(withURLString urlString: String, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
                completion(nil)
            } else {
                completion(data)
            }
            }.resume()
    }
    
    class func getImage(withURL url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error?.localizedDescription)")
                print("Error in retrieving image data")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
                completion(nil)
            } else {
                completion(data)
            }
            }.resume()
    }
    
    private class func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error)")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
                completion(nil)
            }
            
            completion(resource.parse(data))
            }.resume()
    }
    
}

struct Resource<A> {
    let urlRequest: URLRequest
    let parse: (Data) -> A?
}

extension Resource {
    init(urlRequest: URLRequest, parseJSON: @escaping (Any) -> A?) {
        self.urlRequest = urlRequest
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

struct Token {
    let accessToken: String
    let tokenType: String
    let expiration: Int
}

extension Token {
    init?(dictionary: JSONDictionary) {
        guard let accessToken = dictionary["access_token"] as? String,
            let tokenType = dictionary["token_type"] as? String,
            let expiration = dictionary["expires_in"] as? Int else {
                print("Error in one or more fields of Token json")
                return nil
        }
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiration = expiration
    }
}
