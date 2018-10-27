//
//  MasterViewController.swift
//  weather-forecast-extension
//
//  Created by Klaudia on 10/16/18.
//  Copyright © 2018 Klaudia. All rights reserved.
//

import UIKit

struct City {
    let name : String?
    let latitudeWithLongitude : String?
}

class MasterViewController: UITableViewController, SearchDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
   
    private var cities: Dictionary<String, String> = ["Warsaw": "50.0646501,19.9449799",
                                                     "Montevideo": "-34.901112,-56.164532",
                                                     "Sydney": "-33.865143,151.209900"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func searchResult(cityName: String) {
        self.cities[cityName] = dataBase[cityName]
        self.tableView.reloadData()
    }
    

    // MARK: - Segues

    @objc func insertNewObject(_ sender: Any) {
        
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        searchVC.delegate = self
        self.present(searchVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.cityName = Array(self.cities.keys)[indexPath.row]
                controller.cityCoordinates = self.cities[Array(self.cities.keys)[indexPath.row]]!
                controller.navigationItem.title = Array(self.cities.keys)[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = Array(self.cities.keys)[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

