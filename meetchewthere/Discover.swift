//
//  Discover.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import CoreData
import YelpAPI

class Discover: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties
    
    fileprivate let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    // MARK: - DiscoverViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(initialSearch), name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
        
        // Assign delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
    }
    
    func initialSearch() {
        
        AppDelegate.sharedYLPClient.search(withLocation: "Stanford, CA", term: "food", limit: 20, offset: 0, sort: .bestMatched, completionHandler: { search, error in
            guard let search = search, error == nil else {
                print("Error getting initial search results: \(error?.localizedDescription)")
                return
            }
            print("Succesfully retrieved initial search results")
            DispatchQueue.main.async {
                BusinessManager.shared.businesses = search.businesses
                self.tableView.reloadData()
            }
        })
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    @IBAction func prepareForUnwind(sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailController = segue.destination as! Details
        let businessCell = sender as! BusinessCell
        detailController.business = businessCell.business
        detailController.restImage = businessCell.restImage.image
    }
    
    fileprivate func saveRestaurant(withBusinessId businessId: String) {
        
        // Initialize NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to get app delegate")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Save new businessId in Core Data
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        favorite.setValue(businessId, forKeyPath: "businessId")
        do {
            
            // TODO: save only on application enter background
            try managedContext.save()
            print("Successfully saved restaurant with business id \(businessId) to Core Data")
        } catch let error as NSError {
            print("Error while trying to save restaurant with business id \(businessId) to Core Data: \(error.localizedDescription)")
        }
        
    }
    
    fileprivate func deleteRestaurant(withBusinessId businessId: String) {
        
        // Initialize NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to get app delegate")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var objects: [NSManagedObject]?
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "businessId == %@", businessId)
        do {
            objects = try managedContext.fetch(fetchRequest)
            print("Successfully retrieved favorite restaurants from Core Data")
        } catch let error as NSError {
            print("Error while trying to retrieve favorite restaurants from Core Data: \(error.localizedDescription)")
        }
        
        guard objects != nil, objects!.count == 1 else {
            print("Retrieved too many objects when trying to delete favorite restaurant with business id \(businessId)")
            return
        }
        
        managedContext.delete(objects![0])
        
        do {
            
            // TODO: save only on application enter background
            try managedContext.save()
            print("Successfully deleted restaurant with business id \(businessId) from Core Data")
        } catch let error as NSError {
            print("Error while trying to delete restaurant with business id \(businessId) from Core Data: \(error.localizedDescription)")
        }
    }

}

// MARK: - UITableViewDelegate
extension Discover: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let businesses = BusinessManager.shared.businesses else {
            print("No current businesses available")
            return nil
        }
        let businessId = businesses[indexPath.row].identifier
        
        // Initialize NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to get app delegate")
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Check if businessId has already been stored in Core Data
        var count = 0
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "businessId == %@", businessId)
        do {
            count = try managedContext.count(for: fetchRequest)
        } catch let error as NSError {
            print("Error while trying to check if object with businessId \(businessId) already exists in Core Data: \(error.localizedDescription)")
        }
        
        let action: UITableViewRowAction
        if count == 0 {
            action = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
                
                self.saveRestaurant(withBusinessId: businessId)
                if let cell = tableView.cellForRow(at: indexPath) as? BusinessCell {
                    cell.favoriteView.isHidden = false
                }
                action.backgroundColor = .chewGreen
                
                self.tableView.setEditing(false, animated: true)
            }
        } else {
            action = UITableViewRowAction(style: .normal, title: "Unfavorite") { action, index in
                
                self.deleteRestaurant(withBusinessId: businessId)
                if let cell = tableView.cellForRow(at: indexPath) as? BusinessCell {
                    cell.favoriteView.isHidden = true
                }
                action.backgroundColor = .lightGray
                
                self.tableView.setEditing(false, animated: true)
            }
        }
        action.backgroundColor = .chewGreen
        
        return [action]
    }
}

// MARK: - UITableViewDataSource
extension Discover: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusinessManager.shared.businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        guard let businesses = BusinessManager.shared.businesses else {
            print("Businesses array is nil")
            return cell
        }
        let business = businesses[indexPath.row]
        cell.business = business
        
        // Initialize NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to get app delegate")
            return cell
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Check if businessId has already been stored in Core Data
        let businessId = business.identifier
        var count = 0
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "businessId == %@", businessId)
        do {
            count = try managedContext.count(for: fetchRequest)
        } catch let error as NSError {
            print("Error while trying to check if object with businessId \(businessId) already exists in Core Data: \(error.localizedDescription)")
        }
        
        cell.favoriteView.isHidden = (count == 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


// MARK: - UISearchBarDelegate
extension Discover: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        view.removeGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchTerm = searchBar.text {
            AppDelegate.sharedYLPClient.search(withLocation: "Stanford, CA", term: searchTerm, limit: 20, offset: 0, sort: .bestMatched, completionHandler: { search, error in
                guard let search = search, error == nil else {
                    print("Error retrieving search results for term \(searchTerm): \(error?.localizedDescription)")
                    return
                }
                print("Successfully retrieved results for term \(searchTerm)")
                DispatchQueue.main.async {
                    BusinessManager.shared.businesses = search.businesses
                    self.tableView.reloadData()
                }
            })
        }
        
        view.removeGestureRecognizer(tap)
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        view.removeGestureRecognizer(tap)
    }
}
