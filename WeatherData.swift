//
//  WeatherData.swift
//  Clima
//
//  Created by Saajith Zain on 11/7/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
  
    let id: Int
    let name: String
    let weather: [Weather]
    let main: Temperature
    
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}


struct Temperature : Codable{
    let temp: Double
}
