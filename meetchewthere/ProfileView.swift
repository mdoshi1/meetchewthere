//
//  ProfileView.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/5/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import FacebookCore

class ProfileView: UIView {
    
    // MARK: - Properties
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.backgroundColor = .chewGray
        if let userProfile = UserProfile.current {
            let profileImageURL = userProfile.imageURLWith(.square, size: CGSize(width: Constants.UI.ProfileImageWidth, height: Constants.UI.ProfileImageWidth))
            Webservice.getImage(withURL: profileImageURL) { data in
                if let data = data {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: data)
                    }
                }
            }
        }
        profileImage.layer.cornerRadius = Constants.UI.ProfileImageWidth / 2.0
        profileImage.layer.masksToBounds = true
        return profileImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .white
        if let userProfile = UserProfile.current,
            let userName = userProfile.fullName {
            nameLabel.text = userName
        } else {
            nameLabel.text = "You are not logged in"
        }
        return nameLabel
    }()
    
    private lazy var restrictionsLabel: UILabel = {
        let restrictionsLabel = UILabel()
        restrictionsLabel.textColor = .white
        if let userProfile = UserProfile.current {
            
        } else {
            restrictionsLabel.text = ""
        }
        return restrictionsLabel
    }()
    
    // MARK: - ProfileView
    
    init(userId: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.addSubview(profileImage.usingAutolayout())
        self.addSubview(nameLabel.usingAutolayout())
        self.addSubview(restrictionsLabel.usingAutolayout())
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    private func setupConstrains() {
        
        // Profile Image
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 32.0),
            profileImage.widthAnchor.constraint(equalToConstant: Constants.UI.ProfileImageWidth),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor)
            ])
        
        // Name Label
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16.0)
            ])
        
        // Restrictions Label
        NSLayoutConstraint.activate([
            restrictionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            restrictionsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.0)
            ])
    }
    
    func update() {
        if let userProfile = UserProfile.current {
            
            // Update profile image
            let profileImageURL = userProfile.imageURLWith(.square, size: CGSize(width: Constants.UI.ProfileImageWidth, height: Constants.UI.ProfileImageWidth))
            Webservice.getImage(withURL: profileImageURL) { data in
                if let data = data {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: data)
                    }
                }
            }
            
            // Update name
            if let userName = userProfile.fullName {
                nameLabel.text = userName
            }
        } else {
            
            // Reset profile image
            profileImage.image = nil
            
            // Reset name
            nameLabel.text = "You are not logged in"
            
            // Reset restrictions
            restrictionsLabel.text = ""
        }
    }
}
