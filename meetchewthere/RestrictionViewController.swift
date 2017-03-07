//
//  RestrictionViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/6/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class RestrictionViewController: UIViewController {
    
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
    
    // MARK: - Properties
    
    private lazy var restrictionsTable: UITableView = {
        let restrictionsTable = UITableView()
        restrictionsTable.delegate = self
        restrictionsTable.dataSource = self
        restrictionsTable.allowsMultipleSelection = true
        return restrictionsTable
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        return doneButton
    }()
    
    // MARK: - RestrictionViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(restrictionsTable.usingAutolayout())
        setupConstraints()
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            restrictionsTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            restrictionsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            restrictionsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            restrictionsTable.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }
}

// MARK: - UITableView Methods

extension RestrictionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Restriction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = Restriction(rawValue: indexPath.row)!.description
        cell.tintColor = .chewGreen
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(Restriction.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            //tableView.deselectRow(at: indexPath, animated: true)
            cell.accessoryType = .checkmark
        }
        print("selected rows \(tableView.indexPathsForSelectedRows)")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        print("selected rows \(tableView.indexPathsForSelectedRows)")
    }
}
