//
//  Surprise.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import YelpAPI

class Surprise: UIViewController {
    @IBOutlet weak var restaurant: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleName : UILabel!
    
    let data = FakeData()
    var businesses: [YLPBusiness]?
    var currBusiness: YLPBusiness?

    func randNumber() -> Int {
        if let businesses = businesses {
            return Int(arc4random_uniform(UInt32(businesses.count)))
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateBusinessList), name: NSNotification.Name(rawValue: Constants.Notification.UpdatedBusinessList), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let blah = tabBarController?.viewControllers?[0] as! UINavigationController
        if let b = blah.topViewController as? Discover {
            businesses = b.businesses
        }
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
            
            let randPlace = randNumber()
            print(randPlace)
            
            
            if let businesses = businesses {
                currBusiness = businesses[randPlace]
                performSegue(withIdentifier: "toDetails", sender: self)
            }
        }
    }
    
    /*override var prefersStatusBarHidden: Bool{
        return true
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailController = segue.destination as! Details
        detailController.business = currBusiness        
    }
    
    @IBAction func prepareForUnwind(sender: UIStoryboardSegue) {
        
    }
    
}
