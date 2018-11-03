//
//  ViewController.swift
//  weather-forecast-extension
//
//  Created by Klaudia on 27/10/2018.
//  Copyright © 2018 Klaudia. All rights reserved.
//

import UIKit
import MapKit

protocol SearchDelegate {
    func searchResult(cityName: String)
    func addLocation(location: CLLocation)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultsTableVIew: UITableView! {
        didSet {
            resultsTableVIew.delegate = self
            resultsTableVIew.dataSource = self
        }
    }
    
    var delegate: SearchDelegate?
    private var searchResult = ""
    var results: [String] = ["Current location"]
    let locationManager = CLLocationManager()
    var currentLocation: [String:String] = [:]
    var gotFirstLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if searchResult == "Current location" {
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        } else {
            self.delegate?.searchResult(cityName: self.searchResult)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if gotFirstLocation {
            gotFirstLocation = false
            self.delegate?.addLocation(location: CLLocation(latitude: locValue.latitude, longitude: locValue.longitude))
            self.fetchCityAndCountry(from: manager.location!) { city, country, error in
                guard let city = city, let country = country, error == nil else {
                    self.showOkAlert(error: error!, city: "")
                    return
                }
                self.showOkAlert(error: nil, city: city + "," + country)
            }
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func showOkAlert(error: Error?, city: String) {
        var alert = UIAlertController()
        if error != nil {
            alert = UIAlertController(title: "Error", message: "Could not convert coordinates to name." + error!.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Location", message: "You are currently in: " + city , preferredStyle: .alert)
        }
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            alert.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.cityNameLabel.text = self.results[indexPath.row]
        if cell.cityNameLabel.text == self.searchResult {
            cell.tickImageVIew.alpha = 1
        } else {
            cell.tickImageVIew.alpha = 0
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyArray = Array(dataBase.keys)
        self.results = keyArray.filter { (key) -> Bool in
            if key.contains(searchText) {
                return true
            } else {
                return false
            }
        }
        self.results.insert("Current location", at: 0)
        self.resultsTableVIew.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        if cell.tickImageVIew.alpha == 1 {
            cell.tickImageVIew.alpha = 0
            self.searchResult = ""
        } else {
            cell.tickImageVIew.alpha = 1
            self.searchResult = results[indexPath.row]
        }
        self.resultsTableVIew.reloadData()
    }
}
