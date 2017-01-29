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
        return tableView
    }()
    
    // MARK: - FavoritesViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView.usingAutolayout())
        view.addSubview(favoritesTableView.usingAutolayout())
        setUpConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    fileprivate func setUpConstraints() {
        
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
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }*/
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
