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
        profileImage.contentMode = .center
        profileImage.backgroundColor = .chewDarkGray
        profileImage.layer.cornerRadius = Constants.UI.ProfileImageWidth / 2.0
        profileImage.layer.masksToBounds = true
        return profileImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 24.0)
        return nameLabel
    }()
    
    private lazy var restrictionsLabel: UILabel = {
        let restrictionsLabel = UILabel()
        restrictionsLabel.textColor = .white
        return restrictionsLabel
    }()
    
    var restrictions = [String]()
    
    // MARK: - ProfileView
    
    init(userId: String) {
        super.init(frame: CGRect.zero)
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "food_wallpaper")!)
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
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
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
        restrictions.removeAll()
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
            } else {
                nameLabel.text = ""
            }
            
            // Update restrictions
            Webservice.getRestrictions(forUserId: userProfile.userId, completion: { jsonDictionary in
                guard let dictionary = jsonDictionary else {
                    print("Restrictions response could not be parsed as a JSON dictionary")
                    return
                }
                DispatchQueue.main.async {
                    if let restrictionsArray = dictionary["rows"] as? [JSONDictionary], restrictionsArray.count > 0 {
                        var restriction = restrictionsArray[0]["restriction"] as! String
                        self.restrictionsLabel.text = restriction
                        self.restrictions.append(restriction)
                        for index in 1..<restrictionsArray.count {
                            restriction = restrictionsArray[index]["restriction"] as! String
                            self.restrictionsLabel.text! += ", \(restriction)"
                        }
                    } else {
                        self.restrictionsLabel.text = "No dietary restrictions"
                    }
                }
            })
        } else {
            
            // Reset profile image
            profileImage.image = UIImage(named: "no_profile_image")?.scaled(toSize: CGSize(width: 80.0, height: 124.0))
            
            // Reset name
            nameLabel.text = "You are not logged in"
            
            // Reset restrictions
            restrictionsLabel.text = ""
        }
    }
}
