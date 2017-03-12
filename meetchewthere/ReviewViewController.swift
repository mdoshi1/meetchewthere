//
//  ReviewViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/7/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import FacebookCore

class ReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var reviewTable: UITableView = {
        let reviewTable = UITableView()
        reviewTable.delegate = self
        reviewTable.dataSource = self
        reviewTable.bounces = false
        reviewTable.allowsSelection = false
        reviewTable.rowHeight = UITableViewAutomaticDimension
        reviewTable.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        reviewTable.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        reviewTable.register(UINib(nibName: "ReviewTextCell", bundle: nil), forCellReuseIdentifier: "ReviewTextCell")
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64.0))
        let submitButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64.0))
        submitButton.backgroundColor = .chewGreen
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setTitle("Submit Review", for: .normal)
        submitButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
        footerView.addSubview(submitButton)
        reviewTable.tableFooterView = footerView
        
        return reviewTable
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancel))
        cancelButton.tintColor = .white
        return cancelButton
    }()
    
    var restrictions: [String] = []
    var businessId = ""
    
    fileprivate var reviews: [String:[Int]] = [:]
    fileprivate var reviewText = ""
    private let defaultChoiceRating = 0
    private let defaultSafetyRating = 0
    private var isValidReview: Bool {
        if reviewText != "" {
            return true
        }
        for (_, ratings) in reviews {
            for rating in ratings {
                if rating != 0 {
                    return true
                }
            }
        }
        
        return false
    }
    
    fileprivate var dispatchGroup = DispatchGroup()
    
    // MARK: - ReviewViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap outside to close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        navigationItem.rightBarButtonItem = cancelButton
        view.addSubview(reviewTable.usingAutolayout())
        setupConstraints()
        
        // Setup reviews dictionary
        for restriction in restrictions {
            reviews[restriction] = [defaultChoiceRating, defaultSafetyRating]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Notification Methods
    
    func keyboardWillShow() {
        if view.frame.origin.y >= 0 {
            setViewMovedUp(true)
        } else {
            setViewMovedUp(false)
        }
    }
    
    func keyboardWillHide() {
        if view.frame.origin.y >= 0 {
            setViewMovedUp(true)
        } else {
            setViewMovedUp(false)
        }
    }
    
    fileprivate func setViewMovedUp(_ movedUp: Bool) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        
        var rect = view.frame
        if movedUp {
            rect.origin.y -= Constants.UI.KeyboardOffset
            rect.size.height += Constants.UI.KeyboardOffset
        } else {
            rect.origin.y += Constants.UI.KeyboardOffset
            rect.size.height -= Constants.UI.KeyboardOffset
        }
        view.frame = rect
        UIView.commitAnimations()
    }
    
    // MARK: - Helper Methods
    
    func setupConstraints() {
        
        // Review Table
        NSLayoutConstraint.activate([
            reviewTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            reviewTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reviewTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    // MARK: UIButton Actions
    
    func submitReview() {
        if !isValidReview {
            let alertController = UIAlertController(title: "You did not rate this restaurant", message: "Rate this restaurant's accomdation for your restriction(s) before submitting", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if let userId = UserProfile.current?.userId {
            
            Webservice.deleteReview(forUserId: userId, businessId: businessId) { success in
                guard success else {
                    print("Failed to delete user review")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                print("Successfully deleted user review")
                
                for (restriction, ratings) in self.reviews {
                    self.dispatchGroup.enter()
                    Webservice.postReview(forUserId: userId, businessId: self.businessId, restriction: restriction, reviewText: self.reviewText, choiceRating: ratings[0], safetyRating: ratings[1], completion: { success in
                        if success {
                            print("Successfully posted user review for restriction: \(restriction)")
                        } else {
                            print("Failed to post user review for restriction: \(restriction)")
                        }
                        self.dispatchGroup.leave()
                    })
                }
                
                self.dispatchGroup.notify(queue: .main) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            print("No user currently logged in")
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UITableview Methods

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 127.5
        case restrictions.count:
            return 200
        default:
            return 187
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restrictions.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
            if let username = UserProfile.current?.fullName {
                cell.username.text = username
            }
            return cell
        case restrictions.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTextCell") as! ReviewTextCell
            cell.reviewText.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            cell.restrictionLabel.text = restrictions[indexPath.row - 1]
            cell.delegate = self
            return cell
        }
    }
    
}

// MARK: - UITextView Delegate
extension ReviewViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        reviewText = text
        if text == "" {
            textView.text = "Write something..."
            textView.textColor = .chewGray
        }
    }
}

// MARK: - ReviewCellDelegate
extension ReviewViewController: ReviewCellDelegate {
    func updateChoiceRating(forRestriction restriction: String, choice: Int) {
        reviews[restriction]![0] = choice
    }
    
    func updateSafetyRating(forRestriction restriction: String, safety: Int) {
        reviews[restriction]![1] = safety
    }
}
