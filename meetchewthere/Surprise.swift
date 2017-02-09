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
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var restaurant: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleName : UILabel!
    let data = FakeData()

    func randNumber() -> Int {
        return Int(arc4random_uniform(UInt32(data.places.count)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        self.view.addSubview(restaurantView)
        restaurantView.isHidden = true
        restaurantView.center.y = self.view.bounds.height + self.view.bounds.height/2


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
            bgImage.image = UIImage(named: entry.restImage)
            titleName.text = entry.title
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = (bgImage?.bounds)!
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // blurEffectView.alpha = 0.7
            bgImage.addSubview(blurEffectView)
            // Create the gradient layer
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [
                UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor,
                UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).cgColor]
            // Whatever direction you want the fade. You can use gradientLayer.locations
            // to provide an array of points, with matching colors for each point,
            // which lets you do other than just a uniform gradient.
            gradientLayer.locations = [0.0, 0.35]
            // Use the gradient layer as the mask
            bgImage.layer.mask = gradientLayer;
            

            
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
