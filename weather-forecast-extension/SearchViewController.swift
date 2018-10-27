//
//  ViewController.swift
//  weather-forecast-extension
//
//  Created by Klaudia on 27/10/2018.
//  Copyright © 2018 Klaudia. All rights reserved.
//

import UIKit

protocol SearchDelegate {
    func searchResult(cityName: String)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
    var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.delegate?.searchResult(cityName: self.searchResult)
        self.dismiss(animated: true, completion: nil)
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
        self.resultsTableVIew.reloadSections(IndexSet(integer: 0), with: .left)
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
