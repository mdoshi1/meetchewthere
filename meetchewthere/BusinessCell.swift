//
//  BusinessCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/9/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import YelpAPI

class BusinessCell: UITableViewCell {
    
    // MARK: - IBOutles
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var restriction1: UILabel!
    @IBOutlet private weak var restriction2: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var distance: UILabel!
    @IBOutlet weak var restImage: UIImageView!
    
    // MARK: - Properties
    
    lazy var choiceLabel1: UILabel = {
        let choiceLabel = RatingLabel(type: .choice, rating: .bad)
        return choiceLabel
    }()
    
    lazy var choiceLabel2: UILabel = {
        let choiceLabel = RatingLabel(type: .choice, rating: .good)
        return choiceLabel
    }()
    
    lazy var safetyLabel1: UILabel = {
        let choiceLabel = RatingLabel(type: .safety, rating: .okay)
        return choiceLabel
    }()
    
    lazy var safetyLabel2: UILabel = {
        let choiceLabel = RatingLabel(type: .safety, rating: .good)
        return choiceLabel
    }()
    
    lazy var favoriteView:UIView = {
        let favoriteView = UIView()
        favoriteView.backgroundColor = .chewGreen
        favoriteView.isHidden = true
        return favoriteView
    }()
    
    var business: YLPBusiness? {
        didSet {
            DispatchQueue.main.async {
                self.name.text = self.business?.name
                self.price.text = "$$"
                if let restImageURL = self.business?.imageURL {
                    Webservice.getImage(withURL: restImageURL, completion: { data in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.restImage.image = UIImage(data: data)
                            }
                        }
                    })
                }
                self.restriction1.text = "Nuts"
                self.restriction2.text = "Dairy"
                self.distance.text = "3.2 miles"
            }
        }
    }
    
    // MARK: - BusinessCell

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        restImage.layer.cornerRadius = 5.0
        restImage.layer.masksToBounds = true
        
        addSubview(choiceLabel1.usingAutolayout())
        addSubview(choiceLabel2.usingAutolayout())
        addSubview(safetyLabel1.usingAutolayout())
        addSubview(safetyLabel2.usingAutolayout())
        addSubview(favoriteView.usingAutolayout())
        setupConstraints()
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
    
    func setupConstraints() {
        
        // Choice labels
        NSLayoutConstraint.activate([
            choiceLabel1.leadingAnchor.constraint(equalTo: restriction1.trailingAnchor, constant: 16.0),
            choiceLabel1.centerYAnchor.constraint(equalTo: restriction1.centerYAnchor)
            ])
        NSLayoutConstraint.activate([
            choiceLabel2.leadingAnchor.constraint(equalTo: restriction2.trailingAnchor, constant: 16.0),
            choiceLabel2.centerYAnchor.constraint(equalTo: restriction2.centerYAnchor)
            ])
        
        // Safety labels
        NSLayoutConstraint.activate([
            safetyLabel1.leadingAnchor.constraint(equalTo: choiceLabel1.trailingAnchor, constant: 16.0),
            safetyLabel1.centerYAnchor.constraint(equalTo: restriction1.centerYAnchor)
            ])
        NSLayoutConstraint.activate([
            safetyLabel2.leadingAnchor.constraint(equalTo: choiceLabel2.trailingAnchor, constant: 16.0),
            safetyLabel2.centerYAnchor.constraint(equalTo: restriction2.centerYAnchor)
            ])
        
        // Favorite view
        NSLayoutConstraint.activate([
            favoriteView.topAnchor.constraint(equalTo: topAnchor),
            favoriteView.rightAnchor.constraint(equalTo: rightAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            favoriteView.widthAnchor.constraint(equalToConstant: 5.0)
            ])
    }

}
