//
//  LoginViewController.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/27/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "meetchewthere"
        titleLabel.font = UIFont.systemFont(ofSize: 36.0)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private lazy var sheetTableView: SheetTableView = {
        let sheetTableView = SheetTableView(type: .signup)
        sheetTableView.isScrollEnabled = false
        sheetTableView.delegate = self
        sheetTableView.dataSource = self
        return sheetTableView
    }()
    
    fileprivate let inputSheetCellIdentifier = "InputSheetCell"
    
    // MARK: - LoginViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel.usingAutolayout())
        view.addSubview(sheetTableView.usingAutolayout())
        setupConstraints()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Helper Methods
    
    private func setupConstraints() {
        
        // Title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        // Sheet tableview
        NSLayoutConstraint.activate([
            sheetTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0),
            sheetTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            sheetTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            sheetTableView.heightAnchor.constraint(equalToConstant: 50.0 * CGFloat(sheetTableView.type.rowStrings.count) + 75.0)
            ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate

extension LoginViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

// MARK: - UITableViewDataSource
extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sheetTableView = tableView as? SheetTableView else {
            return 0
        }
        return sheetTableView.type.rowStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sheetTableView = tableView as? SheetTableView else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: inputSheetCellIdentifier) as! InputSheetCell
        cell.inputField.placeholder = sheetTableView.type.rowStrings[indexPath.row]
        
        return cell
    }
    
}
