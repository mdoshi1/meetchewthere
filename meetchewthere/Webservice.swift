//
//  Webservice.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import Foundation

final class Webservice {
    
    class func getImage(withURLString urlString: String, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Error generating URL from string: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error)")
                print("Error in retrieving image data")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
                completion(nil)
            }
            
            completion(data)
            }.resume()
    }
    
    class func getImage(withURL url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error processing HTTP request: \(error)")
                print("Error in retrieving image data")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code should be 200, but is \(httpStatus.statusCode)")
                completion(nil)
            }
            
            completion(data)
            }.resume()
    }
    
}
