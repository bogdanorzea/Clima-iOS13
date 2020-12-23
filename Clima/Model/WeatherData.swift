//
//  WeatherData.swift
//  Clima
//
//  Created by Bogdan Orzea on 12/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]

}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Main: Codable {
    let temp: Double
}
