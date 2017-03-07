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
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    
    // MARK: - Enum
    
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
    
    fileprivate lazy var profileView: ProfileView = {
        let profileView = ProfileView(userId: "blah")
        return profileView
    }()
    
    fileprivate lazy var optionsTable: UITableView = {
        let optionsTable = UITableView()
        optionsTable.delegate = self
        optionsTable.dataSource = self
        optionsTable.register(UINib(nibName: "OptionCell", bundle: nil), forCellReuseIdentifier: "OptionCell")
        optionsTable.isScrollEnabled = false
        optionsTable.allowsSelection = false
        return optionsTable
    }()
    
    fileprivate let optionCellIdentifier = "OptionCell"
    fileprivate var isLoggedOn = false
    
    // MARK: - ProfileViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar bottom border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Listen for FB token change
        UserProfile.updatesOnAccessTokenChange = true
        
        // Add subviews
        view.addSubview(profileView.usingAutolayout())
        view.addSubview(optionsTable.usingAutolayout())
        setupConstraints()
        
        // Setup notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileChange), name: NSNotification.Name.FBSDKProfileDidChange, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileView.update()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FBSDKProfileDidChange, object: nil)
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        
        // Profile View
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            profileView.leftAnchor.constraint(equalTo: view.leftAnchor),
            profileView.rightAnchor.constraint(equalTo: view.rightAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -22.0)
            ])
        
        // Options Table
        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            optionsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            optionsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }
    
    // MARK: - Notification Actions
    
    func handleProfileChange(_ notification: Notification) {
        profileView.update()
    }
    
    // MARK: - Button Actions
    
    func toRestrictions() {
        if UserProfile.current != nil {
            performSegue(withIdentifier: "toRestrictions", sender: nil)
        } else {
            let alertController = UIAlertController(title: "You're not logged in", message: "Log in to edit your dietary restrictions", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func toReviews() {
        if UserProfile.current != nil {
            // TODO: segue to user reviews
        } else {
            let alertController = UIAlertController(title: "You're not logged in", message: "Log in to view your restaurant reviews", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
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
    
    // MARK: - Navigation
    
    @IBAction func prepareForUnwind(sender: UIStoryboardSegue) {
        
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
