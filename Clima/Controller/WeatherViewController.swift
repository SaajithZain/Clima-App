//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
   
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK:- UITextViewDelegate

extension WeatherViewController : UITextFieldDelegate {
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text{
            weatherManager.fetchWeather(cityName: city)
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.text = "Search Something"
            return false
        }else{
           return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK:- WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate {
    
     func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
         DispatchQueue.main.async {
             self.temperatureLabel.text = weather.temperatureString
             self.cityLabel.text = weather.cityName
             self.conditionImageView.image = UIImage(systemName: weather.conditionName)
         }
        
         
     }
     
     func didFailWithError(error: Error) {
         print(error)
     }
        
}

//MARK:- CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
        print("Location fetched")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
