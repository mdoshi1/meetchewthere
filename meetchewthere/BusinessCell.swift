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
    
    // MARK: - Properties
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var restriction1: UILabel!
    @IBOutlet private weak var restriction2: UILabel!
    @IBOutlet private weak var restrictionRating1: UIImageView!
    @IBOutlet private weak var restrictionRating2: UIImageView!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var distance: UILabel!
    @IBOutlet weak var restImage: UIImageView!
    
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
                self.restriction1.text = "Vegan"
                self.restrictionRating1.image = UIImage(named: "stars_green.png")
                self.restrictionRating2.image = UIImage(named: "stars_green.png")
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
        NSLayoutConstraint.activate([
            favoriteView.topAnchor.constraint(equalTo: topAnchor),
            favoriteView.rightAnchor.constraint(equalTo: rightAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            favoriteView.widthAnchor.constraint(equalToConstant: 5.0)
            ])
    }

}
