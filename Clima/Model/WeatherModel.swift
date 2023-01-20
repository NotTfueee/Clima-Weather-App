//
//  WeatherModel.swift
//  Clima
//
//  Created by Anurag Bhatt on 02/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel
{
    let conditionid : Int
    let cityName : String
    let temp : Double
    
    
    var tempratureString : String
    {
        return String(format:"%0.1f",temp)
    }
    
    var conditionName : String {
        
        switch (conditionid)
        {
        case 200...232 :
            return "cloud.bolt.rain"
            
        case 300...321 :
            return "cloud.drizzle"
            
        case 500...531 :
            return "cloud.rain"
            
        case 600...622 :
            return "cloud.snow"
            
        case 700...781 :
            return "cloud.fog"
            
        case 800:
            return "sun.max"
            
        case 801...804 :
            return "cloud.bolt"
            
        default:
            return "sun.max"
        }
        
    }
}
