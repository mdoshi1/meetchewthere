//
//  Favorites.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import CoreData
import YelpAPI

class Favorites: UIViewController {
    
    // MARK: - Properties 
    
    @IBOutlet weak var tableView: UITableView!
    var managedContext: NSManagedObjectContext?
    var businessIds: [String] = []
    
    // MARK: - Favorites
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize NSManagedObjectContext
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        } else {
            managedContext = nil
        }
        
        // Initialize favorites list from Core Data
        initializeFavoritesList()
        
        // Assign UITableView delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set up notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: .NSManagedObjectContextDidSave, object: managedContext)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextDidSave, object: managedContext)
    }
    
    // MARK: - Notification Methods
    
    func updateFavorites(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }

        if let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            insertedObjects.count > 0 {
            
            for object in insertedObjects {
                guard let businessId = object.value(forKey: "businessId") as? String else {
                    continue
                }
                businessIds.append(businessId)
            }
        }
        
        if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletedObjects.count > 0 {
            
            for object in deletedObjects {
                guard let businessId = object.value(forKey: "businessId") as? String else {
                    continue
                }
                remove(businessId)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func initializeFavoritesList() {
        if let managedContext = managedContext {
            var objects: [NSManagedObject]?
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            do {
                objects = try managedContext.fetch(fetchRequest)
                print("Successfully retrieved favorite restaurants from Core Data")
            } catch let error as NSError {
                print("Error while trying to retrieve favorite restaurants from Core Data: \(error.localizedDescription)")
            }
            
            if let businessObjects = objects {
                for businessObject in businessObjects {
                    if let businessId = businessObject.value(forKey: "businessId") as? String{
                        businessIds.append(businessId)
                    }
                }
            }
        }
    }
    
    // TODO: Make this an extension of Sequence
    private func remove(_ businessId: String) {
        businessIds = businessIds.filter() { $0 != businessId }
    }
    
}

// MARK: - UITableViewDelegate
extension Favorites: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - UITableViewDataSource
extension Favorites: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        let businessId = businessIds[indexPath.row]

        AppDelegate.sharedYLPClient.business(withId: businessId) { business, error in
            guard let business = business, error == nil else {
                print("Error retrieivng business with businessId \(businessId)")
                return
            }
            DispatchQueue.main.async {
                cell.name.text = business.name
                cell.price.text = "$$"
            }
            if let restImageURL = business.imageURL {
                Webservice.getImage(withURL: restImageURL, completion: { data in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.restImage.layer.cornerRadius = 5.0
                            cell.restImage.layer.masksToBounds = true
                            cell.restImage.image = UIImage(data: data)
                        }
                    }
                })
            }
        }
        
        cell.restriction1.text = "Vegan"
        cell.restrictionRating1.image = UIImage(named: "stars_green.png")
        cell.restrictionRating2.image = UIImage(named: "stars_green.png")
        cell.restriction2.text = "Dairy"
        cell.distance.text = "3.2 miles"
        
        return cell
    }
}
