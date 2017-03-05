//
//  ProfileViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/4/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    enum Option: Int {
        case restriction = 0
        case review
        case logout
        
        var string: String {
            switch self {
            case .restriction:
                return "Edit Restrictions"
            case .review:
                return "My Reviews"
            case .logout:
                return "Logout"
            }
        }
    }
    
    // MARK: - Properties
    
    fileprivate lazy var optionsTable: UITableView = {
        let optionsTable = UITableView()
        optionsTable.delegate = self
        optionsTable.dataSource = self
        optionsTable.register(UINib(nibName: "OptionCell", bundle: nil), forCellReuseIdentifier: "OptionCell")
        optionsTable.isScrollEnabled = false
        return optionsTable
    }()
    
    fileprivate let optionCellIdentifier = "OptionCell"
    
    // MARK: - ProfileViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(optionsTable.usingAutolayout())
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    func setupConstraints() {
        
        // optionsTable constraints
        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: view.centerYAnchor),
            optionsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            optionsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTable.dequeueReusableCell(withIdentifier: optionCellIdentifier) as! OptionCell
        cell.optionLabel.text = Option(rawValue: indexPath.row)!.string
        return cell
    }
    
}
