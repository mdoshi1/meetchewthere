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
    var restaurantName = ""
    @IBOutlet weak var bgImage: UIImageView!
    var imageName = ""
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var restaurant: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageName)
        bgImage.image = UIImage(named: imageName)
        restaurant.image = UIImage(named: imageName)
        titleName.text = restaurantName
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
        
        tableView.dataSource = self
        tableView.delegate = self 
        tableView.separatorColor = .clear
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
  

    @IBAction func close(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwind", sender: nil)
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
