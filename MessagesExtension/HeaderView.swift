//
//  HeaderView.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: - Properties
    
    private lazy var titleLabel: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 7.5, left: 10.0, bottom: 7.5, right: 10.0)
        button.setTitle("Select Restaurants", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // MARK: - HeaderView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel.usingAutolayout())
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.layer.cornerRadius = titleLabel.frame.height / 2.0
    }
    
    // MARK: - Helper Methods
    
    private func setUpConstraints() {
        
        // titleLabel constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
    }
    
    func activateShare() {
        titleLabel.setTitle("Share Restaurants", for: .normal)
        titleLabel.drawBorder(withWidth: 1.0)
    }
    
    func deactivateShare() {
        titleLabel.setTitle("Select Restaurants", for: .normal)
        titleLabel.hideBorder()
    }

}
