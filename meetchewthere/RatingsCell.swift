//
//  RatingsCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class RatingsCell: UITableViewCell {

    // MARK: - Properties
    
    lazy var restriction: UILabel = {
        let restriction = UILabel()
        return restriction
    }()
    
    private lazy var choiceLabel: RatingLabel = {
        let choiceLabel = RatingLabel(type: .choice)
        return choiceLabel
    }()
    
    private lazy var safetyLabel: RatingLabel = {
        let safetyLabel = RatingLabel(type: .safety)
        return safetyLabel
    }()
    
    // MARK: - RatingsCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(restriction.usingAutolayout())
        addSubview(choiceLabel.usingAutolayout())
        addSubview(safetyLabel.usingAutolayout())
        setupConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Helper methods
    
    private func setupConstraints() {
        
        // Restriction label
        NSLayoutConstraint.activate([
            restriction.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            restriction.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // Choice label
        NSLayoutConstraint.activate([
            choiceLabel.topAnchor.constraint(equalTo: restriction.bottomAnchor, constant: 8.0),
            choiceLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -8.0)
            ])
        
        // Safety label
        NSLayoutConstraint.activate([
            safetyLabel.topAnchor.constraint(equalTo: restriction.bottomAnchor, constant: 8.0),
            safetyLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 8.0)
            ])
        
    }
    
}
