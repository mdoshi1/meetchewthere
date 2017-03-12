//
//  BusinessCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import YelpAPI

class BusinessCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var restrictionOneLabel: UILabel!
    @IBOutlet weak var choiceOneButton: UIButton!
    @IBOutlet weak var safetyOneButton: UIButton!
    @IBOutlet weak var restrictionTwoLabel: UILabel!
    @IBOutlet weak var choiceTwoButton: UIButton!
    @IBOutlet weak var safetyTwoButton: UIButton!
    @IBOutlet weak var businessImage: UIImageView!
    
    // MARK: - Properties
    
    lazy var favoriteView:UIView = {
        let favoriteView = UIView()
        favoriteView.backgroundColor = .chewGreen
        favoriteView.isHidden = true
        return favoriteView
    }()
    
    var business: YLPBusiness? {
        didSet {
            DispatchQueue.main.async {
                self.businessName.text = self.business?.name
                if let businessImageURL = self.business?.imageURL {
                    Webservice.getImage(withURL: businessImageURL, completion: { data in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.businessImage.image = UIImage(data: data)
                            }
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - BusinessCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addSubview(favoriteView.usingAutolayout())
        setupConstraints()
        setupImageView()
        setupButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteView.isHidden = true
    }
    
    // MARK: - Helper methods
    
    private func setupConstraints() {
        
        // Favorite view
        NSLayoutConstraint.activate([
            favoriteView.topAnchor.constraint(equalTo: topAnchor),
            favoriteView.rightAnchor.constraint(equalTo: rightAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            favoriteView.widthAnchor.constraint(equalToConstant: 5.0)
            ])
    }
    
    private func setupImageView() {
        businessImage.layer.cornerRadius = 5.0
        businessImage.layer.masksToBounds = true
    }
    
    private func setupButtons() {
        choiceOneButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        choiceOneButton.layer.cornerRadius = 5.0
        choiceOneButton.layer.masksToBounds = true
        
        safetyOneButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        safetyOneButton.layer.cornerRadius = 5.0
        safetyOneButton.layer.masksToBounds = true
        
        choiceTwoButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        choiceTwoButton.layer.cornerRadius = 5.0
        choiceTwoButton.layer.masksToBounds = true
        
        safetyTwoButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        safetyTwoButton.layer.cornerRadius = 5.0
        safetyTwoButton.layer.masksToBounds = true
    }
    
}
