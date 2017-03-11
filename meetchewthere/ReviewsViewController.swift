//
//  ReviewsViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var reviewsTable: UITableView = {
        let reviewsTable = UITableView()
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        return reviewsTable
    }()
    
    var reviews: [String] = []
    
    //MARK: - ReviewsViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(reviewsTable.usingAutolayout())
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    func setupConstraints() {
        
        // Reviews Table
        NSLayoutConstraint.activate([
            reviewsTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            reviewsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reviewsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }
}

// MARK: - UITableView Methods
extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
