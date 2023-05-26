//
//  WeatherManager.swift

//  Created by Heba Thabet Agha
//

import Foundation
import CoreLocation


protocol WeatherManagerDeleget {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let wetherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1a289ec66243dff001f261e6e3d9d19f&units=metric"
    
    var deleget: WeatherManagerDeleget?
    
    func fechWeather(cityName: String) {
        let urlString = "\(wetherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fechWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(wetherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
        print(urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        if  let url = URL(string: urlString)
        {
            
            // 2.Create a URL Session (it's like the browser)vn
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            // completionHandler is triggered by the task So when this session completes its networking and the task is complete, it is the one that will call the completionHandler.
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if error != nil {
                    deleget?.didFailWithError(error: error!)
                    return
                }
                if let safedata = data {
                    if  let weather =  parseJSON(weatherdata: safedata){
                        deleget?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            
            //4.Start the task
            // because new task is suspeinded we need to start it
            task.resume()
        }
    }
    
    // Working with JSON
    func parseJSON(weatherdata: Data)->WeatherModel?{
        let decoder = JSONDecoder()
        // it's expecting a type
        do {
            let decodedData = try  decoder.decode(WeatherData.self, from: weatherdata)
            let id =  decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            let weather = WeatherModel(cityName: city, ConditionId: id, temp: temp)
            let image = weather.conditionName
            return weather
           
        }
        catch {
            deleget?.didFailWithError(error: error)
            return nil
        }
    }
}

