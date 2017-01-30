//
//  FavoritesViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.backgroundColor = .chewBlue
        return headerView
    }()
    
    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    // MARK: - FavoritesViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView.usingAutolayout())
        view.addSubview(favoritesTableView.usingAutolayout())
        setUpConstraints()
        registerReusableCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let data = Data()
    fileprivate var chosenRestaurants: [Int] = [] {
        didSet {
            if chosenRestaurants.count > 0 {
                headerView.activateShare()
            } else {
                headerView.deactivateShare()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setUpConstraints() {
        
        // headerView constraints
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        // favoritesTableView constraints
        NSLayoutConstraint.activate([
            favoritesTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func registerReusableCells() {
        favoritesTableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let cell = tableView.cellForRow(at: indexPath) as? RestaurantCell {
            if cell.accessoryType == UITableViewCellAccessoryType.none {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                cell.setChecked(isSelected: true)
                chosenRestaurants.append(indexPath.row)
            } else if cell.accessoryType == UITableViewCellAccessoryType.checkmark {
                cell.accessoryType = UITableViewCellAccessoryType.none
                cell.setChecked(isSelected: false)
                chosenRestaurants.remove(object: indexPath.row)
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let entry = data.places[indexPath.row]
        cell.backgroundView = UIImageView(image: UIImage(named: entry.restImage))
        cell.titleLabel.text = entry.title
        cell.ratingImage.image = UIImage(named: entry.ratings)
        cell.distanceLabel.text = entry.distance
        cell.restrictionsLabel.text = entry.restrictions
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
}
