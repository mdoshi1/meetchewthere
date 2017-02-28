//
//  SheetTableView.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 2/27/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

enum SheetType {
    case signup
    case login
    case selection
    
    var rowStrings: [String] {
        switch self {
        case .signup:
            return ["First Name", "Last Name", "Email", "Password", "Confirm Password"]
        case .login:
            return ["Email", "Password"]
        case .selection:
            return ["Dairy-free", "Vegetarian", "Vegan", "Gluten-free", "Nut-free"]
        }
    }
    
    var footerView: UIView {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 75.0))
        button.setTitleColor(.chewGreen, for: .normal)
        switch self {
        case .signup:
            fallthrough
        case .login:
            button.setTitle("Submit", for: .normal)
        case .selection:
            button.setTitle("Done", for: .normal)
        }
        
        let topBorder = UIView()
        topBorder.backgroundColor = .chewGray
        button.addSubview(topBorder.usingAutolayout())
        NSLayoutConstraint.activate([
            topBorder.heightAnchor.constraint(equalToConstant: 1.0),
            topBorder.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: button.trailingAnchor)
            ])
        return button
    }
}

class SheetTableView: UITableView {
    
    // MARK: - Properties
    let type: SheetType
    
    // MARK: - SheetTableView
    
    init(frame: CGRect = CGRect.zero, style: UITableViewStyle = .plain, type: SheetType) {
        self.type = type
        super.init(frame: frame, style: style)
        self.separatorColor = .chewGray
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.register(UINib(nibName: "InputSheetCell", bundle: nil), forCellReuseIdentifier: "InputSheetCell")
        self.tableFooterView = type.footerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
