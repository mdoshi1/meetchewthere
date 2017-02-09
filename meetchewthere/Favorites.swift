//
//  Favorites.swift
//  meetchewthere
//
//  Created by Alejandrina Gonzalez on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class Favorites: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let data = FakeData()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantCell
        let entry = data.places[indexPath.row]
        cell.title?.text = entry.title
        cell.restImage?.image = UIImage(named: entry.restImage)
        cell.rating?.image = UIImage(named: entry.ratings)
        cell.distance?.text = entry.distance
        cell.restrictions?.text = entry.restrictions
        cell.backgroundColor = .clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.performSegue(withIdentifier: "details", sender: nil)
    }
    //var imageName: String!
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let detailController = segue.destination as! Details
//        if let indexPath = self.tableView.indexPathForSelectedRow{
//            imageName = data.places[indexPath.row].restImage
//            detailController.restaurantName = data.places[indexPath.row].title
//            detailController.imageName = imageName
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
