//
//  VotingViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class VotingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var sharedRestaurants: [Int] = []
    
    // MARK: - VotingViewController
    
    init(_ url: URL?) {
        if let url = url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems {
            
            var index = 0
            for queryItem in queryItems {
                guard let stringValue = queryItem.value,
                    let intValue = Int(stringValue) else {
                        continue
                }
                
                print("Restaurant number \(intValue)")

                sharedRestaurants.append(intValue)
                index += 1
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
