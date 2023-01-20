//
//  ViewController.swift
//  Clima
//
//  Created by Anurag Bhatt on 02/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController
{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var search: UITextField!
    
    var weathermanager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        
        locationManager.requestLocation()
        
        weathermanager.delegate = self
        search.delegate = self
        
    }
    
    
    @IBAction func gps(_ sender: UIButton) {
        
        
        locationManager.requestLocation()
        
        
    }
    
    
    // MARK: - UITextFieldDelegate
    
    
}

extension WeatherViewController : UITextFieldDelegate
{
    @IBAction func searchButton(_ sender: UIButton) {
        
        search.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if search.text != ""
        {
            return true
        }
        else
        {
            search.placeholder = "Enter a Place on Earth"
            return false
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = search.text
        {
            weathermanager.fetchWeather(cityname: city)
        }
        
        search.text = ""
    }
}

// MARK: - WeatherManagerDelegate


extension WeatherViewController : WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel) {
        
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    
    func didFail(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate


extension WeatherViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
       if let location = locations.last
        {
           locationManager.stopUpdatingLocation()
           let lat = location.coordinate.latitude
           let long = location.coordinate.longitude
           
           weathermanager.fetchWeather(latitude: lat , longitude : long)
       }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

