//
//  Discover.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Michael-Anthony Doshi. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import YelpAPI
import FacebookCore

class Discover: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties
    
    private lazy var footerView: UIView = {
        let width = self.view.frame.width
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 64.0))
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1.0))
        borderView.backgroundColor = self.tableView.separatorColor
        footerView.addSubview(borderView)
        let loadMoreButton = UIButton(frame: CGRect(x: width / 2.0 - 75.0, y: 7.0, width: 150.0, height: 50.0))
        loadMoreButton.layer.cornerRadius = 5.0
        loadMoreButton.layer.borderWidth = 2.0
        loadMoreButton.layer.borderColor = UIColor.chewGreen.cgColor
        loadMoreButton.setTitle("See More", for: .normal)
        loadMoreButton.setTitleColor(.black, for: .normal)
        loadMoreButton.titleLabel!.font = UIFont.systemFont(ofSize: 16.0)
        loadMoreButton.addTarget(self, action: #selector(loadMoreBusinesses), for: .touchUpInside)
        footerView.addSubview(loadMoreButton)
        return footerView
    }()
    
    fileprivate let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    var business: YLPBusiness?
    
    let defaultSearchTerm = "Food"
    var lastSearchedRestrictionTerm = ""
    var lastSearchedTerm = ""
    
    fileprivate var currentCoordinates: CLLocationCoordinate2D?
    fileprivate let kCLLocationAccuracy = 50.0
    
    // MARK: - DiscoverViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location services
        setupLocationServices()
        
        // Set custom back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Setup notifications
        NotificationCenter.default.addObserver(self, selector: #selector(initialSearch), name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
        
        // Assign delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.tableFooterView = footerView
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let businessIndex = randBusiness()
            if let cell = tableView.cellForRow(at: IndexPath(row: businessIndex, section: 0)) {
                performSegue(withIdentifier: "toDetails", sender: cell)
            } else {
                business = BusinessManager.shared.businesses[businessIndex]
                performSegue(withIdentifier: "toDetails", sender: nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func randBusiness() -> Int {
        return Int(arc4random_uniform(UInt32(BusinessManager.shared.businesses.count)))
    }
    
    func setupLocationServices() {
        AppDelegate.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            AppDelegate.locationManager.delegate = self
            AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracy
            AppDelegate.locationManager.requestLocation()
        }
    }
    
    // MARK: - Button Actions
    
    func loadMoreBusinesses() {
        if let coordinates = currentCoordinates {
            yelpSearch(withCoordinates: coordinates, term: lastSearchedTerm, limit: 20, offset: UInt(BusinessManager.shared.businesses.count))
        } else {
            yelpSearch(withLocation: "Stanford, CA", term: lastSearchedTerm, limit: 20, offset: UInt(BusinessManager.shared.businesses.count))
        }
    }
    
    // MARK: - Notification Actions
    
    func initialSearch() {
        AppDelegate.locationManager.requestLocation()
        if let userId = UserProfile.current?.userId {
            Webservice.getRestrictions(forUserId: userId, completion: { jsonDictionary in
                guard let dictionary = jsonDictionary else {
                    print("Restrictions response could not be parsed as a JSON dictionary")
                    return
                }
                DispatchQueue.main.async {
                    if let restrictionsArray = dictionary["rows"] as? [JSONDictionary], restrictionsArray.count > 0 {
                        SessionManager.shared.restrictions.removeAll()
                        var restrictions: [String] = []
                        for index in 0..<restrictionsArray.count {
                            let restriction = restrictionsArray[index]["restriction"] as! String
                            restrictions.append(restriction)
                        }
                        SessionManager.shared.restrictions = restrictions
                    }
                    
                    if let coordinates = self.currentCoordinates {
                        self.yelpSearch(withCoordinates: coordinates, term: self.defaultSearchTerm, limit: 20, offset: 0)
                    } else {                    
                        self.yelpSearch(withLocation: "Stanford, CA", term: self.defaultSearchTerm, limit: 20, offset: 0)
                    }
                }
            })
        } else if let coordinates = currentCoordinates {
            yelpSearch(withCoordinates: coordinates, term: defaultSearchTerm, limit: 20, offset: 0)
        } else {
            yelpSearch(withLocation: "Stanford, CA", term: defaultSearchTerm, limit: 20, offset: 0)
        }
    }
    
    func yelpSearch(withLocation location: String, term: String, limit: UInt, offset: UInt) {
        searchBar.text = term
        let searchTerm = term + " " + SessionManager.shared.restrictions.joined(separator: " ")
        AppDelegate.sharedYLPClient.search(withLocation: location, term: searchTerm, limit: limit, offset: offset, sort: .bestMatched) { search, error in
            guard let search = search, error == nil else {
                print("Error getting initial search results: \(error?.localizedDescription)")
                return
            }
            print("Succesfully retrieved initial search results")
            DispatchQueue.main.async {
                if self.lastSearchedRestrictionTerm == searchTerm {
                    BusinessManager.shared.businesses += search.businesses
                    self.tableView.reloadData()
                } else {
                    self.lastSearchedTerm = term
                    self.lastSearchedRestrictionTerm = searchTerm
                    BusinessManager.shared.businesses.removeAll()
                    BusinessManager.shared.businesses = search.businesses
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPoint.zero, animated: true)
                }
                
            }
        }
    }
    
    func yelpSearch(withCoordinates coordinates: CLLocationCoordinate2D, term: String, limit: UInt, offset: UInt) {
        searchBar.text = term
        let searchTerm = term + " " + SessionManager.shared.restrictions.joined(separator: " ")
        let ylpCoordinate = YLPCoordinate(latitude: coordinates.latitude.rounded(), longitude: coordinates.longitude.rounded())
        
        
        AppDelegate.sharedYLPClient.search(with: ylpCoordinate, term: term, limit: limit, offset: offset, sort: .bestMatched) { search, error in
            guard let search = search, error == nil else {
                print("Error getting initial search results: \(error?.localizedDescription)")
                return
            }
            print("Succesfully retrieved initial search results")
            DispatchQueue.main.async {
                if self.lastSearchedRestrictionTerm == searchTerm {
                    BusinessManager.shared.businesses += search.businesses
                    self.tableView.reloadData()
                } else {
                    self.lastSearchedTerm = term
                    self.lastSearchedRestrictionTerm = searchTerm
                    BusinessManager.shared.businesses.removeAll()
                    BusinessManager.shared.businesses = search.businesses
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    // MARK: - Navigation
    
    @IBAction func prepareForUnwind(sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailController = segue.destination as! Details
        if let businessCell = sender as? BusinessCell {
            detailController.business = businessCell.business
            detailController.restImage = businessCell.businessImage.image
        } else {
            detailController.business = business
        }
    }
    
    // MARK: - Core Data
    
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

// MARK: - UITableView Methods
extension Discover: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let businesses = BusinessManager.shared.businesses
        guard businesses.count > 0 else {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusinessManager.shared.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        let businesses = BusinessManager.shared.businesses
        guard businesses.count > 0 else {
            print("Businesses array is nil")
            return cell
        }
        let business = businesses[indexPath.row]
        cell.business = business
        
        if SessionManager.shared.restrictions.count > 0 {
            cell.restrictionLabel.text = SessionManager.shared.restrictions[0]
        } else {
            cell.restrictionLabel.text = "No personal dietary restrictions"
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let businessCell = tableView.cellForRow(at: indexPath) {
            performSegue(withIdentifier: "toDetails", sender: businessCell)
        }
    }
}

// MARK: - UISearchBarDelegate
extension Discover: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        AppDelegate.locationManager.requestLocation()
        searchBar.setShowsCancelButton(true, animated: true)
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        view.removeGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let coordinates = currentCoordinates {
            yelpSearch(withCoordinates: coordinates, term: searchBar.text ?? "Food", limit: 20, offset: 0)
        } else {
            yelpSearch(withLocation: "Stanford, CA", term: searchBar.text ?? "", limit: 20, offset: 0)
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

extension Discover: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoordinates = manager.location?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            AppDelegate.locationManager.requestLocation()
        }
    }
    
    /*func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(title: "Cannot get current location", message: "There was an error trying to update your location. Please click OK to refresh", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            AppDelegate.locationManager.requestLocation()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }*/
}
