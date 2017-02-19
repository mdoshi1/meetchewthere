//
//  Details.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import CoreData
import YelpAPI

class Details: UIViewController, UITableViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurant: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var business: YLPBusiness?
    var restImage: UIImage?
    var managedContext: NSManagedObjectContext?
    
    // TODO: Remove in favor of real data
    fileprivate let restrictions = ["Vegan", "Dairy"]
    
    // MARK: Details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize NSManagedObjectContext
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        } else {
            managedContext = nil
        }
        
        // Assign UITableView delegates
        tableView.dataSource = self
        tableView.delegate = self 
        tableView.separatorColor = .clear
        
        // Setup restaurant page
        if let business = business {
            titleName.text = business.name
            print(business.name)
            distance.text = "3.2 miles"
            price.text = "$$"
            hours.text = "10am - 11pm"
            
            if let restImage = restImage {
                restaurant.image = restImage
            } else if let imageURL = business.imageURL {
                Webservice.getImage(withURL: imageURL, completion: { data in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.restaurant.image = UIImage(data: data)
                        }
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        guard let business = business else {
            print("Business is nil")
            return
        }
        let businessId = business.identifier
        
        // Check if businessId has already been stored in Core Data
        if let managedContext = managedContext {
        
            var count = 0
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            fetchRequest.predicate = NSPredicate(format: "businessId == %@", businessId)
            do {
                count = try managedContext.count(for: fetchRequest)
            } catch let error as NSError {
                print("Error while trying to check if object with businessId \(businessId) already exists in Core Data: \(error.localizedDescription)")
            }
        
            if count == 0 {
                favoriteButton.setImage(UIImage(named: "heart_empty"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "heart_full"), for: .normal)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: IBActions
    
    @IBAction func saveRestaurant(_ sender: UIButton) {
        
        guard let business = business,
            let managedContext = managedContext else {
                return
        }
        let businessId = business.identifier
        
        // Check if businessId has already been stored in Core Data
        var count = 0
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "businessId == %@", businessId)
        do {
            count = try managedContext.count(for: fetchRequest)
        } catch let error as NSError {
            print("Error while trying to check if object with businessId \(businessId) already exists in Core Data: \(error.localizedDescription)")
        }
        
        if count == 0 {
            saveRestaurant(withBusinessId: businessId)
            favoriteButton.setImage(UIImage(named: "heart_full"), for: .normal)
        } else {
            deleteRestaurant(withBusinessId: businessId)
            favoriteButton.setImage(UIImage(named: "heart_empty"), for: .normal)
        }
    }
    
    private func saveRestaurant(withBusinessId businessId: String) {
        guard let managedContext = managedContext else { return }
        
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
    
    private func deleteRestaurant(withBusinessId businessId: String) {
        guard let managedContext = managedContext else { return }
        
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

extension Details: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restrictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RatingsCells
        cell.rating?.image = UIImage(named: "stars_green.png")
        cell.restriction?.text = restrictions[indexPath.row]
        return cell
    }
    
}
