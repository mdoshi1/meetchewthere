//
//  Details.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class Details: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurant: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    var business: YLPBusiness?
    var restImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self 
        tableView.separatorColor = .clear
        
        if let business = business {
            titleName.text = business.name
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
        
        print(self.parent)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    /*override var prefersStatusBarHidden: Bool{
        return true
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restrictions.count
    }
    let restrictions = ["Vegan", "Dairy"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RatingsCells
        cell.rating?.image = UIImage(named: "ratings.png")
        cell.restriction?.text = restrictions[indexPath.row]
        return cell
    }
  

    /*@IBAction func close(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwind", sender: nil)
    }*/
}
