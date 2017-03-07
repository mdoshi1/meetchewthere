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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24.0)
        if let username = UserProfile.current?.fullName {
            nameLabel.text = username
        }
        return nameLabel
    }()
    
    private lazy var restrictionTable: UITableView = {
        let restrictionTable = UITableView()
        restrictionTable.delegate = self
        restrictionTable.dataSource = self
        restrictionTable.isScrollEnabled = false
        restrictionTable.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        return restrictionTable
    }()
    
    private lazy var reviewText: UITextView = {
        let reviewText = UITextView()
        reviewText.isEditable = true
        reviewText.delegate = self
        reviewText.font = UIFont.systemFont(ofSize: 18.0)
        reviewText.text = "Write something..."
        reviewText.textColor = .chewGray
        return reviewText
    }()
    
    private lazy var reviewButton: UIButton = {
        let reviewButton = UIButton()
        reviewButton.backgroundColor = .chewGreen
        reviewButton.setTitleColor(.white, for: .normal)
        reviewButton.setTitle("Submit Review", for: .normal)
        reviewButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
        return reviewButton
    }()
    
    var restrictions = ["Nut", "Dairy"]
    var restaurantName = ""
    
    // MARK: - ReviewViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbar.topItem?.title = restaurantName
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.addSubview(nameLabel.usingAutolayout())
        view.addSubview(restrictionTable.usingAutolayout())
        view.addSubview(reviewText.usingAutolayout())
        view.addSubview(reviewButton.usingAutolayout())
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    func setupConstraints() {
        
        // Name Label
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 52.0),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        // Restrictions Table
        NSLayoutConstraint.activate([
            restrictionTable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            restrictionTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            restrictionTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            restrictionTable.bottomAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        // Review Text
        NSLayoutConstraint.activate([
            reviewText.topAnchor.constraint(equalTo: view.centerYAnchor),
            reviewText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reviewText.bottomAnchor.constraint(equalTo: reviewButton.topAnchor)
            ])
        
        // Review Button
        NSLayoutConstraint.activate([
            reviewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reviewButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            reviewButton.heightAnchor.constraint(equalToConstant: 50.0)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restrictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        cell.restrictionLabel.text = restrictions[indexPath.row]
        return cell
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
