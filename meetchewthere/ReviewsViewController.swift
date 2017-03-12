//
//  ReviewsViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit
import MessageUI

class ReviewsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var reviewsTable: UITableView = {
        let reviewsTable = UITableView()
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        reviewsTable.allowsSelection = false
        reviewsTable.rowHeight = UITableViewAutomaticDimension
        reviewsTable.register(UINib(nibName: "UserReviewCell", bundle: nil), forCellReuseIdentifier: "UserReviewCell")
        return reviewsTable
    }()
    
    private lazy var noReviewsLabel: UILabel = {
        let noReviewsLabel = UILabel()
        noReviewsLabel.font = UIFont.systemFont(ofSize: 24.0)
        noReviewsLabel.textColor = .chewDarkGray
        noReviewsLabel.numberOfLines = 0
        noReviewsLabel.textAlignment = .center
        noReviewsLabel.text = "No reviews for \(self.restriction) restriction"
        return noReviewsLabel
    }()
    
    var restriction: String = ""
    var reviews: [Review] = []
    
    //MARK: - ReviewsViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(reviewsTable.usingAutolayout())
        view.addSubview(noReviewsLabel.usingAutolayout())
        if reviews.count > 0 {
            noReviewsLabel.isHidden = true
        } else {
            reviewsTable.isHidden = true
        }
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        
        // Reviews Table
        NSLayoutConstraint.activate([
            reviewsTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            reviewsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reviewsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
        
        // No Review Label
        NSLayoutConstraint.activate([
            noReviewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noReviewsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noReviewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            noReviewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16.0)
            ])
    }
    
    fileprivate func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["doshi.michael@gmail.com"])
        mailComposerVC.setSubject("Flag Comment in meetchewthere")
        mailComposerVC.setMessageBody("I would like to flag a comment in your app 'meetchewthere'", isHTML: false)
        
        return mailComposerVC
    }
    
    /*fileprivate func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }*/
}

// MARK: - UITableView Methods
extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewCell") as! UserReviewCell
        cell.delegate = self
        let review = reviews[indexPath.row]
        cell.reviewTextLabel.text = review.reviewText
        
        var choiceButtonColor = UIColor()
        var choiceButtonText = ""
        switch review.choice {
        case "1":
            choiceButtonColor = .chewRed
            choiceButtonText = "Bad Choice"
        case "2":
            choiceButtonColor = .chewYellow
            choiceButtonText = "OK Choice"
        case "3":
            choiceButtonColor = .chewGreen
            choiceButtonText = "Good Choice"
        default:
            choiceButtonColor = .chewGray
            choiceButtonText = "Choice"
        }
        cell.choiceButton.backgroundColor = choiceButtonColor
        cell.choiceButton.setTitle(choiceButtonText, for: .normal)
        
        var safetyButtonColor = UIColor()
        var safetyButtonText = ""
        switch review.safety {
        case "1":
            safetyButtonColor = .chewRed
            safetyButtonText = "Bad Safety"
        case "2":
            safetyButtonColor = .chewYellow
            safetyButtonText = "OK Safety"
        case "3":
            safetyButtonColor = .chewGreen
            safetyButtonText = "Good Safety"
        default:
            safetyButtonColor = .chewGray
            safetyButtonText = "Safety"
        }
        cell.safetyButton.backgroundColor = safetyButtonColor
        cell.safetyButton.setTitle(safetyButtonText, for: .normal)
        
        return cell
    }
}

extension ReviewsViewController: UserReviewCellDelegate {
    func flagComment() {
        let alertController = UIAlertController(title: "Flag Comment", message: "Are you sure you want to flag this comment?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let flagAction = UIAlertAction(title: "Flag", style: .destructive) { _ in
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } /*else {
                self.showSendMailErrorAlert()
            }*/
        }
        alertController.addAction(flagAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ReviewsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
