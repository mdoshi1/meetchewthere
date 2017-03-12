//
//  IntrinsicTableView.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 3/11/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit

class IntrinsicTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            layoutIfNeeded()
            return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
        }
    }
    
    override func endUpdates() {
        super.endUpdates()
        invalidateIntrinsicContentSize()
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
    
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        super.reloadRows(at: indexPaths, with: animation)
        invalidateIntrinsicContentSize()
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        super.reloadSections(sections, with: animation)
        invalidateIntrinsicContentSize()
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        super.insertRows(at: indexPaths, with: animation)
        invalidateIntrinsicContentSize()
    }
    
    override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        super.insertSections(sections, with: animation)
        invalidateIntrinsicContentSize()
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        super.deleteRows(at: indexPaths, with: animation)
        invalidateIntrinsicContentSize()
    }
    
    override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        super.deleteSections(sections, with: animation)
        invalidateIntrinsicContentSize()
    }
}
