//
//  ProfileViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/4/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ProfileViewController: UIViewController {
    
    enum Option: Int {
        case restriction = 0
        case review
        case login
        
        var string: String {
            switch self {
            case .restriction:
                return "Edit Restrictions"
            case .review:
                return "My Reviews"
            case .login:
                if AccessToken.current != nil {
                    return "Logout"
                } else {
                    return "Login"
                }
            }
        }
        
        static var count: Int { return Option.login.rawValue + 1 }
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
    fileprivate var isLoggedOn = false
    
    // MARK: - ProfileViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(optionsTable.usingAutolayout())
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        
        // optionsTable constraints
        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: view.centerYAnchor),
            optionsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            optionsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }
    
    // MARK: - Button Actions
    
    func toRestrictions() {
    
    }
    
    func toReviews() {
        
    }
    
    func handleLogin() {
        let fbLoginManager = LoginManager()
        guard AccessToken.current == nil else {
            fbLoginManager.logOut()
            print("Successfully logged out with Facebook")
            optionsTable.reloadData()
            return
        }
        
        fbLoginManager.logIn([.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("Failed to login with Facebook: \(error)")
            case .cancelled:
                print("Cancelled logging in with Facebook")
            case .success(_, _, _):
                print("Successfully logged in with Facebook")
                DispatchQueue.main.async {
                    self.optionsTable.reloadData()
                }
            }
        }
    }
    
}

// MARK: - UITableView Methods

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Option.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(Option.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTable.dequeueReusableCell(withIdentifier: optionCellIdentifier) as! OptionCell
        cell.optionButton.setTitle(Option(rawValue: indexPath.row)!.string, for: .normal)
        switch Option(rawValue: indexPath.row)! {
        case .restriction:
            cell.optionButton.addTarget(self, action: #selector(toRestrictions), for: .touchUpInside)
        case .review:
            cell.optionButton.addTarget(self, action: #selector(toReviews), for: .touchUpInside)
        case .login:
            cell.optionButton.setImage(UIImage(named: "facebook_logo"), for: .normal)
            cell.optionButton.centerContent(withSpacing: 8.0)
            cell.optionButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        }
        return cell
    }
    
}
