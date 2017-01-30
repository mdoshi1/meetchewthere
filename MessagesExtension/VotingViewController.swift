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
    
    private lazy var swipeView: ZLSwipeableView = {
        let swipeView = ZLSwipeableView()
        swipeView.numberOfActiveView = 1
        return swipeView
    }()
    
    private var sharedRestaurants: [Int] = []
    private var restIndex = 0
    private let data = Data()
    
    // MARK: - VotingViewController
    
    init(_ url: URL?) {
        if let url = url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems {
            
            for queryItem in queryItems {
                //guard let value = queryItem.value else { continue }
    
                guard let stringValue = queryItem.value,
                    let intValue = Int(stringValue) else {
                        continue
                }
                print("Restaurant value: \(intValue)")
                sharedRestaurants.append(intValue)
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(swipeView.usingAutolayout())
        setUpConstraints()
        
    }*/
    
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeView.nextView = {
            return self.nextCardView()
        }
        swipeView.setNeedsLayout()
    }*/
    
    // MARK: - Helper Methods
    
    private func setUpConstraints() {
        
        // swipeView constraints
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20.0),
            swipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            swipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            swipeView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20.0)
            ])
    }
    
    /*func nextCardView() -> UIView? {
        if restIndex < sharedRestaurants.count {
            let cardView = CardView(frame: swipeView.bounds)
            cardView.backgroundColor = .black
            let restImageView = UIImageView(image: UIImage(named: sharedRestaurants[restIndex]))
            restIndex += 1
            cardView.addSubview(restImageView.usingAutolayout())
            restImageView.clipsToBounds = true
            NSLayoutConstraint.activate([
                restImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
                restImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
                restImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
                restImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
                ])
            return cardView
        } else {
            return nil
        }
    }*/
}
