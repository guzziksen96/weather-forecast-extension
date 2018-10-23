//
//  DetailViewController.swift
//  weather-forecast-extension
//
//  Created by Klaudia on 10/16/18.
//  Copyright © 2018 Klaudia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // let detailItem ???
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    //MARK: Properties
    @IBOutlet weak var timezone: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var precipitation: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var pictogram: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    private var myData: [Data]?
    private var index: Int = 0
    
    @IBAction func displayNextDayForecastWeather(_ sender: UIButton) {
        self.previousButton.isEnabled = true
        if((myData?.count)! > index + 1){
            index = index + 1
            displayData(data: myData![self.index])
        }else{
            displayAlert(text: "next")
            if(index == (myData?.count)! - 1){
                self.nextButton.isEnabled = false
            }
        }
    }
    
    @IBAction func displayPreviousDayForecastWeather(_ sender: UIButton) {
        self.nextButton.isEnabled = true
        if(index - 1 > 0){
            index = index - 1
            displayData(data: myData![self.index])
        } else{
            displayAlert(text: "previous")
            if(index == 1){
                self.previousButton.isEnabled = false
            }
        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData { [weak self] weatherForecast in
            guard let self = self, let fetchData = weatherForecast.daily?.data?[self.index] else {
                return
            }
            
            self.myData = weatherForecast.daily?.data
            self.displayData(data: fetchData)
            
            self.timezone.text = weatherForecast.timezone
        }
        configureView()
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    private func displayData(data: Data) {
        
        pictogram.contentMode = .scaleAspectFit
        pictogram.image = weatherPictogramFromString(stringIcon: data.icon)
        maxTemp.text = String(data.temperatureMax!)
        minTemp.text = String(data.temperatureMin!)
        pressure.text = String(data.pressure!)
        precipitation.text = String(data.precipIntensity!)
        summary.text = data.summary
        windSpeed.text = String(data.windSpeed!)
        windDirection.text = windDirectionFromBearing(bearingWing: Double(data.windBearing!))
        date.text = convertTimestampToDate(time: data.time!)
        
    }
    
    private var cities = ["Warsaw": "50.0646501,19.9449799",
                          "Montevideo": "-34.901112,-56.164532",
                          "Sydney": "-33.865143,151.209900"]
    
    private func getData (completion: @escaping (WeatherForecastBase) -> Void) {
        let url = "https://api.darksky.net/forecast/813dcd329357b2039f8650fbf84c481e/" + cities["Montevideo"]!
        
        let weatherForecastUrl = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: weatherForecastUrl) {(data, response, error) in
            guard let fetchedData = data else {
                return
            }
            
            do {
                let weatherForecast = try JSONDecoder().decode(WeatherForecastBase.self, from: fetchedData)
                
                DispatchQueue.main.async() {
                    completion(weatherForecast)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func convertTimestampToDate(time: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    
    private func windDirectionFromBearing(bearingWing: Double) -> String {
        let windDirection : String
        if (348.75 <= bearingWing && bearingWing <= 360) {
            windDirection = "N";
        } else if (0 <= bearingWing && bearingWing <= 11.25) {
            windDirection = "N";
        } else if (11.25 < bearingWing && bearingWing <= 33.75) {
            windDirection = "NNE";
        } else if (33.75 < bearingWing && bearingWing <= 56.25) {
            windDirection = "NE";
        } else if (56.25 < bearingWing && bearingWing <= 78.75) {
            windDirection = "ENE";
        } else if (78.75 < bearingWing && bearingWing <= 101.25) {
            windDirection = "E";
        } else if (101.25 < bearingWing && bearingWing <= 123.75) {
            windDirection = "ESE";
        } else if (123.75 < bearingWing && bearingWing <= 146.25) {
            windDirection = "SE";
        } else if (146.25 < bearingWing && bearingWing <= 168.75) {
            windDirection = "SSE";
        } else if (168.75 < bearingWing && bearingWing <= 191.25) {
            windDirection = "S";
        } else if (191.25 < bearingWing && bearingWing <= 213.75) {
            windDirection = "SSW";
        } else if (213.75 < bearingWing && bearingWing <= 236.25) {
            windDirection = "SW";
        } else if (236.25 < bearingWing && bearingWing <= 258.75) {
            windDirection = "WSW";
        } else if (258.75 < bearingWing && bearingWing <= 281.25) {
            windDirection = "W";
        } else if (281.25 < bearingWing && bearingWing <= 303.75) {
            windDirection = "WNW";
        } else if (303.75 < bearingWing && bearingWing <= 326.25) {
            windDirection = "NW";
        } else if (326.25 < bearingWing && bearingWing < 348.75) {
            windDirection = "NNW";
        } else {
            windDirection = "SW";
        }
        return windDirection;
    }
    
    private func weatherPictogramFromString(stringIcon: String?) -> UIImage {
        guard let stringIcon = stringIcon else {
            return UIImage(named: "clear-day")!
        }
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "clear-day"
        }
        
        let iconImage = UIImage(named: imageName)
        return iconImage!
        
    }
    
    private func displayAlert(text: String){
        let alert = UIAlertController(title: "There is not data for " + text + " day", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }


}

