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
    
    // MARK: - ReviewViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap outside to close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        navigationItem.rightBarButtonItem = cancelButton
        view.addSubview(reviewTable.usingAutolayout())
        setupConstraints()
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
        dismiss(animated: true, completion: nil)
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
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            cell.restrictionLabel.text = restrictions[indexPath.row - 1]
            return cell
        }
    }
    
}

// MARK: - UITextView Delegate
extension ReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = "Write something..."
            textView.textColor = .chewGray
        }
    }
}
