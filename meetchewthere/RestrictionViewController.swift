//
//  RestrictionViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/6/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit
import FacebookCore

// MARK: - Enum

enum Restriction: Int {
    case dairy = 0
    case egg
    case fish
    case gluten
    case peaunt
    case shellfish
    case soy
    case treenut
    case vegetarian
    case wheat
    case vegan
    
    static var count: Int { return Restriction.vegan.rawValue + 1 }
    
    var description: String {
        switch self {
        case .dairy:
            return "Dairy Free"
        case .egg:
            return "Egg Free"
        case .fish:
            return "Fish Free"
        case .gluten:
            return "Gluten Free"
        case .peaunt:
            return "Peanut Free"
        case .shellfish:
            return "Shellfish Free"
        case .soy:
            return "Soy Free"
        case .treenut:
            return "Tree Nut Free"
        case .vegetarian:
            return "Vegetarian"
        case .wheat:
            return "Wheat Free"
        case .vegan:
            return "Vegan"
        }
    }
}

class RestrictionViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var restrictionsTable: UITableView = {
        let restrictionsTable = UITableView()
        restrictionsTable.delegate = self
        restrictionsTable.dataSource = self
        restrictionsTable.allowsMultipleSelection = true
        restrictionsTable.isScrollEnabled = false
        return restrictionsTable
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = MCTButton(type: .primary)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(unwindToProfile), for: .touchUpInside)
        return doneButton
    }()
    
    // MARK: - RestrictionViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Change back button to white
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true
        view.addSubview(restrictionsTable.usingAutolayout())
        view.addSubview(doneButton.usingAutolayout())
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        
        // Restrictions Table
        NSLayoutConstraint.activate([
            restrictionsTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            restrictionsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            restrictionsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            restrictionsTable.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16.0)
            ])
        
        // Done Button
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -16.0)
            ])
    }
    
    // MARK: - UIButton Actions
    
    func unwindToProfile() {
        if let indexPathsForSelectedRows = restrictionsTable.indexPathsForSelectedRows,
            let userProfile = UserProfile.current {
            var restrictions: [String] = []
            for index in 0..<indexPathsForSelectedRows.count {
                let restriction = Restriction(rawValue: indexPathsForSelectedRows[index].row)!.description
                restrictions.append(restriction)
                
                Webservice.deleteRestrictions(forUserId: userProfile.userId, completion: { success in
                    if success {
                        SessionManager.shared.restrictions.removeAll()
                        print("Successfully deleted all restrictions")
                        Webservice.postRestrictions(forUserId: userProfile.userId, restriction: restriction) { success in
                            if success {
                                print("Successfully added restriction: \(restriction)")
                            } else {
                                print("Failed to add restriction: \(restriction)")
                            }
                            DispatchQueue.main.async {
                                if index == indexPathsForSelectedRows.count - 1 {
                                    SessionManager.shared.restrictions = restrictions
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    } else {
                        print("Failed to delete restrictions")
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        } else {
            SessionManager.shared.restrictions.removeAll()
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableView Methods

extension RestrictionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Restriction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = Restriction(rawValue: indexPath.row)!.description
        cell.tintColor = .chewGreen
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(Restriction.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.textColor = .chewGreen
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }
    }
}
