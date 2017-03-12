//
//  BusinessCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit
import YelpAPI

class BusinessCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var restrictionLabel: UILabel!
    @IBOutlet weak var choiceButton: UIButton!
    @IBOutlet weak var safetyButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
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
                if self.business != nil {
                    self.businessName.text = self.business!.name
                    let address = self.business!.location.address
                    self.addressLabel.text = (address.count > 0) ? address.joined(separator: " ") : "Address N/A"
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
        choiceButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        choiceButton.layer.cornerRadius = 5.0
        choiceButton.layer.masksToBounds = true
        
        safetyButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        safetyButton.layer.cornerRadius = 5.0
        safetyButton.layer.masksToBounds = true
    }
    
}
