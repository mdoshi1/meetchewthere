//
//  Surprise.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class Surprise: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurant: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleName : UILabel!
    
    let data = FakeData()
    var businesses: [YLPBusiness]?

    func randNumber() -> Int {
        if let businesses = businesses {
            return Int(arc4random_uniform(UInt32(businesses.count)))
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        self.view.addSubview(restaurantView)
        restaurantView.isHidden = true
        restaurantView.center.y = self.view.bounds.height + self.view.bounds.height/2

        NotificationCenter.default.addObserver(self, selector: #selector(updateBusinessList), name: NSNotification.Name(rawValue: Constants.Notification.UpdatedBusinessList), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notification.UpdatedBusinessList), object: nil)
    }
    
    func updateBusinessList(_ notification: Notification) {
        if let businesses = notification.userInfo?["businesses"] as? [YLPBusiness]? {
            self.businesses = businesses
        }
    }

    // shake device to generate random place
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("shake")
            restaurantView.isHidden = false
            restaurantView.center = self.view.center
            restaurantView.bounds = self.view.bounds
            
            let randPlace = randNumber()
            print(randPlace)
            let entry = data.places[randPlace]
            restaurant.image = UIImage(named: entry.restImage)
            titleName.text = entry.title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restrictions.count
    }
    let restrictions = ["Vegetarian","Vegan", "Dairy", "Gluten Free"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RatingsCells
        cell.rating?.image = UIImage(named: "ratings.png")
        cell.restriction?.text = restrictions[indexPath.row]
        return cell
    }
    override var prefersStatusBarHidden: Bool{
        return true
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
