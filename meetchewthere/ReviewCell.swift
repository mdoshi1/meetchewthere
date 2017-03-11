//
//  ReviewCell.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/7/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    // Choice buttons
    @IBOutlet weak var goodChoiceButton: UIButton!
    @IBOutlet weak var okChoiceButton: UIButton!
    @IBOutlet weak var badChoiceButton: UIButton!
    
    // Safety buttons
    @IBOutlet weak var goodSafetyButton: UIButton!
    @IBOutlet weak var okSafetyButton: UIButton!
    @IBOutlet weak var badSafetyButton: UIButton!
    
    @IBOutlet weak var restrictionLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: ReviewCellDelegate?
    
    // MARK: - ReviewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func setupButtons() {
        goodChoiceButton.tag = 1
        goodChoiceButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        goodChoiceButton.layer.cornerRadius = 5.0
        goodChoiceButton.layer.masksToBounds = true
        goodChoiceButton.setBackgroundImage(UIImage.withColor(.chewGray), for: .normal)
        goodChoiceButton.setBackgroundImage(UIImage.withColor(.chewGreen), for: .selected)
        goodChoiceButton.setTitleColor(.black, for: .selected)
        
        okChoiceButton.tag = 2
        okChoiceButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        okChoiceButton.layer.cornerRadius = 5.0
        okChoiceButton.layer.masksToBounds = true
        okChoiceButton.setBackgroundImage(UIImage.withColor(.chewGray), for: .normal)
        okChoiceButton.setBackgroundImage(UIImage.withColor(.chewYellow), for: .selected)
        okChoiceButton.setTitleColor(.black, for: .selected)
        
        badChoiceButton.tag = 3
        badChoiceButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        badChoiceButton.layer.cornerRadius = 5.0
        badChoiceButton.layer.masksToBounds = true
        badChoiceButton.setBackgroundImage(UIImage.withColor(.chewGray), for: .normal)
        badChoiceButton.setBackgroundImage(UIImage.withColor(.chewRed), for: .selected)
        badChoiceButton.setTitleColor(.black, for: .selected)
        
        goodSafetyButton.tag = 4
        goodSafetyButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        goodSafetyButton.layer.cornerRadius = 5.0
        goodSafetyButton.layer.masksToBounds = true
        goodSafetyButton.setBackgroundImage(UIImage.withColor(.chewGray), for: .normal)
        goodSafetyButton.setBackgroundImage(UIImage.withColor(.chewGreen), for: .selected)
        goodSafetyButton.setTitleColor(.black, for: .selected)
        
        okSafetyButton.tag = 5
        okSafetyButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        okSafetyButton.layer.cornerRadius = 5.0
        okSafetyButton.layer.masksToBounds = true
        okSafetyButton.setBackgroundImage(UIImage.withColor(.chewGray), for: .normal)
        okSafetyButton.setBackgroundImage(UIImage.withColor(.chewYellow), for: .selected)
        okSafetyButton.setTitleColor(.black, for: .selected)
        
        badSafetyButton.tag = 6
        badSafetyButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        badSafetyButton.layer.cornerRadius = 5.0
        badSafetyButton.layer.masksToBounds = true
        badSafetyButton.setBackgroundImage(UIImage.withColor(.chewGray), for: .normal)
        badSafetyButton.setBackgroundImage(UIImage.withColor(.chewRed), for: .selected)
        badSafetyButton.setTitleColor(.black, for: .selected)
    }
    
    // MARK: - Button Actions
    
    @IBAction func selectRating(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        switch sender.tag {
        case 1:
            (viewWithTag(2) as! UIButton).isSelected = false
            (viewWithTag(3) as! UIButton).isSelected = false
            if sender.isSelected {
                delegate?.updateChoiceRating(choice: "2")
            } else {
                delegate?.updateChoiceRating(choice: "-1")
            }
        case 2:
            (viewWithTag(1) as! UIButton).isSelected = false
            (viewWithTag(3) as! UIButton).isSelected = false
            if sender.isSelected {
                delegate?.updateChoiceRating(choice: "1")
            } else {
                delegate?.updateChoiceRating(choice: "-1")
            }
        case 3:
            (viewWithTag(1) as! UIButton).isSelected = false
            (viewWithTag(2) as! UIButton).isSelected = false
            if sender.isSelected {
                delegate?.updateChoiceRating(choice: "0")
            } else {
                delegate?.updateChoiceRating(choice: "-1")
            }
        case 4:
            (viewWithTag(5) as! UIButton).isSelected = false
            (viewWithTag(6) as! UIButton).isSelected = false
            if sender.isSelected {
                delegate?.updateSafetyRating(safety: "2")
            } else {
                delegate?.updateSafetyRating(safety: "-1")
            }
        case 5:
            (viewWithTag(4) as! UIButton).isSelected = false
            (viewWithTag(6) as! UIButton).isSelected = false
            if sender.isSelected {
                delegate?.updateSafetyRating(safety: "1")
            } else {
                delegate?.updateSafetyRating(safety: "-1")
            }
        case 6:
            (viewWithTag(4) as! UIButton).isSelected = false
            (viewWithTag(5) as! UIButton).isSelected = false
            if sender.isSelected {
                delegate?.updateSafetyRating(safety: "0")
            } else {
                delegate?.updateSafetyRating(safety: "-1")
            }
        default:
            break
        }
        
        
    }
}

protocol ReviewCellDelegate: class {
    func updateChoiceRating(choice: String)
    func updateSafetyRating(safety: String)
}
