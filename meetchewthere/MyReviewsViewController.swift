//
//  MyReviewsViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/12/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit
import FacebookCore

class MyReviewsViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var reviewsTable: UITableView = {
        let reviewsTable = UITableView()
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        reviewsTable.allowsSelection = false
        reviewsTable.rowHeight = UITableViewAutomaticDimension
        reviewsTable.register(UINib(nibName: "MyReviewCell", bundle: nil), forCellReuseIdentifier: "MyReviewCell")
        return reviewsTable
    }()
    
    private lazy var noReviewsLabel: UILabel = {
        let noReviewsLabel = UILabel()
        noReviewsLabel.font = UIFont.systemFont(ofSize: 24.0)
        noReviewsLabel.textColor = .chewDarkGray
        noReviewsLabel.numberOfLines = 0
        noReviewsLabel.textAlignment = .center
        noReviewsLabel.text = "No reviews"
        return noReviewsLabel
    }()
    
    var restriction: String = ""
    var reviews: [Review] = [] {
        didSet {
            reviewsTable.reloadData()
        }
    }
    
    fileprivate var dispatchGroup = DispatchGroup()
    
    //MARK: - MyReviewsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change back button to white
        navigationController?.navigationBar.tintColor = .white
        
        // Make sure a user is logged in
        guard let userId = UserProfile.current?.userId else {
            print("No user currently logged in")
            dismiss(animated: true, completion: nil)
            return
        }
        
        view.addSubview(reviewsTable.usingAutolayout())
        view.addSubview(noReviewsLabel.usingAutolayout())
        setupConstraints()
        
        Webservice.getUserReviews(forUserId: userId) { jsonDictionary in
            guard let dictionary = jsonDictionary?["rows"] as? [JSONDictionary] else {
                print("User reviews response could not be parsed as a JSON dictionary")
                return
            }
            let reviews = dictionary.flatMap(Review.init)
            for index in 0..<reviews.count {
                self.dispatchGroup.enter()
                let review = reviews[index]
                AppDelegate.sharedYLPClient.business(withId: review.businessId, completionHandler: { business, error in
                    guard let business = business, error == nil else {
                        print("Error retrieivng business with businessId \(review.businessId)")
                        self.dispatchGroup.leave()
                        return
                    }
                    reviews[index].businessName = business.name
                    self.dispatchGroup.leave()
                })
            }
            
            self.dispatchGroup.notify(queue: .main) {
                self.reviews = reviews
                if self.reviews.count > 0 {
                    self.noReviewsLabel.isHidden = true
                } else {
                    self.reviewsTable.isHidden = true
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        
        // Reviews Table
        NSLayoutConstraint.activate([
            reviewsTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            reviewsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reviewsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
        
        // No Review Label
        NSLayoutConstraint.activate([
            noReviewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noReviewsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noReviewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            noReviewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16.0)
            ])
    }
}

// MARK: - UITableView Methods
extension MyReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCell") as! MyReviewCell
        let review = reviews[indexPath.row]
        cell.reviewTextLabel.text = review.reviewText
        
        var choiceButtonColor = UIColor()
        var choiceButtonText = ""
        switch review.choice {
        case "1":
            choiceButtonColor = .chewRed
            choiceButtonText = "Bad Choice"
        case "2":
            choiceButtonColor = .chewYellow
            choiceButtonText = "OK Choice"
        case "3":
            choiceButtonColor = .chewGreen
            choiceButtonText = "Good Choice"
        default:
            choiceButtonColor = .chewGray
            choiceButtonText = "Choice"
        }
        cell.choiceButton.backgroundColor = choiceButtonColor
        cell.choiceButton.setTitle(choiceButtonText, for: .normal)
        
        var safetyButtonColor = UIColor()
        var safetyButtonText = ""
        switch review.safety {
        case "1":
            safetyButtonColor = .chewRed
            safetyButtonText = "Bad Safety"
        case "2":
            safetyButtonColor = .chewYellow
            safetyButtonText = "OK Safety"
        case "3":
            safetyButtonColor = .chewGreen
            safetyButtonText = "Good Safety"
        default:
            safetyButtonColor = .chewGray
            safetyButtonText = "Safety"
        }
        cell.safetyButton.backgroundColor = safetyButtonColor
        cell.safetyButton.setTitle(safetyButtonText, for: .normal)
        cell.restaurantLabel.text = review.businessName
        cell.restrictionLabel.text = review.restriction
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            guard let userId = UserProfile.current?.userId else {
                print("No user currently logged in")
                tableView.setEditing(false, animated: true)
                return
            }
            
            Webservice.deleteReview(forUserId: userId, businessId: self.reviews[indexPath.row].businessId, completion: { success in
                DispatchQueue.main.async {
                    if success {
                        print("Successfully deleted user review")
                        self.reviews.remove(at: indexPath.row)
                    } else {
                        print("Failed to delete user review")
                    }
                    tableView.setEditing(false, animated: true)
                }
            })
            
            
            
        }
        
        return [action]
    }
}
