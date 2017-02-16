//
//  Discover.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class Discover: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var businesses: [YLPBusiness]? {
        didSet {
            let userInfo = ["businesses":businesses]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.UpdatedBusinessList), object: nil, userInfo: userInfo)
            
            tableView.reloadData()
        }
    }
    fileprivate let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    // MARK: - DiscoverViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(initialSearch), name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notification.ReceivedTokenNotification), object: nil)
    }
    
    func initialSearch() {
        YLPClient.sharedYLPClient.search(withLocation: "Stanford, CA", term: "food") { (search, error) in
            guard let search = search, error == nil else {
                print("OMG this sucks")
                return
            }
            print("OMG I'm a wizard")
            
            DispatchQueue.main.async {
                self.businesses = search.businesses
            }
        }
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    @IBAction func prepareForUnwind(sender: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        guard let businesses = businesses else {
            print("Businesses array is nil")
            return cell
        }
        let business = businesses[indexPath.row]
        cell.name.text = business.name
        cell.price.text = "$$"
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
        
        cell.restriction1.text = "Vegan"
        cell.restrictionRating1.image = UIImage(named: "stars_green.png")
        cell.restrictionRating2.image = UIImage(named: "stars_green.png")
        cell.restriction2.text = "Dairy"
        cell.distance.text = "3.2 miles"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailController = segue.destination as! Details
        if let indexPath = self.tableView.indexPathForSelectedRow,
            let businesses = businesses {
            
            if let cell = tableView.cellForRow(at: indexPath) as? BusinessCell {
                detailController.restImage = cell.restImage.image
            }
            
            detailController.business = businesses[indexPath.row]
        }
    }

}

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
            YLPClient.sharedYLPClient.search(withLocation: "Stanford, CA", term: searchTerm) { (search, error) in
                guard let search = search, error == nil else {
                    print("OMG this sucks")
                    return
                }
                print("OMG I'm a wizard")
                
                DispatchQueue.main.async {
                    self.businesses = search.businesses
                }
            }
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
