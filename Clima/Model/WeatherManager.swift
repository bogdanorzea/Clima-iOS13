//
//  WeatherManager.swift
//  Clima
//
//  Created by Bogdan Orzea on 12/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cfd523f0ab4aeae31a7254fdaa2f68c7&units=metric"
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"

        performRequest(with: urlString)
    }

    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"

        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        // 1 Create URL
        if let url = URL(string: urlString) {
            // 2 Create a URLSession
            let session = URLSession(configuration: .default)
            // 3 GIve the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4 Start the task
            task.resume()
        }
    }

    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)

            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)

            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
