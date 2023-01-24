
//  Clima
//
//  Created by Anurag Bhatt on 02/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//
import Foundation
import CoreLocation

protocol WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager : WeatherManager , weather : WeatherModel)
    func didFail(error : Error)
}

struct WeatherManager
{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityname : String)
    {
        let urlString = ("\(weatherURL)&q=\(cityname)")
        performRequest (with : urlString)
    }
    
    func fetchWeather( latitude : CLLocationDegrees , longitude : CLLocationDegrees)
    {
        let urlString = ("\(weatherURL)&lat=\(latitude)&lon=\(longitude)")
        performRequest (with : urlString)
    }
    
    func performRequest ( with urlString : String)
    {
        // 1. Create A URL
        
        if let url = URL(string: urlString)
        {
            // 2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            
            //3. Give The Session A Task
            
            let task = session.dataTask(with: url) { data , response , error in
                
                if (error != nil) {
                    self.delegate?.didFail(error: error!)
                    return
                }
                
                if let safeData = data
                {
                   if let weather = self.parseJSON(safeData)
                    {
                       self.delegate?.didUpdateWeather(self,weather : weather)
                   }
                }
            }
            
            // 4. Start The Task
            
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionid: id, cityName: name, temp: temp)
            
            return weather
        }catch{
            delegate?.didFail(error: error)
            return nil
        }
    }
    
    
    
    
}
