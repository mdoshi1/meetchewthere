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
import FacebookCore

class Details: UIViewController {
    
    // MARK: - Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var businessImageView: UIImageView = {
        let businessImageView = UIImageView()
        businessImageView.backgroundColor = .chewDarkGray
        businessImageView.contentMode = .scaleAspectFit
        if let restImage = self.restImage {
            businessImageView.image = restImage
        } else if let imageURL = self.business?.imageURL {
            Webservice.getImage(withURL: imageURL, completion: { data in
                if let data = data {
                    DispatchQueue.main.async {
                        businessImageView.image = UIImage(data: data)
                    }
                }
            })
        }
        return businessImageView
    }()
    
    private lazy var restaurantLabel: UILabel = {
        let restaurantLabel = UILabel()
        restaurantLabel.textAlignment = .center
        if let business = self.business {
            restaurantLabel.text = business.name
        }
        restaurantLabel.font = UIFont.systemFont(ofSize: 36.0)
        return restaurantLabel
    }()
    
    private lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        if let business = self.business {
            let location = business.location
            addressLabel.text = location.address.joined(separator: " ")
            
        }
        return addressLabel
    }()
    
    private lazy var callButton: UIButton = {
        let callButton = UIButton()
        callButton.setBackgroundImage(UIImage(named: "phone"), for: .normal)
        return callButton
    }()
    
    private lazy var callLabel: UILabel = {
        let callLabel = UILabel()
        callLabel.text = "Call"
        return callLabel
    }()
    
    private lazy var callStackView: UIStackView = {
        let callStackView = UIStackView(arrangedSubviews: [self.callButton.usingAutolayout(), self.callLabel.usingAutolayout()])
        callStackView.axis = .vertical
        callStackView.alignment = .center
        callStackView.spacing = 8.0
        return callStackView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setBackgroundImage(UIImage(named: "heart_empty"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteRestaurant), for: .touchUpInside)
        return favoriteButton
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let favoriteLabel = UILabel()
        favoriteLabel.text = "Favorite"
        return favoriteLabel
    }()
    
    private lazy var favoriteStackView: UIStackView = {
        let favoriteStackView = UIStackView(arrangedSubviews: [self.favoriteButton.usingAutolayout(), self.favoriteLabel.usingAutolayout()])
        favoriteStackView.axis = .vertical
        favoriteStackView.alignment = .center
        favoriteStackView.spacing = 8.0
        return favoriteStackView
    }()
    
    private lazy var websiteButton: UIButton = {
        let websiteButton = UIButton()
        websiteButton.setBackgroundImage(UIImage(named: "website"), for: .normal)
        return websiteButton
    }()
    
    private lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.text = "Website"
        return websiteLabel
    }()
    
    private lazy var websiteStackView: UIStackView = {
        let websiteStackView = UIStackView(arrangedSubviews: [self.websiteButton.usingAutolayout(), self.websiteLabel.usingAutolayout()])
        websiteStackView.axis = .vertical
        websiteStackView.alignment = .center
        websiteStackView.spacing = 8.0
        return websiteStackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let infoStackView = UIStackView(arrangedSubviews: [self.callStackView.usingAutolayout(), self.favoriteStackView.usingAutolayout(), self.websiteStackView.usingAutolayout()])
        infoStackView.axis = .horizontal
        infoStackView.spacing = 32.0
        return infoStackView
    }()
    
    private lazy var restrictionsTable: IntrinsicTableView = {
        let restrictionsTable = IntrinsicTableView()
        restrictionsTable.dataSource = self
        restrictionsTable.delegate = self
        restrictionsTable.separatorColor = .clear
        restrictionsTable.bounces = false
        restrictionsTable.register(UINib(nibName: "RatingsCell", bundle: nil), forCellReuseIdentifier: "RatingsCell")
        return restrictionsTable
    }()
    
    private lazy var reviewButton: UIButton = {
        let reviewButton = UIButton()
        reviewButton.setTitle("Leave A Review", for: .normal)
        reviewButton.setTitleColor(.white, for: .normal)
        reviewButton.backgroundColor = .chewGreen
        reviewButton.addTarget(self, action: #selector(reviewRestaurant), for: .touchUpInside)
        return reviewButton
    }()
    
    var business: YLPBusiness?
    var restImage: UIImage?
    var managedContext: NSManagedObjectContext?
    
    // TODO: Remove in favor of real data
    fileprivate let restrictions = ["Nuts", "Dairy"]
    
    // MARK: Details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change back button to white
        navigationController?.navigationBar.tintColor = .white
        
        // Initialize NSManagedObjectContext
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        } else {
            managedContext = nil
        }
        
        // Setup views
        view.addSubview(scrollView.usingAutolayout())
        scrollView.addSubview(businessImageView.usingAutolayout())
        scrollView.addSubview(restaurantLabel.usingAutolayout())
        scrollView.addSubview(restrictionsTable.usingAutolayout())
        scrollView.addSubview(addressLabel.usingAutolayout())
        scrollView.addSubview(infoStackView.usingAutolayout())
        scrollView.addSubview(reviewButton.usingAutolayout())
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: - Helper Methods
    private func setupConstraints() {
        
        // Scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
        
        // Business Image View
        NSLayoutConstraint.activate([
            businessImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            businessImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            businessImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            businessImageView.heightAnchor.constraint(equalToConstant: 200.0)
            ])
        
        // Restaurant Label
        NSLayoutConstraint.activate([
            restaurantLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            restaurantLabel.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 8.0),
            restaurantLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8.0),
            restaurantLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8.0)
            ])
        
        // Address Label
        NSLayoutConstraint.activate([
            addressLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8.0),
            addressLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8.0),
            addressLabel.topAnchor.constraint(equalTo: restaurantLabel.bottomAnchor, constant: 8.0)
            ])
        
        // Call Button
        NSLayoutConstraint.activate([
            callButton.widthAnchor.constraint(equalToConstant: 50.0),
            callButton.heightAnchor.constraint(equalTo: callButton.widthAnchor)
            ])
        
        // Favorite Button
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 50.0),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
            ])
        
        // Website Button
        NSLayoutConstraint.activate([
            websiteButton.widthAnchor.constraint(equalToConstant: 50.0),
            websiteButton.heightAnchor.constraint(equalTo: websiteButton.widthAnchor)
            ])
        
        // StackViews
        NSLayoutConstraint.activate([
            callStackView.widthAnchor.constraint(equalTo: favoriteStackView.widthAnchor),
            websiteStackView.widthAnchor.constraint(equalTo: favoriteStackView.widthAnchor)
            ])
        
        // Info StackView
        NSLayoutConstraint.activate([
            infoStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            infoStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16.0)
            ])
        
        // Restrictions TableView
        NSLayoutConstraint.activate([
            restrictionsTable.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 16.0),
            restrictionsTable.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            restrictionsTable.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            restrictionsTable.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        // Review Button
        NSLayoutConstraint.activate([
            reviewButton.topAnchor.constraint(equalTo: restrictionsTable.bottomAnchor),
            reviewButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            reviewButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            reviewButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            reviewButton.heightAnchor.constraint(equalToConstant: 64.0)
            ])
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview" {
            let destinationVC = segue.destination as! UINavigationController
            let reviewVC = destinationVC.childViewControllers[0] as! ReviewViewController
            //reviewVC.navigationItem.title = titleName.text
            reviewVC.restrictions = restrictions
            if let businessId = business?.identifier {
                reviewVC.businessId = businessId
            } else {
                print("Business doesn't have an identifier")
            }
        }
    }
    
    // MARK: Button Actions
    
    func reviewRestaurant() {
        if UserProfile.current != nil {
            performSegue(withIdentifier: "toReview", sender: nil)
        } else {
            let alertController = UIAlertController(title: "You're not logged in", message: "Log in to leave a review for this restaurant", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func favoriteRestaurant() {
        
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

// MARK:- UITableView Methods

extension Details: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restrictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingsCell", for: indexPath) as! RatingsCell
        cell.restriction.text = restrictions[indexPath.row]
        return cell
    }
    
}
